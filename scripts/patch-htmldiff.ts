/**
 * Patch htmldiff
 *
 * https://services.w3.org/htmldiff is running `htmldiff` (the python script),
 * and it will execute `htmldiff.pl` in CLI (rather than CGI) mode.
 *
 * The commit version might be the following:
 * https://github.com/w3c/htmldiff-ui/blob/5eac9b073c66b24422df613a537da2ec2f97f457/htmldiff.pl
 *
 * ## Improve readability for `<pre>`
 *
 * This is a bug of htmldiff.
 *
 * When `<pre>` and `</pre>` is on the same line, `splitit` should set `$preformatted` to true, but not.
 * https://github.com/w3c/htmldiff-ui/blob/main/htmldiff.pl#L406-L412
 *
 * Additionally, `markit` will drop all characters after `<` for deleted (or replaced) lines.
 * As a result, htmldiff does not work as expected even if `$preformatted` has been set to true`.
 * https://github.com/w3c/htmldiff-ui/blob/5eac9b073c66b24422df613a537da2ec2f97f457/htmldiff.pl#L167-L168
 *
 * Therefore, let us ignore it…
 *
 * ## Replace the keyboard navigation script
 *
 * Replace it with src/htmldiff-nav.ts
 */

import { readFile, writeFile } from "node:fs/promises";
import path from "node:path";

import { BUILD_URL_BASE, ROOT_DIR } from "./config.ts";

const dist = path.join(ROOT_DIR, "dist");

const manifest = JSON.parse(
  await readFile(path.join(dist, ".vite/manifest.json"), { encoding: "utf-8" }),
);
const htmldiff_nav = manifest["src/htmldiff-nav.ts"].file as string;

const script =
  (await readFile(path.join(ROOT_DIR, "scripts/patch-htmldiff.template.js"), {
    encoding: "utf-8",
  }))
    .replace("{{ HTMLDIFF-NAV-SRC }}", `${BUILD_URL_BASE}${htmldiff_nav}`);

const index_html = path.join(dist, "index.html");

await writeFile(
  index_html,
  (await readFile(index_html, { encoding: "utf-8" })).replace(
    "</head>",
    `<script>${script}</script></head>`,
  ),
);
