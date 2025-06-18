import { env } from "node:process";
import { fileURLToPath } from "node:url";

import { extraArgs } from "./config.ts";
import { precompile } from "./precompile.ts";
import { typst } from "./typst.ts";

function github_info(): string[] {
  if (env.GITHUB_ACTIONS === "true") {
    // https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#default-environment-variables
    const base = `${env.GITHUB_SERVER_URL}/${env.GITHUB_REPOSITORY}`;
    const info = {
      name: `${env.GITHUB_SHA?.slice(0, 8)} (${env.GITHUB_REF})`,
      commit_url: `${base}/commit/${env.GITHUB_SHA}`,
      run_url: `${base}/actions/runs/${env.GITHUB_RUN_ID}`,
    };
    return ["--input", `github=${JSON.stringify(info)}`];
  } else {
    return [];
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  await precompile();
  await typst([
    "compile",
    "index.typ",
    "dist/index.html",
    ...github_info(),
    ...extraArgs.build,
  ]);
}
