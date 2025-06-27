/**
 * Check issues mentioned in the document or reported in typst repositories.
 *
 * Prerequisite: https://cli.github.com.
 */

import assert from "node:assert";
import { execFile as _execFile } from "node:child_process";
import { fileURLToPath } from "node:url";
import { promisify } from "node:util";

import { extraArgs } from "./config.ts";
import { typst } from "./typst.ts";

const execFile = promisify(_execFile);

interface IssueMeta {
  repo: string;
  num: string;
  note: string;
  closed: boolean;
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

/** Get issues in the typst document. */
async function queryIssues(): Promise<IssueMeta[]> {
  return JSON.parse(
    await typst([
      "query",
      "main.typ",
      "<issue>",
      "--field=value",
      ...extraArgs.pre,
    ]),
  );
}

/**
 * Checks if there are any duplicate issues.
 *
 * @returns succeeded (no duplicates) or not
 *
 * Most issues should be linked only once.
 * If an issue truly needs to be linked multiple times (e.g., it involves multiple problems),
 * add a note to clarify. For example:
 *
 * ```typst
 * #issue("hayagriva#189", note: [mentioned])
 * ```
 */
function assertUniq(issues: IssueMeta[]): boolean {
  const suspiciousDest = issues.filter(({ note }) => note === "auto").map((
    { repo, num },
  ) => `${repo}#${num}`);
  const duplicates = suspiciousDest.filter((item, index) =>
    suspiciousDest.indexOf(item) !== index
  );

  if (duplicates.length > 0) {
    console.log(
      "%cDuplicated issues found:",
      "color: red;",
      new Set(duplicates),
    );
    return false;
  } else {
    console.log("All issues are unique.");
    return true;
  }
}

/**
 * Query GitHub GraphQL API using GitHub CLI.
 * https://docs.github.com/en/graphql/reference/queries
 */
async function queryGitHub(query: string): Promise<any> {
  const { stdout } = await execFile("gh", [
    "api",
    "graphql",
    "--raw-field",
    `query=${query}`,
  ]);
  return JSON.parse(stdout).data;
}

/**
 * Fetch states of issues.
 *
 * Duplicate issues will be collected into a single entry.
 */
async function fetchStates(
  issues: IssueMeta[],
): Promise<[IssueMeta[], IssueState][]> {
  const repos = new Set(issues.map((i) => i.repo));

  /** repo ⇒ [issue number, IssueMeta[]][] */
  const grouped: Map<string, [string, IssueMeta[]][]> = new Map(
    Array.from(repos.values()).map(
      (repo) => {
        const issuesConcerned = issues.filter((i) => repo === i.repo);
        const numUniq = Array.from(
          (new Set(issuesConcerned.map(({ num }) => num))).values(),
        );
        return [
          repo,
          numUniq.map((n) => [
            n,
            issuesConcerned.filter(({ num }) => n === num),
          ]),
        ];
      },
    ),
  );

  const query = [
    "query {",
    ...Array.from(grouped.entries()).map(([repo, issues]) => {
      const [owner, name] = repo.split("/", 2);
      const repoSanitized = repo.replaceAll(/[\/-]/g, "_");
      return [
        `  ${repoSanitized}: repository(owner: "${owner}", name: "${name}") {`,
        ...issues.map(([num, _meta]) =>
          `    issue_${num}: issue(number: ${num}) { title state stateReason closed closedAt }`
        ),
        "  }",
      ];
    }),
    "}",
  ].flat().join("\n");

  const data = await queryGitHub(query) as Record<
    string,
    Record<string, IssueState>
  >;

  const stateFlat = Object.values(data).map((issues_of_repo) =>
    Object.values(issues_of_repo)
  ).flat();
  const metaFlat = Array.from(grouped.values()).flat();

  assert.strictEqual(stateFlat.length, metaFlat.length);

  return metaFlat.map(([_num, meta], index) => [meta, stateFlat[index]]);
}

/**
 * Checks if all issues’ states are up to date.
 *
 * @returns succeeded (no outdated issue has been found) or not
 *
 * Most issues should be open.
 * If a closed issue is truly needed (e.g., duplicated but cleaner),
 * add a note to clarify. For example:
 *
 * ```typst
 * #issue("hayagriva#189", closed: true)
 * ```
 */
function assertStateUpdated(states: [IssueMeta[], IssueState][]): boolean {
  const outdated = states.filter(([meta, state]) =>
    meta.some((m) => m.closed !== state.closed)
  );

  if (outdated.length > 0) {
    console.log(
      "%cOutdated issues found:",
      "color: red;",
    );
    console.log(
      outdated.map(([meta, state]) => {
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
      }).flat().join(
        "\n",
      ),
    );
    return false;
  } else {
    console.log("All issues’ states are up to date.");
    return true;
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
      const [owner, name] = repo.split("/", 2);
      const repoSanitized = repo.replaceAll(/[\/-]/g, "_");
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

/**
 * Checks if all latest issues are covered in the document.
 *
 * @returns succeeded (no uncovered issue has been found) or not.
 */
function assertAllCovered(issues: IssueMeta[], latest: LatestIssue[]): boolean {
  const uncovered = latest.filter(({ repo, num }) =>
    !issues.some((i) => i.repo === repo && i.num === num)
  );

  if (uncovered.length > 0) {
    console.log(
      "%cUncovered latest issues found:",
      "color: red;",
    );
    console.log(
      uncovered.map(({ repo, num, title, stateReason }) =>
        `- ${repo}#${num} ${stateReason ? `(${stateReason}) ` : ""}${title}`
      ).join("\n"),
    );
    return false;
  } else {
    console.log("All latest issues are covered.");
    return true;
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const argv = process.argv.slice(2);
  const checkAllCovered = argv.includes("--assert-all-covered");

  // Make sure all tests will be ran, even if an early test failed.
  let succeeded = true;

  const issues = await queryIssues();
  succeeded = assertUniq(issues) && succeeded;

  const states = await fetchStates(issues);
  succeeded = assertStateUpdated(states) && succeeded;

  if (checkAllCovered) {
    const latest = await fetchLatestIssues([
      { repo: "typst/typst", labels: ["cjk"] },
      { repo: "typst/hayagriva", labels: ["i18n"] },
    ]);
    succeeded = assertAllCovered(issues, latest) && succeeded;
  }

  if (!succeeded) {
    process.exit(1);
  }
}
