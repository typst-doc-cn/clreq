import { spawn } from "child_process";
import fs from "fs/promises";
import watch from "glob-watcher";

const lightGreen = "\x1b[32m";
const lightBlue = "\x1b[34m";
const reset = "\x1b[0m";

// todo cache, clean not used examples
const exampleCache = {};

const log = (line, id, color = lightGreen) => `${color}[${id}]${reset} ${line}`;
const mainHint = (line) => log(line, "main", lightBlue);

const extraArgs = [
  "--diagnostic-format",
  "short",
  "--features=html",
  "--font-path=fonts",
];

await main();

async function main() {
  await fs.mkdir("dist/examples", { recursive: true });
  await fs.mkdir("dist/assets", { recursive: true });

  const compileOnce = async () => {
    await renderExamples();
    await typst("index", [
      "compile",
      "index.typ",
      "dist/index.html",
      ...extraArgs,
    ]);
  };

  if (process.argv.includes("--watch") || process.argv.includes("-w")) {
    console.log("Watching for changes...");

    // We estimiate which files could affect the compilation
    const glob = watch(["{index,main}.typ", "examples/**/*", "typ/**/*"], {
      persistent: true,
      ignorePermissionErrors: true,
    });

    glob.on("change", async (_event, path) => {
      console.clear();
      console.log(`File changed: ${path}`);
      try {
        await compileOnce();
        console.log(mainHint("Recompiled successfully."));
      } catch (error) {
        console.error("Error during recompilation:", error);
      }
    });
    console.clear();
    await compileOnce();
  } else {
    try {
      await compileOnce();
      console.log("Compilation completed successfully.");
    } catch (error) {
      console.error("Error during compilation:", error);
    }
  }
}

/**
 * Prefix each line of the buffer with the identifier and a color.
 *
 * @param {Buffer} buffer - The buffer containing the output from the typst command
 * @param {string} id - Identifier for the task process, used for logging
 * @returns {string} - The formatted string with each line prefixed by the identifier
 */
function prefixScreen(buffer, id) {
  const lines = buffer.toString("utf-8").trim().split("\n");
  return lines.map((line) => log(line, id)).join("\n");
}

/**
 * Run a typst command with the given arguments.
 *
 * @param {string} id - Identifier for the task process, used for logging
 * @param {string[]} args - Arguments to pass to the typst command
 * @param {import ('node:child_process').SpawnOptions} opts - Options for the spawn command
 * @returns {Promise<string>} - Resolves with the output of the typst command
 */
function typst(id, args, opts = {}) {
  return new Promise((resolve, reject) => {
    const proc = spawn("typst", args, opts);

    const result = [];
    proc.stdout.on("data", (data) => {
      result.push(data);
    });
    proc.stderr.on("data", (data) => console.error(prefixScreen(data, id)));
    proc.on("close", (code) => {
      if (code !== 0) {
        reject(new Error(`Typst process exited with code ${code}`));
      } else {
        resolve(Buffer.concat(result).toString("utf-8"));
      }
    });
  });
}

/**
 * Render examples from the main.typ file and compile them into SVG files.
 */
async function renderExamples() {
  const examples = JSON.parse(
    await typst("query", [
      "query",
      "main.typ",
      "<new-example>",
      "--field",
      "value",
      ...extraArgs,
    ])
  );
  /**
   *
   * @param {{id: string, content: string}} example
   */
  const compileExample = async (example) => {
    const { id, content } = example;
    if (exampleCache[id]) {
      // todo: typ change may change the output, so we need to check if the content is the same
      // if already compiled, skip
      console.log(mainHint(`Example ${id} already compiled.`));
      return exampleCache[id].output;
    }

    // compiles and creates svg files
    try {
      const input = `dist/examples/${id}.typ`;
      await fs.writeFile(input, content);
      const output = `dist/assets/${id}.svg`;
      await typst(id, ["compile", input, output, ...extraArgs]);
      console.log(mainHint(`Compiled example: ${id}`));
      exampleCache[id] = {
        lifetime: 1,
        output,
      };
      return output;
    } catch (error) {
      console.error(`Error compiling example ${id}:`, error);
    }
  };

  await Promise.all(examples.map(compileExample));

  const snapshot = Object.fromEntries(
    Object.entries(exampleCache).map(([id, { output }]) => [id, { output }])
  );
  const toWrite = JSON.stringify(snapshot, null, 2);
  const existing = await fs
    .readFile("content/snapshot/example.json")
    .catch(() => "{}");
  if (existing != toWrite) {
    console.log(mainHint("Writing new example snapshot"));
    await fs.writeFile("content/snapshot/example.json.tmp", toWrite);
    await fs.rename(
      "content/snapshot/example.json.tmp",
      "content/snapshot/example.json"
    );
  }
}
