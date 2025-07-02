import { env } from "node:process";
import { fileURLToPath } from "node:url";

import { extraArgs } from "./config.ts";
import { precompile } from "./precompile.ts";
import { typst } from "./typst.ts";
import { duration_fmt, execFile } from "./util.ts";

interface GitInfo {
  name: string;
  commit_url: string;
  log_url: string;
  /** latest git log */
  latest_log: string;
}

async function git_info(): Promise<GitInfo | null> {
  const git_log = execFile("git", [
    "log",
    "--max-count=1",
    "--pretty=fuller",
    "--date=iso",
  ]).then(({ stdout }) => stdout.trim());

  if (env.GITHUB_ACTIONS === "true") {
    // https://docs.github.com/en/actions/writing-workflows/choosing-what-your-workflow-does/store-information-in-variables#default-environment-variables
    const base = `${env.GITHUB_SERVER_URL}/${env.GITHUB_REPOSITORY}`;
    return {
      name: `${env.GITHUB_SHA?.slice(0, 8)} (${env.GITHUB_REF_NAME})`,
      commit_url: `${base}/commit/${env.GITHUB_SHA}`,
      log_url: `${base}/actions/runs/${env.GITHUB_RUN_ID}`,
      latest_log: await git_log,
    };
  } else if (env.NETLIFY === "true") {
    // https://docs.netlify.com/configure-builds/environment-variables/
    return {
      name: `${env.COMMIT_REF?.slice(0, 8)} (${env.HEAD})`,
      commit_url: `${env.REPOSITORY_URL}/commit/${env.COMMIT_REF}`,
      log_url:
        `https://app.netlify.com/sites/${env.SITE_NAME}/deploys/${env.DEPLOY_ID}`,
      latest_log: await git_log,
    };
  } else {
    return null;
  }
}

function as_input(info: GitInfo | null): string[] {
  return info ? ["--input", `git=${JSON.stringify(info)}`] : [];
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  await precompile();

  const timeStart = Date.now();
  await typst([
    "compile",
    "index.typ",
    "dist/index.html",
    ...as_input(await git_info()),
    ...extraArgs.build,
  ]);
  console.log(
    `🏛️ Built the document successfully in`,
    `${duration_fmt(Date.now() - timeStart)}.`,
  );
}
