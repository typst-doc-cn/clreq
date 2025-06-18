import { dirname } from "node:path";
import { fileURLToPath } from "node:url";

export const ROOT_DIR = dirname(dirname(fileURLToPath(import.meta.url)));

export const envArgs = [
  "--features=html",
  `--font-path=${ROOT_DIR}/fonts`,
];

export const ASSETS_SERVER_PORT = 5173;

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
    "x-url-base=/clreq/",
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
