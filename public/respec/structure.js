/**
 * Handles producing the ToC and numbering sections across the document.
 *
 * Adapted from ReSpec.
 *
 * https://github.com/speced/respec/blob/eaa1596ef5c4207ab350808c1593d3a39600fbed/src/core/structure.js
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

/**
 * @typedef {object} Configuration
 * @property {string} lang can change the generated text (supported: en, fr)
 * @property {number} maxTocLevel only generate a TOC so many levels deep
 *
 * @param {Configuration} conf
 */
export function makeToc(conf = {}) {
  if ("maxTocLevel" in conf === false) {
    conf.maxTocLevel = Infinity;
  }

  const sectionTree = getSectionTree(document.body);
  const result = scanSections(sectionTree, conf.maxTocLevel);
  if (result) {
    createTableOfContents(result);
  }
}
