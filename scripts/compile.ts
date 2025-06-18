import fs from "node:fs/promises";
import { fileURLToPath } from "node:url";

import { createServer } from "vite";
import watch from "glob-watcher";

import { mainHint, ROOT_DIR, typst } from "./cli_util.ts";

const extraArgs = [
  "--diagnostic-format=short",
  "--features=html",
  `--font-path=${ROOT_DIR}/fonts`,
];

const ASSETS_SERVER_PORT = 5173;

// See typ/mode.typ
export const preExtraArgs = [
  "--input",
  "mode=pre",
  ...extraArgs,
];
const buildExtraArgs = [
  "--input",
  "mode=build",
  "--input",
  "x-url-base=/clreq/",
  ...extraArgs,
];
const devExtraArgs = [
  "--input",
  "mode=dev",
  "--input",
  `x-url-base=http://localhost:${ASSETS_SERVER_PORT}/`,
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

    await serveAssets();
    typst("index", ["watch", "index.typ", "dist/index.html", ...devExtraArgs]);

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
      await typst("index", [
        "compile",
        "index.typ",
        "dist/index.html",
        ...buildExtraArgs,
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
      ...preExtraArgs,
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
    ...preExtraArgs,
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

/** Start the vite dev server. */
async function serveAssets() {
  const server = await createServer({
    server: {
      port: ASSETS_SERVER_PORT,
    },
  });
  await server.listen();
  server.printUrls();
}
