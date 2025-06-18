import fs from "node:fs/promises";

import { concurrently } from "concurrently";

import { ASSETS_SERVER_PORT, extraArgs, ROOT_DIR } from "./config.ts";

const argv = process.argv.slice(2);

await fs.mkdir("dist", { recursive: true });

concurrently([
  {
    name: "precompile",
    command: [
      "node",
      "--experimental-strip-types",
      "scripts/precompile.ts",
      "--watch",
    ].join(" "),
  },
  {
    name: "assets",
    command: ["vite", `--port=${ASSETS_SERVER_PORT}`].join(" "),
  },
  {
    name: "main",
    command: [
      "typst",
      "--color=always",
      "watch",
      "index.typ",
      "dist/index.html",
      ...extraArgs.dev,
      ...argv,
    ].join(" "),
  },
], {
  prefix: "name",
  cwd: ROOT_DIR,
  killOthers: ["failure", "success"],
  prefixColors: "auto",
});
