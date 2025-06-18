import { fileURLToPath } from "node:url";

import { precompile } from "./precompile.ts";
import { typst } from "./typst.ts";
import { extraArgs } from "./config.ts";

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  await precompile();
  await typst([
    "compile",
    "index.typ",
    "dist/index.html",
    ...extraArgs.build,
  ]);
}
