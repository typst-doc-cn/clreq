import { dirname } from "node:path";
import { env } from "node:process";
import { fileURLToPath } from "node:url";

export const ROOT_DIR = dirname(dirname(fileURLToPath(import.meta.url)));

export const envArgs = [
  "--features=html",
  `--font-path=${ROOT_DIR}/fonts`,
];

export const ASSETS_SERVER_PORT = 5173;

export const BUILD_URL_BASE = env.NETLIFY === "true"
  ? env.DEPLOY_URL + "/" // patch htmldiff, or assets will go to services.w3.org
  : (env.GITHUB_PAGES_BASE ?? "/clreq/");

/** See typ/mode.typ */
export const extraArgs = {
  pre: [
    "--input",
    "mode=pre",
    ...envArgs,
  ],
  build: [
    "--input",
    "mode=build",
    "--input",
    `x-url-base=${BUILD_URL_BASE}`,
    ...envArgs,
  ],
  dev: [
    "--input",
    "mode=dev",
    "--input",
    `x-url-base=http://localhost:${ASSETS_SERVER_PORT}/`,
    ...envArgs,
  ],
};
