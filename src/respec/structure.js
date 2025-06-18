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

import { addId, html, renameElement } from "./utils.js";

/**
 * @typedef {object} SectionInfo
 * @property {string} secno
 * @property {string} title
 *
 * Scans sections and generate ordered list element + ID-to-anchor-content dictionary.
 * @param {Section[]} sections the target element to find child sections
 * @param {number} maxTocLevel
 */
function scanSections(sections, maxTocLevel, { level = 1 } = {}) {
  if (sections.length === 0) {
    return null;
  }

  /** @type {HTMLElement} */
  const ol = html`
    <ol class="toc"></ol>
  `;
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

/**
 * @typedef {object} Section
 * @property {Element} header
 * @property {string} title
 * @property {Section[]} subsections
 *
 * @param {Element} parent
 * @returns {Section[]}
 */
function getSectionTree(parent) {
  /** @type {NodeListOf<HTMLElement>} */
  const headings = parent.querySelectorAll("h2, h3, h4, h5, h6");
  /** @type {Section[]} */
  const sections = [];

  /**
   * A map from section levels to the last section encountered at the level.
   *
   * The level is counting from 2.
   *
   * @type {Map<number, Section>}
   */
  const lastSectionAtLevel = new Map();

  for (const heading of headings) {
    const level = parseInt(heading.tagName[1], 10);
    const title = heading.textContent;
    addId(heading, null, title);

    /** @type {Section} */
    const section = {
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

/**
 * @param {Element} header
 * @param {string} id
 */
function createTocListItem(header, id) {
  const anchor = html`
    <a href="${`#${id}`}" class="tocxref" />
  `;
  anchor.append(...header.cloneNode(true).childNodes);
  filterHeader(anchor);
  return html`
    <li class="tocline">${anchor}</li>
  `;
}

/**
 * Replaces any child <a> and <dfn> with <span>.
 * @param {HTMLElement} h
 */
function filterHeader(h) {
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

/**
 * @param {HTMLElement} ol
 */
function createTableOfContents(ol) {
  const nav = html`
    <nav id="toc"></nav>
  `;
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
}

/** Add permalinks to headings */
function addPermalinks() {
  /** @type {NodeListOf<HTMLElement>} */
  const headings = document.querySelectorAll("h2, h3, h4, h5, h6");
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

/**
 * Configuration of levels, sorted.
 * @type {Record<string, {paint: string, human: string}>}
 */
const PRIORITY_CONFIG = {
  tbd: { paint: "eeeeee", human: "To be done" },
  na: { paint: "008000", human: "Not applicable" },
  ok: { paint: "008000", human: "OK" },
  advanced: { paint: "ffe4b5", human: "Advanced" },
  basic: { paint: "ffa500", human: "Basic" },
  broken: { paint: "ff0000", human: "Broken" },
};

/**
 * Calculate priority levels for all sections, and insert levels in them
 * @param {Section[]} sections The section tree
 * @param {HTMLElement[] | null} siblings
 */
function insertPriorityLevel(sections, siblings = null) {
  if (sections.length === 0) {
    return;
  }

  // If not given, fill with the default
  if (siblings === null) {
    const parent = sections[0].header.parentElement;
    console.assert(
      sections.every((s) => s.header.parentElement === parent),
      "All subsections under the same section should have the same parent element",
    );
    /** @type {HTMLElement[]} */
    siblings = Array.from(parent.children);
  }

  /** The start index of each section */
  const startIndices = sections.map((s) => siblings.indexOf(s.header));
  console.assert(
    startIndices.every((i) => i !== -1),
    "failed to one or more sections in siblings",
    sections.filter((s) => siblings.indexOf(s.header) === -1),
    siblings,
  );

  sections.forEach((sec, i) => {
    const start = startIndices[i];
    const end = startIndices.at(i + 1);

    const levels = siblings.slice(start, end).flatMap((el) => {
      /** @type {HTMLElement[]} */
      const tags = Array.from(el.querySelectorAll("[data-priority-level]"));
      return tags.map((t) => t.dataset.priorityLevel);
    });

    // if leaf section
    if (sec.subsections.length === 0) {
      console.assert(
        levels.length <= 1,
        `at most one priority level could be annotated in leaf sections, but found ${levels}: ${sec.title}`,
        sec,
      );
    } else if (levels.length > 0) {
      // Calculate `worst` and `report`
      const ordering = Object.keys(PRIORITY_CONFIG);
      const worst = PRIORITY_CONFIG[
        ordering[
          Math.max(...levels.map((l) => ordering.indexOf(l)))
        ]
      ];
      const counts = levels.reduce(
        (last, l) => last.set(l, last.get(l) + 1),
        new Map(ordering.reverse().map((l) => [l, 0])),
      );
      const report = Array.from(
        counts.entries().filter(([_level, n]) => n > 0).map(([level, n]) =>
          `${n} ${PRIORITY_CONFIG[level].human}`
        ),
      ).join(", ");

      // Find the first non prompt element
      let pos = sec.header;
      while (
        pos.nextElementSibling !== undefined &&
        pos.nextElementSibling.classList.contains("prompt")
      ) {
        pos = pos.nextElementSibling;
      }

      // Write levels after `pos`
      const p = html`
        <p>
          <span
            style="background: #${worst
          .paint}; display: inline-block; width: 0.8em; height: 0.8em; margin: 0.25em; vertical-align: -15%;"
          ></span>
          ${worst.human} — ${report}.
        </p>
      `;
      pos.insertAdjacentElement("afterend", p);

      // Insert recursively
      insertPriorityLevel(sec.subsections, siblings.slice(start, end));
    }
  });
}

/**
 * @typedef {object} Configuration
 * @property {number} maxTocLevel only generate a TOC so many levels deep
 *
 * @param {Configuration} conf
 */
export function createStructure(conf = {}) {
  if ("maxTocLevel" in conf === false) {
    conf.maxTocLevel = Infinity;
  }

  const sectionTree = getSectionTree(document.body);
  const result = scanSections(sectionTree, conf.maxTocLevel);
  if (result) {
    createTableOfContents(result);
  }

  addPermalinks();

  insertPriorityLevel(sectionTree);
}
