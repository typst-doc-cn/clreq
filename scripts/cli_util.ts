import assert from "node:assert";
import { type SpawnOptions, spawn } from "node:child_process";
import { dirname } from "node:path";
import { fileURLToPath } from "node:url";

export const ROOT_DIR = dirname(dirname(fileURLToPath(import.meta.url)));

const lightGreen = "\x1b[32m";
const lightBlue = "\x1b[34m";
const reset = "\x1b[0m";

export const log = (line: string, id: string, color = lightGreen): string => `${color}[${id}]${reset} ${line}`;
export const mainHint = (line: string): string => log(line, "main", lightBlue);

/**
 * Prefix each line of the buffer with the identifier and a color.
 *
 * @param text - The buffer containing the output from the typst command
 * @param id - Identifier for the task process, used for logging
 * @returns - The formatted string with each line prefixed by the identifier
 */
function prefixScreen(text: string, id: string): string {
  const lines = text.trim().split("\n");
  return lines.map((line) => log(line, id)).join("\n");
}

/**
 * Run a typst command with the given arguments.
 *
 * @param id - Identifier for the task process, used for logging
 * @param args - Arguments to pass to the typst command
 * @param opts - Options for the spawn command
 * @returns  - Resolves with the output of the typst command
 */
export function typst(id: string, args: string[], opts: SpawnOptions & { stdin?: string; } = {}): Promise<string> {
  return new Promise((resolve, reject) => {
    const { stdin, ...spawn_opts } = opts;
    const proc = spawn("typst", args, spawn_opts);
    if (stdin) {
      assert(proc.stdin !== null);
      proc.stdin.write(stdin);
      proc.stdin.end();
    }
    assert(proc.stdout !== null);
    assert(proc.stderr !== null);

    const result: Buffer[] = [];
    proc.stdout.on("data", (data) => {
      result.push(data);
    });
    proc.stderr.on("data", (data) => {
      const text: string = data.toString("utf-8");
      if (args[0] == 'query' && text.includes('warning: elem was ignored during paged export')) {
        // In v0.13, typst query doesn’t respect the export format.
        // https://github.com/typst/typst/issues/6404
        // Suppress the warning.
        return;
      }
      console.error(prefixScreen(text, id));
    });
    proc.on("close", (code) => {
      if (code !== 0) {
        reject(new Error(`Typst process exited with code ${code}`));
      } else {
        resolve(Buffer.concat(result).toString("utf-8"));
      }
    });
  });
}
