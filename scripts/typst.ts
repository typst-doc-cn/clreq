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
