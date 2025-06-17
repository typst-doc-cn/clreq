import fs from "node:fs/promises";
import { fileURLToPath } from "node:url";

import watch from "glob-watcher";

import { mainHint, ROOT_DIR, typst } from "./cli_util.ts";
import { assets_server } from "./assets_server.ts";

export const extraArgs = [
  "--diagnostic-format=short",
  "--features=html",
  `--font-path=${ROOT_DIR}/fonts`,
];

export const precompileExtraArgs = [
  // To allow the first query before compilation, tell that the cache is not ready yet.
  "--input",
  "cache-ready=false",
  ...extraArgs,
];

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const watchMode = ["--watch", "-w"].some((sw) => process.argv.includes(sw));
  await main({ watchMode });
}

async function main({ watchMode }: { watchMode: boolean }) {
  await fs.mkdir("dist", { recursive: true });
  await fs.mkdir("target/cache", { recursive: true });

  if (watchMode) {
    console.log("Watching for changes...");

    // We estimate which files could affect the compilation
    const glob = watch(["{index,main}.typ", "typ/**/*"], {
      persistent: true,
      ignorePermissionErrors: true,
    });
    console.clear();

    assets_server.listen(8000, "localhost");
    typst("index", [
      "watch",
      "index.typ",
      "dist/index.html",
      "--input",
      "x-url-base=http://localhost:8000/",
      ...extraArgs,
    ]);

    glob.on("change", async (_event, path) => {
      console.log(`File changed...`);
      try {
        await precompile();
        console.log(mainHint("Recompiled successfully."));
      } catch (error) {
        console.error("Error during recompilation:", error);
      }
    });
    await precompile();
  } else {
    try {
      await precompile();
      await Promise.all([
        typst("index", [
          "compile",
          "index.typ",
          "dist/index.html",
          "--input",
          "x-url-base=/clreq/assets/",
          ...extraArgs,
        ]),
        fs.cp("public", "dist/assets/", { recursive: true }),
      ]);
      console.log("Compilation completed successfully.");
    } catch (error) {
      console.error("Error during compilation:", error);
    }
  }
}

/**
 * The main entrypoint of precompilation.
 */
async function precompile() {
  return await Promise.all([renderExamples(), renderPrioritization()]);
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
      ...precompileExtraArgs,
    ]),
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

/**
 * Render prioritization.level-table into an SVG.
 */
async function renderPrioritization(): Promise<void> {
  const output = "target/cache/prioritization.level-table.svg";
  const dep = "typ/prioritization.typ";

  // compiled = output exists and newer than dep
  // TODO: Improve cache
  const compiled = await fs.stat(output)
    .then(async (outStat) => {
      const depStat = await fs.stat(dep).catch(() => null);
      if (!depStat) return false;
      return outStat.mtime > depStat.mtime;
    })
    .catch(() => false);
  if (compiled) {
    return;
  }

  const svg = await typst("priority", [
    "compile",
    "-",
    "-",
    "--format=svg",
    `--root=${ROOT_DIR}`,
    ...precompileExtraArgs,
  ], {
    stdin: `
#set page(height: auto, width: auto, margin: 0.5em, fill: none)
#import "/typ/prioritization.typ": level-table
#level-table
`.trim(),
  });

  // Support dark theme
  const final = svg.replaceAll(
    / (fill|stroke)="#000000"/g,
    ' $1="currentColor"',
  );

  await fs.writeFile(output, final);
}
