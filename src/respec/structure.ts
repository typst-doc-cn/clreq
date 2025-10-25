/**
 * Handles producing the ToC, numbering sections, and permalinks across the document.
 *
 * Adapted from ReSpec.
 *
 * https://github.com/speced/respec/blob/eaa1596ef5c4207ab350808c1593d3a39600fbed/src/core/structure.js
 * https://github.com/speced/respec/blob/eaa1596ef5c4207ab350808c1593d3a39600fbed/src/core/id-headers.js
 * https://www.w3.org/Consortium/Legal/2015/copyright-software-and-document
 *
 * @module
 */

import { addId, html, renameElement } from "./utils.ts";

interface Section {
  header: HTMLElement;
  title: string;
  subsections: Section[];
}

/**
 * Scans sections and generate ordered list element + ID-to-anchor-content dictionary.
 * @param sections the target element to find child sections
 */
function scanSections(
  sections: Section[],
  maxTocLevel: number,
  { level = 1 } = {},
): HTMLElement | null {
  if (sections.length === 0) {
    return null;
  }

  // @ts-ignore
  const ol = html`
    <ol class="toc"></ol>
  ` as HTMLElement;
  for (const section of sections) {
    if (level <= maxTocLevel) {
      const id = section.header.id;
      const item = createTocListItem(section.header, id);
      const sub = scanSections(section.subsections, maxTocLevel, {
        level: level + 1,
      });
      if (sub) {
        item.append(sub);
      }
      ol.append(item);
    }
  }
  return ol;
}

function getSectionTree(parent: Element): Section[] {
  const headings = parent.querySelectorAll<HTMLElement>("h2, h3, h4, h5, h6");
  const sections: Section[] = [];

  /**
   * A map from section levels to the last section encountered at the level.
   *
   * The level is counting from 2.
   */
  const lastSectionAtLevel = new Map<number, Section>();

  for (const heading of headings) {
    const level = parseInt(heading.tagName[1], 10);
    const title = heading.textContent as string;
    addId(heading, null, title);

    const section: Section = {
      header: heading,
      title,
      subsections: [],
    };

    const parent = lastSectionAtLevel.get(level - 1);
    if (level === 2 || parent === undefined) {
      // This is the top level
      sections.push(section);
    } else {
      parent.subsections.push(section);
    }

    // Update the cache
    lastSectionAtLevel.set(level, section);
    // Clear below this level
    for (let i = level + 1; i <= 6; i++) {
      lastSectionAtLevel.delete(i);
    }
  }

  return sections;
}

