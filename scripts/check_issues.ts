/**
 * Check issues mentioned in the document or reported in typst repositories.
 *
 * Save the report to `report.md` (`steps.{id}.outputs.report-file`) and `$GITHUB_STEP_SUMMARY` (if exists).
 *
 * All specified checks will be executed, even if an early check failed.
 *
 * Prerequisite: https://cli.github.com.
 */

import assert from "node:assert";
import { writeFile } from "node:fs/promises";
import { env } from "node:process";
import { fileURLToPath } from "node:url";

import { zip } from "es-toolkit";

import { extraArgs } from "./config.ts";
import { typst } from "./typst.ts";
import { duration_fmt, execFile } from "./util.ts";

interface RepoNum {
  repo: string;
  num: string;
}
interface IssueMeta extends RepoNum {
  note: string;
  closed: boolean;
}
interface PullMeta extends RepoNum {
  merged: boolean;
  rejected: boolean;
}

type IssueState =
  & { title: string }
  & ({
    state: "OPEN";
    stateReason: string | null;
    closed: false;
    closedAt: null;
  } | {
    state: "CLOSED";
    stateReason: string;
    closed: true;
    closedAt: string;
  });

type PullState =
  & { title: string }
  & (
    | {
      state: "OPEN";
      merged: false;
      closed: false;
      closedAt: null;
    }
    | { closed: true; closedAt: string }
      & ({
        state: "MERGED";
        merged: true;
      } | {
        state: "CLOSED";
        merged: false;
      })
  );

/**
 * Grouped by `repo` and `num`, and flattened
 *
 * E.g., an array of `[IssueMeta[] of an issue in a repo]`.
 */
type GroupedFlat<T extends RepoNum> = T[][];

/**
 * Grouped by `repo` and `num`
 *
 * repo ⇒ num ⇒ `T[]` of this repo and num.
 */
type Grouped<T extends RepoNum> = Map<string, [string, T[]][]>;

function flattenGrouped<T extends RepoNum>(
  grouped: Grouped<T>,
): GroupedFlat<T> {
  return Array.from(grouped.values()).flat().map(([_num, meta]) => meta);
}

function parseRepo(
  repo: string,
): { owner: string; name: string; repoSanitized: string } {
  const [owner, name] = repo.split("/", 2);
  const repoSanitized = repo.replaceAll(/[\/-]/g, "_");
  return { owner, name, repoSanitized };
}

/**
 * Error handling with the `Result` type.
 * https://doc.rust-lang.org/stable/std/result/
 */
class Result {
  succeeded: boolean;
  /** Markdown message */
  message: string;

  constructor(succeeded: boolean, message: string) {
    this.succeeded = succeeded;
    this.message = message;
  }

  static Ok(message: string): Result {
    return new Result(true, message);
  }

  static Err(message: string): Result {
    return new Result(false, message);
  }

  join(other: Result): Result {
    return new Result(
      this.succeeded && other.succeeded,
      [this.message, other.message].join("\n\n"),
    );
  }
}

/** Get issues and pull requests in the typst document. */
async function queryDocument(): Promise<
  { issues: IssueMeta[]; pulls: PullMeta[] }
> {
  const timeStart = Date.now();

  const data = JSON.parse(
    await typst([
      "query",
      "main.typ",
      "selector(<pull>).or(<issue>)",
      "--target=html",
      ...extraArgs.pre,
    ]),
  ) as { func: "metadata"; value: object; label: "<issue>" | "<pull>" }[];

  console.log(
    `📃 Got ${data.length} results from typst query successfully in`,
    `${duration_fmt(Date.now() - timeStart)}.`,
  );

  return {
    issues: data.filter((d) => d.label === "<issue>").map((d) =>
      d.value as IssueMeta
    ),
    pulls: data.filter((d) => d.label === "<pull>").map((d) =>
      d.value as PullMeta
    ),
  };
}

/**
 * Checks if there are any duplicate issues.
 *
 * Most issues should be linked only once.
 * If an issue truly needs to be linked multiple times (e.g., it involves multiple problems),
 * add a note to clarify. For example:
 *
 * ```typst
 * #issue("hayagriva#189", note: [mentioned])
 * ```
 */
function assertUniq(issues: IssueMeta[]): Result {
  const suspiciousDest = issues.filter(({ note }) => note === "auto").map((
    { repo, num },
  ) => `${repo}#${num}`);
  const duplicates = suspiciousDest.filter((item, index) =>
    suspiciousDest.indexOf(item) !== index
  );

  if (duplicates.length > 0) {
    return Result.Err(`Duplicated issues found:\n${new Set(duplicates)}`);
  } else {
    return Result.Ok("All issues are unique.");
  }
}

