/**
 * Creates and handles the language switch.
 *
 * Adapted from W3C clreq.
 *
 * https://github.com/w3c/clreq/blob/2526efd3a66daa35d453784f9200cb20c6cfff1d/index.html#L76-L81
 * https://github.com/w3c/clreq/blob/2526efd3a66daa35d453784f9200cb20c6cfff1d/src/script.ts
 * https://www.w3.org/Consortium/Legal/copyright-software
 */

import { html } from "./utils.js";

/**
 * @typedef {'zh' | 'en' | 'all'} Language
 */

const $root = document.documentElement;
/** @type {HTMLElement} */
const $main = $root.querySelector("main");

/**
 * Multilingual elements created with `#babel` and `#bbl` in typst.
 * @type {HTMLElement[]}
 */
const babelElements = Array.from(
  $root.querySelectorAll("[its-locale-filter-list]"),
);

/**
 * @param {Language} lang
 */
function setRoot(lang) {
  $root.lang = lang === "all" ? "zh-CN" : lang;

  // Update styles
  if (lang === "all") {
    $root.classList.remove("monolingual");
  } else {
    $root.classList.add("monolingual");
  }
}

/**
 * @param {Language} lang
 */
function filterElements(lang) {
  for (const el of babelElements) {
    const match = lang === "all" ||
      el.getAttribute("its-locale-filter-list") === lang;
    el.hidden = !match;
  }
}

/**
 * @param {Language} lang
 */
function applyLanguage(lang) {
  setRoot(lang);
  filterElements(lang);
}

function createLanguageSwitch() {
  const menu = html`
    <aside id="lang-switch">
      <button data-lang="zh" lang="zh">中文</button>
      <button data-lang="en" lang="en">English</button>
      <button class="selected" data-lang="all" lang="en">All</button>
    </aside>
  `;
  menu.addEventListener("click", (e) => {
    /** @type {HTMLElement} */
    const option = e.target.closest("[data-lang]");
    if (option) {
      /** @type {Language} */
      const lang = option.dataset.lang;
      applyLanguage(lang);

      // Update `.selected`
      Array.from(menu.children).forEach((o) => {
        if (o.dataset.lang === lang) {
          o.classList.add("selected");
        } else {
          o.classList.remove("selected");
        }
      });
    }
  });

  $main.append(menu);
}

createLanguageSwitch();
