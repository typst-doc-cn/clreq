import { env } from "node:process";
import { fileURLToPath } from "node:url";

import { extraArgs } from "./config.ts";
import { precompile } from "./precompile.ts";
import { typst } from "./typst.ts";

function git_info(): string[] {
  if (env.GITHUB_ACTIONS === "true") {
    // https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#default-environment-variables
    const base = `${env.GITHUB_SERVER_URL}/${env.GITHUB_REPOSITORY}`;
    const info = {
      name: `${env.GITHUB_SHA?.slice(0, 8)} (${env.GITHUB_REF})`,
      commit_url: `${base}/commit/${env.GITHUB_SHA}`,
      log_url: `${base}/actions/runs/${env.GITHUB_RUN_ID}`,
    };
    return ["--input", `git=${JSON.stringify(info)}`];
  } else if (env.NETLIFY === "true") {
    // https://docs.netlify.com/configure-builds/environment-variables/
    const info = {
      name: `${env.COMMIT_REF?.slice(0, 8)} (${env.HEAD})`,
      commit_url: `${env.REPOSITORY_URL}/commit/${env.COMMIT_REF}`,
      log_url:
        `https://app.netlify.com/sites/${env.SITE_NAME}/deploys/${env.DEPLOY_ID}`,
    };
    return ["--input", `git=${JSON.stringify(info)}`];
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
    ...git_info(),
    ...extraArgs.build,
  ]);
}
