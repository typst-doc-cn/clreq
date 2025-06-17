/**
 * Checks for duplicate issues.
 *
 * Most issues should be linked only once.
 * If an issue truly needs to be linked multiple times (e.g., it involves multiple problems),
 * add a note to clarify. For example:
 *
 * ```typst
 * #issue("hayagriva#189", note: [mentioned])
 * ```
 */

import { log, typst } from "./cli_util.ts";
import { precompileExtraArgs } from "./compile.ts";

const issues: { "repo-num": string; note: string }[] = JSON.parse(
  await typst("query", [
    "query",
    "main.typ",
    "<issue>",
    "--field=value",
    ...precompileExtraArgs,
  ]),
);

const suspiciousDest = issues.filter(({ note }) => note === "auto").map((
  { "repo-num": dest },
) => dest);
const duplicates = suspiciousDest.filter((item, index) =>
  suspiciousDest.indexOf(item) !== index
);

if (duplicates.length > 0) {
  console.error(
    "%cDuplicated issues found:",
    "color: red:",
    new Set(duplicates),
  );
  process.exit(1);
} else {
  console.log(log("All issues are unique.", "check"));
}