/**
 * Query GitHub GraphQL API using GitHub CLI.
 * https://docs.github.com/en/graphql/reference/queries
 */
async function queryGitHub(query: string): Promise<any> {
  const timeStart = Date.now();

  const { stdout } = await execFile("gh", [
    "api",
    "graphql",
    "--raw-field",
    `query=${query}`,
  ]);

  console.log(
    `📩 Got ${stdout.length} characters from GitHub API successfully in`,
    `${duration_fmt(Date.now() - timeStart)}.`,
  );

  return JSON.parse(stdout).data;
}

function groupByRepoNum<T extends RepoNum>(meta_list: T[]): Grouped<T> {
  const repos = new Set(meta_list.map((i) => i.repo));

  const grouped = new Map(
    Array.from(repos.values()).map(
      (repo) => {
        const concerned = meta_list.filter((i) => repo === i.repo);
        const numUniq = Array.from(
          (new Set(concerned.map(({ num }) => num))).values(),
        );
        return [
          repo,
          numUniq.map((n) =>
            [n, concerned.filter(({ num }) => n === num)] as [string, T[]]
          ),
        ];
      },
    ),
  );
  return grouped;
}

/**
 * @returns query The GraphQL query without wrapping `query { }`.
 * @returns grouped
 */
function generateIssuesQuery(
  issues: IssueMeta[],
): { query: string; grouped: GroupedFlat<IssueMeta> } {
  const grouped = groupByRepoNum(issues);

  const query = [
    ...Array.from(grouped.entries()).map(([repo, issues]) => {
      const { owner, name, repoSanitized } = parseRepo(repo);
      return [
        `  ${repoSanitized}_issues: repository(owner: "${owner}", name: "${name}") {`,
        ...issues.map(([num, _meta]) =>
          `    issue_${num}: issue(number: ${num}) { title state stateReason closed closedAt }`
        ),
        "  }",
      ];
    }),
  ].flat().join("\n");

  return { query, grouped: flattenGrouped(grouped) };
}

/**
 * @returns query The GraphQL query without wrapping `query { }`.
 * @returns grouped
 */
function generatePullsQuery(
  pulls: PullMeta[],
): { query: string; grouped: GroupedFlat<PullMeta> } {
  const grouped = groupByRepoNum(pulls);

  const query = [
    ...Array.from(grouped.entries()).map(([repo, pulls]) => {
      const { owner, name, repoSanitized } = parseRepo(repo);
      return [
        `  ${repoSanitized}_pulls: repository(owner: "${owner}", name: "${name}") {`,
        ...pulls.map(([num, _meta]) =>
          `    pull_${num}: pullRequest(number: ${num}) { title state merged closed closedAt }`
        ),
        "  }",
      ];
    }),
  ].flat().join("\n");

  return { query, grouped: flattenGrouped(grouped) };
}

/**
 * Fetch states of issues and pull requests.
 *
 * Duplicate issues or pull requests will be collected into a single entry.
 */
async function fetchStates(
  issues: IssueMeta[],
  pulls: PullMeta[],
): Promise<
  { issues: [IssueMeta[], IssueState][]; pulls: [PullMeta[], PullState][] }
> {
  const meta = {
    issues: generateIssuesQuery(issues),
    pulls: generatePullsQuery(pulls),
  };

  const query = [
    "query {",
    meta.issues.query,
    meta.pulls.query,
    "}",
  ].join("\n");

  const data = await queryGitHub(query) as Record<
    string,
    Record<string, IssueState | PullState>
  >;

  const stateFlat = Object.values(data).map((issues_or_pulls_of_repo) =>
    Object.values(issues_or_pulls_of_repo)
  ).flat();

  assert.strictEqual(
    stateFlat.length,
    meta.issues.grouped.length + meta.pulls.grouped.length,
  );

  const state = {
    issues: stateFlat.slice(0, meta.issues.grouped.length) as IssueState[],
    pulls: stateFlat.slice(meta.issues.grouped.length) as PullState[],
  };

  return {
    issues: zip(meta.issues.grouped, state.issues),
    pulls: zip(meta.pulls.grouped, state.pulls),
  };
}

/**
 * Checks if all issues’ states are up to date.
 *
 * Most issues should be open.
 * If a closed issue is truly needed (e.g., duplicated but cleaner),
 * add a note to clarify. For example:
 *
 * ```typst
 * #issue("hayagriva#189", closed: true)
 * ```
 */