function createTocListItem(header: Element, id: string): HTMLElement {
  const anchor = html`
    <a href="${`#${id}`}" class="tocxref" />
  ` as HTMLElement;
  anchor.append(...header.cloneNode(true).childNodes);
  filterHeader(anchor);
  return html`
    <li class="tocline">${anchor}</li>
  ` as HTMLElement;
}

/**
 * Replaces any child <a> and <dfn> with <span>.
 */
function filterHeader(h: HTMLElement): void {
  h.querySelectorAll("a").forEach((anchor) => {
    const span = renameElement(anchor, "span");
    span.className = "formerLink";
    span.removeAttribute("href");
  });
  h.querySelectorAll("dfn").forEach((dfn) => {
    const span = renameElement(dfn, "span");
    span.removeAttribute("id");
  });
}

function createTableOfContents(ol: HTMLElement): HTMLElement {
  const nav = html`
    <nav id="toc"></nav>
  ` as HTMLElement;
  const h2 = html`
    <h2 class="introductory">
      <span lang="en" its-locale-filter-list="en">Contents</span>
      <span lang="zh-Hans" its-locale-filter-list="zh">目录</span>
    </h2>
  `;
  nav.append(h2, ol);
  const ref = document.getElementById("toc") ??
    document.getElementById("sotd") ??
    document.getElementById("abstract");
  if (ref) {
    if (ref.id === "toc") {
      ref.replaceWith(nav);
    } else {
      ref.after(nav);
    }
  }

  return nav;
}

/** Add permalinks to headings */
function addPermalinks(): void {
  const headings = document.querySelectorAll<HTMLElement>("h2, h3, h4, h5, h6");
  for (const h of headings) {
    if (h.id) {
      const permalink = html`
        <a
          ref="bookmark"
          href="#${h.id}"
          class="permalink"
          title="Permalink"
          aria-label="Permalink"
        ></a>
      `;
      h.prepend(permalink);
    }
  }
}

interface PriorityLevel {
  paint: string;
  human: string;
}
type LevelName = "tbd" | "na" | "ok" | "advanced" | "basic" | "broken";

/**
 * Configuration of levels, sorted.
 */
const PRIORITY_CONFIG: Record<LevelName, PriorityLevel> = {
  tbd: { paint: "eeeeee", human: "To be done" },
  na: { paint: "008000", human: "Not applicable" },
  ok: { paint: "008000", human: "OK" },
  advanced: { paint: "ffe4b5", human: "Advanced" },
  basic: { paint: "ffa500", human: "Basic" },
  broken: { paint: "ff0000", human: "Broken" },
};

/**
 * Collect all priority levels in `element`.
 */
function collectPriorityLevels(elements: HTMLElement[]): LevelName[] {
  return elements.flatMap((el) => {
    const tags = Array.from(
      el.querySelectorAll<HTMLElement>("[data-priority-level]"),
    );
    return tags.map((t) => t.dataset.priorityLevel as LevelName);
  });
}

/**
 * Calculate statistics of priority levels
 *
 * The returned `counts` will sorted from the most important to the least important according to `PRIORITY_CONFIG`.
 * If `levels` is empty, return `null`
 */
function countPriorityLevels(
  levels: LevelName[],
): { worst: PriorityLevel; report: string } | null {
  if (levels.length === 0) {
    return null;
  }

  // Calculate `worst` and `report`
  const ordering = Object.keys(PRIORITY_CONFIG) as LevelName[];
  const worst = PRIORITY_CONFIG[
    ordering[
      Math.max(...levels.map((l) => ordering.indexOf(l)))
    ]
  ];

  const counts: Map<LevelName, number> = levels.reduce(
    (last, l) => last.set(l, (last.get(l) as number) + 1),
    new Map(ordering.reverse().map((l) => [l, 0])),
  );
  const report = Array.from(counts.entries()).filter(([_level, n]) => n > 0)
    .map(([level, n]) => `${n} ${PRIORITY_CONFIG[level].human}`).join(", ");

  return { worst, report };
}

/**
 * Calculate priority levels for all sections, and insert levels in them
 * @param sections The section tree
 * @returns Top sections’ levels if this is the top level
 */
function insertPriorityLevel(
  sections: Section[],
  siblings: HTMLElement[] | null = null,
): Map<HTMLElement, LevelName[]> | undefined {
  if (sections.length === 0) {
    return;
  }

  /** Whether the current iteration is the top level */
  const isTop = siblings === null;

  // If not given, fill with the default
  if (siblings === null) {
    const parent = sections[0].header.parentElement as HTMLElement;
    console.assert(
      sections.every((s) => s.header.parentElement === parent),
      "All subsections under the same section should have the same parent element",
    );
    siblings = Array.from(parent.children) as HTMLElement[];
  }

  /** The start index of each section */
  const startIndices = sections.map((s) => siblings.indexOf(s.header));
  console.assert(
    startIndices.every((i) => i !== -1),
    "failed to one or more sections in siblings",
    sections.filter((s) => siblings.indexOf(s.header) === -1),
    siblings,
  );

  const topSectionLevels = new Map<HTMLElement, LevelName[]>();

  // Insert levels recursively, and save `topSectionLevels`
  sections.forEach((sec, i) => {
    const start = startIndices[i];
    const end = startIndices.at(i + 1);

    const levels = collectPriorityLevels(siblings.slice(start, end));

    // if leaf section
    if (sec.subsections.length === 0) {
      console.assert(
        levels.length <= 1,
        `at most one priority level could be annotated in leaf sections, but found ${levels}: ${sec.title}`,
        sec,
      );
    } else if (levels.length > 0) {
      if (isTop) {
        topSectionLevels.set(sec.header, levels);
      }

      const { worst, report } = countPriorityLevels(levels)!;

      // Find the first non prompt element
      let pos = sec.header;
      while (
        pos.nextElementSibling !== null &&
        pos.nextElementSibling.classList.contains("prompt")
      ) {
        pos = pos.nextElementSibling as HTMLElement;
      }

      // Write levels after `pos`
      const p = html`
        <p>
          <span
            style="background: #${worst
              .paint}; display: inline-block; width: 0.8em; height: 0.8em; margin-inline: 0.25em; vertical-align: -5%;"
          ></span>
          ${worst.human} — ${report}.
        </p>
      ` as HTMLElement;
      pos.insertAdjacentElement("afterend", p);

      // Insert recursively
      insertPriorityLevel(sec.subsections, siblings.slice(start, end));
    }
  });

  if (topSectionLevels.size > 0) {
    return topSectionLevels;
  }
}

/**
 * Draw top sections’ levels at `ol#summary`.
 */
function createSummary(
  topSectionLevels: Map<HTMLElement, LevelName[]>,
): void {
  // return
  const ol = document.querySelector<HTMLOListElement>("ol#summary")!;

  for (const [sec, levels] of topSectionLevels) {
    console.assert(levels.length > 0);

    // Draw dots
    const ordering = Object.keys(PRIORITY_CONFIG) as LevelName[];
    const sortedLevels = [...levels].sort((a, b) => {
      return ordering.indexOf(b) - ordering.indexOf(a);
    });

    const dots = html`
      <p class="dots" />
    `;
    sortedLevels.forEach((level) => {
      const { paint } = PRIORITY_CONFIG[level];
      const dot = html`
        <span style="background: #${paint}" class="dot" />
      ` as HTMLElement;
      dots.appendChild(dot);
    });

    // Save elements
    const secWrapper = html`
      <slot><p /></slot>
    ` as HTMLElement;
    secWrapper.firstElementChild!.append(...sec.cloneNode(true).childNodes);

    // `row` is <li>, and `inner` is `<a>`
    const row = createTocListItem(secWrapper, sec.id);
    const inner = row.firstChild!;

    inner.appendChild(dots);
    inner.appendChild(html`
      <p class="report">${countPriorityLevels(levels)!.report}</p>
    `);

    ol.appendChild(row);
  }
}

interface Configuration {
  /** only generate a TOC so many levels deep */
  maxTocLevel?: number;
}
export function createStructure(conf: Configuration = {}): void {
  const sectionTree = getSectionTree(document.body);
  const result = scanSections(sectionTree, conf.maxTocLevel ?? Infinity);
  if (result) {
    createTableOfContents(result);
  }

  addPermalinks();

  const topSectionLevels = insertPriorityLevel(sectionTree)!;
  createSummary(topSectionLevels);
}
