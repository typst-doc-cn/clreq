/**
 * Check issues.
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
 * @throws Exits the process with status code 1 if duplicates are found
 *
 * Most issues should be linked only once.
 * If an issue truly needs to be linked multiple times (e.g., it involves multiple problems),
 * add a note to clarify. For example:
 *
 * ```typst
 * #issue("hayagriva#189", note: [mentioned])
 * ```
 */
function assertUniq(issues: IssueMeta[]): void {
  const suspiciousDest = issues.filter(({ note }) => note === "auto").map((
    { repo, num },
  ) => `${repo}#${num}`);
  const duplicates = suspiciousDest.filter((item, index) =>
    suspiciousDest.indexOf(item) !== index
  );

  if (duplicates.length > 0) {
    console.error(
      "%cDuplicated issues found:",
      "color: red;",
      new Set(duplicates),
    );
    process.exit(1);
  } else {
    console.log("All issues are unique.");
  }
}

/***
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

  const { stdout } = await execFile("gh", [
    "api",
    "graphql",
    "--raw-field",
    `query=${query}`,
  ]);
  const data = JSON.parse(stdout).data as Record<
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
 * @throws Exits the process with status code 1 if outdated issues are found
 *
 * Most issues should be open.
 * If a closed issue is truly needed (e.g., duplicated but cleaner),
 * add a note to clarify. For example:
 *
 * ```typst
 * #issue("hayagriva#189", closed: true)
 * ```
 */
function assertStateUpdated(states: [IssueMeta[], IssueState][]): void {
  const outdated = states.filter(([meta, state]) =>
    meta.some((m) => m.closed !== state.closed)
  );

  if (outdated.length > 0) {
    console.error(
      "%cOutdated issues found:",
      "color: red;",
    );
    console.error(
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
    process.exit(1);
  } else {
    console.log("All issues’ states are up to date.");
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const issues: IssueMeta[] = await queryIssues();

  assertUniq(issues);

  const states = await fetchStates(issues);
  assertStateUpdated(states);
}
