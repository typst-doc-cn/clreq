import fs from "node:fs/promises";

import watch from "glob-watcher";

import { mainHint, ROOT_DIR, typst } from "./cli_util.ts";


const extraArgs = [
  "--diagnostic-format=short",
  "--features=html",
  `--font-path=${ROOT_DIR}/fonts`,
];

await main();

async function main() {
  await fs.mkdir("dist", { recursive: true });
  await fs.mkdir("target/cache", { recursive: true });

  if (process.argv.includes("--watch") || process.argv.includes("-w")) {
    console.log("Watching for changes...");

    // We estimate which files could affect the compilation
    const glob = watch(["{index,main}.typ", "typ/**/*"], {
      persistent: true,
      ignorePermissionErrors: true,
    });
    console.clear();
    typst("index", ["watch", "index.typ", "dist/index.html", ...extraArgs]);

    glob.on("change", async (_event, path) => {
      console.log(`File changed...`);
      try {
        await renderExamples();
        console.log(mainHint("Recompiled successfully."));
      } catch (error) {
        console.error("Error during recompilation:", error);
      }
    });
    await renderExamples();
  } else {
    try {
      await renderExamples();
      typst("index", ["compile", "index.typ", "dist/index.html", ...extraArgs]);
      console.log("Compilation completed successfully.");
    } catch (error) {
      console.error("Error during compilation:", error);
    }
  }
}

/**
 * Render examples from the main.typ file and compile them into SVG files.
 */
async function renderExamples() {
  const examples = JSON.parse(
    await typst("query", [
      "query",
      "main.typ",
      "<external-example>",
      "--field=value",
      // To allow the first compile, tell that the cache is not ready yet.
      "--input",
      "cache-ready=false",
      ...extraArgs,
    ])
  );

  const compileExample = async ({ id, content }: { id: string, content: string; }) => {
    const output = `target/cache/${id}.svg`;
    const compiled = await fs.stat(output).then(() => true).catch(() => false);
    if (compiled) {
      // if already compiled, skip
      console.log(mainHint(`Example ${id} already compiled.`));
    } else {
      // compiles and creates svg files
      try {
        await typst(id, ["compile", "-", output, ...extraArgs], { stdin: content });
        console.log(mainHint(`Compiled example: ${id}`));
      } catch (error) {
        console.error(`Error compiling example ${id}:`, error);
      }
    }
  };

  await Promise.all(examples.map(compileExample));
}
