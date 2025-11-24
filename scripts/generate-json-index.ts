/**
 * Generate a JSON index and print to stdout.
 */

import assert from "node:assert";
import { fileURLToPath } from "node:url";

import type { IssueMeta, PullMeta } from "./check_issues.ts";
import { extraArgs } from "./config.ts";
import { typst } from "./typst.ts";

type Priority = "ok" | "advanced" | "basic" | "broken" | "tbd" | "na";
type GeneralPriority = Priority | "(inherited)";

// Parsed types

type Babel = { en: string; "zh-Hans": string };

type Heading = {
  level: number;
  body: Babel;
  label?: string;
};
type Section = {
  title: Babel;
  level: number;
  id?: string;
  priority: GeneralPriority;
  links: (
    | ({ type: "issue" } & IssueMeta)
    | ({ type: "pull" } & PullMeta)
    | ({ type: "workaround" } & WorkaroundMeta)
  )[];
};

// Typst elements

type HeadingElem = {
  func: "heading";
  level: number;
  body: ContentElem;
  label?: string;
};
type SpaceElem = { func: "space" };
type TextElem = { func: "text"; text: string };
type RawElem = { func: "raw"; text: string };
type Sequence<T> = {
  func: "sequence";
  children: T[];
};
/** Same as `Sequence<ContentElem>`, but without self-reference. */
type SequenceElem = {
  func: "sequence";
  children: ContentElem[];
};
type StyledElem = {
  func: "styled";
  child: ContentElem;
  styles: "..";
};
/**
 * The body of a heading element.
 *
 * Only relevant fields and combinations are included.
 */
type ContentElem =
  | StyledElem
  | SequenceElem
  | SpaceElem
  | TextElem
  | {
    func: "elem";
    tag: "span";
    attrs: { lang: "en" | "zh-Hans" } | { style: string };
    body: TextElem | Sequence<TextElem | RawElem | SpaceElem>;
  };

type WorkaroundMeta = {
  dest: string;
  note: string | null;
};

type GeneralMetadata =
  & { func: "metadata" }
  & (
    | { value: Priority; label: "<priority>" }
    | { value: IssueMeta; label: "<issue>" }
    | { value: PullMeta; label: "<pull>" }
    | { value: WorkaroundMeta; label: "<workaround>" }
  );

function* _parseContent(
  it: ContentElem | RawElem | Sequence<TextElem | RawElem | SpaceElem>,
): Generator<
  | { action: "pop"; text: string }
  | { action: "switch-lang"; next: "en" | "zh-Hans" }
> {
  const pop = (text: string) => ({ action: "pop" as const, text });
  const switchLang = (lang: "en" | "zh-Hans") => ({
    action: "switch-lang" as const,
    next: lang,
  });

  switch (it.func) {
    // Structural elements
    case "sequence":
      for (const child of it.children) {
        yield* _parseContent(child);
      }
      break;
    case "styled":
      yield* _parseContent(it.child);
      break;

    // Basic elements
    case "text":
      yield pop(it.text);
      break;
    case "space":
      yield pop(" ");
      break;
    case "raw":
      yield pop(`“${it.text}”`);
      break;

    // HTML elements
    case "elem":
      if ("lang" in it.attrs) {
        const lang = it.attrs.lang;
        assert(
          lang === "en" || lang === "zh-Hans",
          `Invalid language: ${lang} in ${JSON.stringify(it)}`,
        );
        yield switchLang(lang);
      }
      yield* _parseContent(it.body);
      break;

    default:
      throw new Error(`Reached unexpected element: ${JSON.stringify(it)}`);
  }
}

function parseHeading(heading: HeadingElem): Heading {
  const { level, body, label } = heading;
  const parser = _parseContent(body);

  const parsed = { en: "", "zh-Hans": "" };
  let lang: keyof typeof parsed = "en";

  for (const p of parser) {
    switch (p.action) {
      case "pop":
        parsed[lang] += p.text;
        break;
      case "switch-lang":
        // Remove the space added by `babel` between languages.
        parsed[lang] = parsed[lang].trim();
        lang = p.next;
        break;
      default:
        throw new Error(`Invalid action: ${JSON.stringify(p)}`);
    }
  }

  // Fallback
  parsed["zh-Hans"] ||= parsed.en;
  parsed["en"] ||= parsed["zh-Hans"];

  return { level, body: parsed, label };
}

function labelToId(label: string): string;
function labelToId(label: undefined): undefined;
function labelToId(label: string | undefined): string | undefined;
function labelToId(label: string | undefined): string | undefined {
  return label?.replace(/^<(.+)>$/, "$1");
}

/** Get data by querying the typst document. */
async function queryDocument(): Promise<(Heading | GeneralMetadata)[]> {
  return (JSON.parse(
    await typst([
      "query",
      "index.typ", // This cannot be main.typ, or there will be an additional heading (`outline`'s title).
      [
        "selector.or(heading, <priority>, <issue>, <pull>, <workaround>)",
        ".after(outline)",
        ".before(<addendum>, inclusive: false)",
      ].join(""),
      "--target=html",
      ...extraArgs.pre,
    ]),
  ) as (HeadingElem | GeneralMetadata)[]).map((el) => {
    if (el.func === "heading") {
      return parseHeading(el);
    }
    return el;
  });
}

/** Collect data into sections. */
function collectSections(data: (Heading | GeneralMetadata)[]): Section[] {
  const sections: Section[] = [];

  for (const it of data) {
    if ("level" in it) {
      const { body: title, level, label } = it;
      const id = labelToId(label);
      sections.push({ id, title, level, priority: "(inherited)", links: [] });
    } else {
      const last = sections.at(-1);
      assert(
        last !== undefined,
        `Metadata describe the heading before them, but there is no heading before this one: ${
          JSON.stringify(it)
        }`,
      );

      switch (it.label) {
        case "<priority>":
          assert(
            last.priority === "(inherited)",
            `There are multiple priority levels marking the same section: heading = ${
              JSON.stringify(last.title)
            }, priority = [${last.priority}, ${it.value}, …]`,
          );
          last.priority = it.value;
          break;

        case "<issue>":
          last.links.push({ type: "issue", ...it.value });
          break;
        case "<pull>":
          last.links.push({ type: "pull", ...it.value });
          break;
        case "<workaround>":
          last.links.push({ type: "workaround", ...it.value });
          break;

        default:
          throw new Error(`Reached unexpected element: ${JSON.stringify(it)}`);
      }
    }
  }
  return sections;
}

/** Warn sections without `id` */
function warnUnlabelledSections(sections: Section[]): void {
  const unlabelled = sections.filter(({ id, priority }) =>
    id === undefined && !["tbd", "na"].includes(priority)
  );

  if (unlabelled.length > 0) {
    console.warn(
      `Found ${unlabelled.length} unlabelled sections:\n${
        unlabelled.map(({ title, level, priority }) =>
          `${"  ".repeat(level)}- ${
            priority === "(inherited)" ? "" : `[${priority}] `
          }${title.en} | ${title["zh-Hans"]}`
        ).join("\n")
      }`,
    );
  }
}

if (process.argv[1] === fileURLToPath(import.meta.url)) {
  const data = await queryDocument();
  const sections = collectSections(data);
  console.log(JSON.stringify({ version: "2025-11-24", sections }, null, 2));

  warnUnlabelledSections(sections);
}
