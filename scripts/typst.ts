import assert from "node:assert";
import { spawn } from "node:child_process";

/** Whether to use color, passed to typst */
export type Color = "always" | "never" | "auto";

/**
 * Run a typst command with the given arguments.
 *
 * @param args - Arguments to pass to the typst command
 * @returns  - Resolves with the output of the typst command
 */
export function typst(
  args: string[],
  { stdin, color = "auto" }: { stdin?: string; color?: Color } = {},
): Promise<string> {
  return new Promise((resolve, reject) => {
    const proc = spawn("typst", [`--color=${color}`, ...args]);
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
      if (
        args[0] == "query" &&
        (text.includes(": elem was ignored during paged export") ||
          text.includes("html-bindings-h.typ:"))
        // `warning` might be colored, so it is not reliable
      ) {
        // In v0.13, typst query doesn’t respect the export format.
        // https://github.com/typst/typst/issues/6404
        // Suppress the warning.
        return;
      }
      process.stderr.write(data);
    });
    proc.on("close", (code) => {
      if (code !== 0) {
        reject(
          new Error(
            [
              `Typst process exited with code ${code}`,
              stdin ? ("```typst\n" + stdin + "\n```") : null,
              `Args: typst ${args.join(" ")}`,
            ].flatMap((x) => x).join("\n"),
          ),
        );
      } else {
        resolve(Buffer.concat(result).toString("utf-8"));
      }
    });
  });
}
