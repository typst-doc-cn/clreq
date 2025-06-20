import fs from "node:fs/promises";
import { fileURLToPath } from "node:url";

import watch from "glob-watcher";

import { envArgs, extraArgs, ROOT_DIR } from "./config.ts";
import { type Color, typst } from "./typst.ts";

const CACHE_DIR = `${ROOT_DIR}/target/cache`;

/**
 * The main entrypoint of precompilation.
 */
export async function precompile(color: { color?: Color } = {}) {
  await fs.mkdir(CACHE_DIR, { recursive: true });
  await Promise.all([
    renderExamples(color),
    renderPrioritization(color),
  ]);
}

/**
 * Render examples from the main.typ file and compile them into SVG files.
 */
async function renderExamples({ color }: { color?: Color }) {
  type Example = { id: string; content: string };

  const examples = JSON.parse(
    await typst([
      "query",
      "main.typ",
      "<external-example>",
      "--field=value",
      "--diagnostic-format=short",
      ...extraArgs.pre,
    ], { color: color }),
  ) as Example[];

  /** @returns cache-hit */
  const compileExample = async ({ id, content }: Example): Promise<boolean> => {
    const output = `${CACHE_DIR}/${id}.svg`;
    const compiled = await fs.stat(output).then(() => true).catch(() => false);
    if (!compiled) {
      await typst(["compile", "-", output, ...envArgs], {
        stdin: content,
        color: color,
      });
    }
    return compiled;
  };

  const hit = await Promise.all(examples.map(compileExample));
  const total = hit.length;
  const cached = hit.filter((h) => h).length;
  console.log(
    `\n✅ Rendered ${total} examples successfully.`,
    `(${cached} cached, ${total - cached} new)`,
  );
}

/**
 * Render prioritization.level-table into an SVG.
 */
async function renderPrioritization(
  { color }: { color?: Color },
): Promise<void> {
  const output = `${CACHE_DIR}/prioritization.level-table.svg`;
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

  const svg = await typst([
    "compile",
    "-",
    "-",
    "--format=svg",
    `--root=${ROOT_DIR}`,
    ...extraArgs.pre,
  ], {
    stdin: `
#set page(height: auto, width: auto, margin: 0.5em, fill: none)
#import "/typ/prioritization.typ": level-table
#level-table
`.trim(),
    color: color,
  });

  // Support dark theme
  const final = svg.replaceAll(
    / (fill|stroke)="#000000"/g,
    ' $1="currentColor"',
  );

  await fs.writeFile(output, final);
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const argv = process.argv.slice(2);
  const watchMode = ["--watch", "-w"].some((sw) => argv.includes(sw));

  if (watchMode) {
    // We estimate which files could affect the compilation
    const glob = watch(["{index,main}.typ", "typ/**/*"], {
      persistent: true,
      ignorePermissionErrors: true,
    });

    const tryPrecompile = async () => {
      try {
        await precompile({ color: "always" });
      } catch (error) {
        console.error("💥 Precompilation failed:", error);
      }
    };

    glob.on("change", async (_event, path) => {
      console.log("Refresh precompilation because of", path);
      await tryPrecompile();
    });
    await tryPrecompile();
  } else {
    await precompile();
  }
}