function assertIssuesStateUpdated(states: [IssueMeta[], IssueState][]): Result {
  const outdated = states.filter(([meta, state]) =>
    meta.some((m) => m.closed !== state.closed)
  );

  if (outdated.length > 0) {
    const message = outdated.map(([meta, state]) => {
      const stateHuman = state.closed
        ? `closed at ${state.closedAt} for ${state.stateReason}`
        : `open${state.stateReason ? ` for ${state.stateReason}` : ""}`;

      const metaHuman = meta.map((m) =>
        `(note: ${m.note}, closed: ${m.closed})`
      ).join(" ");

      return [
        `- ${meta[0].repo}#${meta[0].num} ${state.title} (${stateHuman})`,
        `  ${metaHuman}`,
      ];
    }).flat().join("\n");
    return Result.Err(`Outdated issues found:\n${message}`);
  } else {
    return Result.Ok("All issues’ states are up to date.");
  }
}

/** Checks if all pull requests’ states are up to date. */
function assertPullsStateUpdated(states: [PullMeta[], PullState][]): Result {
  const outdated = states.filter(([meta, state]) =>
    meta.some((m) =>
      m.merged !== state.merged ||
      m.rejected !== (state.closed && !state.merged)
    )
  );

  if (outdated.length > 0) {
    const message = outdated.map(([meta, state]) => {
      const stateHuman = state.state === "OPEN"
        ? "open"
        : `${
          state.state.toLowerCase().replace("closed", "rejected")
        } at ${state.closedAt}`;
      return `- ${meta[0].repo}#${meta[0].num} ${state.title} (${stateHuman})`;
    }).join("\n");
    return Result.Err(`Outdated pull requests found:\n${message}`);
  } else {
    return Result.Ok("All pull requests’ states are up to date.");
  }
}

interface WatchTarget {
  repo: string;
  labels: string[];
}

type LatestIssue = {
  repo: string;
  num: string;
  title: string;
  stateReason: string | null;
};

/** Fetches latest open issues from multiple GitHub repositories. */
async function fetchLatestIssues(
  watches: WatchTarget[],
): Promise<LatestIssue[]> {
  const query = [
    "query {",
    ...watches.map(({ repo, labels }) => {
      const { owner, name, repoSanitized } = parseRepo(repo);
      return `
        ${repoSanitized}: repository(owner: "${owner}", name: "${name}") {
          issues(
            labels: ${JSON.stringify(labels)}
            first: 30,
            states: [OPEN],
            orderBy: { direction: DESC, field: UPDATED_AT }
          ) {
            nodes { number title stateReason }
          }
        }`;
    }),
    "}",
  ].join("\n");

  const data = await queryGitHub(query) as Record<
    string,
    {
      issues: {
        nodes: { number: number; title: string; stateReason: string | null }[];
      };
    }
  >;

  const dataFlat = Object.values(data).map((repo) => repo.issues.nodes);

  return watches.map(({ repo }, index) =>
    dataFlat[index].map(({ number, title, stateReason }) => ({
      repo,
      num: number.toString(),
      title,
      stateReason,
    }))
  ).flat();
}

/** Checks if all latest issues are covered in the document. */
function assertAllCovered(issues: IssueMeta[], latest: LatestIssue[]): Result {
  const uncovered = latest.filter(({ repo, num }) =>
    !issues.some((i) => i.repo === repo && i.num === num)
  );

  if (uncovered.length > 0) {
    const message = uncovered.map(({ repo, num, title, stateReason }) =>
      `- ${repo}#${num} ${stateReason ? `(${stateReason}) ` : ""}${title}`
    ).join("\n");
    return Result.Err(`Uncovered latest issues found:\n${message}`);
  } else {
    return Result.Ok("All latest issues are covered.");
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const argv = process.argv.slice(2);
  const checkAllCovered = argv.includes("--assert-all-covered");

  const { issues, pulls } = await queryDocument();

  let result = assertUniq(issues);

  const states = await fetchStates(issues, pulls);
  result = result.join(assertIssuesStateUpdated(states.issues));
  result = result.join(assertPullsStateUpdated(states.pulls));

  if (checkAllCovered) {
    const latest = await fetchLatestIssues([
      { repo: "typst/typst", labels: ["cjk"] },
      { repo: "typst/hayagriva", labels: ["i18n"] },
    ]);
    result = result.join(assertAllCovered(issues, latest));
  }

  await writeFile("report.md", result.message + "\n", { flag: "w" });
  if (env.GITHUB_OUTPUT) {
    await writeFile(env.GITHUB_OUTPUT, "report-file=report.md", { flag: "a" });
  }
  if (env.GITHUB_STEP_SUMMARY) {
    await writeFile(env.GITHUB_STEP_SUMMARY, result.message + "\n", {
      flag: "a",
    });
  }
  process.exit(result.succeeded ? 0 : 1);
}
