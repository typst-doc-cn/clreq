/**
 * Creates and handles the language switch.
 *
 * Adapted from W3C clreq.
 *
 * https://github.com/w3c/clreq/blob/2526efd3a66daa35d453784f9200cb20c6cfff1d/index.html#L76-L81
 * https://github.com/w3c/clreq/blob/2526efd3a66daa35d453784f9200cb20c6cfff1d/src/script.ts
 * https://www.w3.org/Consortium/Legal/copyright-software
 */

import { html } from "./utils.ts";

type Language = "zh" | "en" | "all";

const $root = document.documentElement;
const $main = $root.querySelector("main") as HTMLElement;

function setRoot(lang: Language): void {
  $root.lang = lang === "all" ? "zh-CN" : lang;

  // Update styles
  if (lang === "all") {
    $root.classList.remove("monolingual");
  } else {
    $root.classList.add("monolingual");
  }
}

function filterElements(lang: Language): void {
  /**
   * Multilingual elements created with `#babel` and `#bbl` in typst,
   * or dynamically created by other scripts.
   */
  const babelElements = Array.from(
    $root.querySelectorAll<HTMLElement>("[its-locale-filter-list]"),
  );

  for (const el of babelElements) {
    const match = lang === "all" ||
      el.getAttribute("its-locale-filter-list") === lang;
    el.hidden = !match;
  }
}

function applyLanguage(lang: Language, menu: HTMLElement): void {
  setRoot(lang);
  filterElements(lang);

  // Update selection
  Array.from(menu.children).forEach((o) => {
    // @ts-ignore
    if (o.dataset.lang === lang) {
      o.classList.add("checked");
      o.ariaChecked = "true";
    } else {
      o.classList.remove("checked");
      o.ariaChecked = "false";
    }
  });

  // Save for future loads
  localStorage.setItem("lang", lang);
}

export function createLanguageSwitch(): void {
  const menu = html`
    <aside id="lang-switch">
      <button data-lang="all" lang="en">All</button>
      <button data-lang="en" lang="en">English</button>
      <button data-lang="zh" lang="zh">中文</button>
    </aside>
  ` as HTMLElement;
  menu.addEventListener("click", (e) => {
    // @ts-ignore
    const option = e.target.closest("[data-lang]") as HTMLElement;
    if (option) {
      const lang = option.dataset.lang as Language;
      applyLanguage(lang, menu);
    }
  });

  applyLanguage(
    (localStorage.getItem("lang") as Language | null) ?? getSystemLanguage(),
    menu,
  );

  $main.append(menu);
}

function getSystemLanguage(): Language {
  const languages = navigator.languages ?? [navigator.language];

  for (const langFull of languages) {
    const lang = langFull.split("-")[0].toLowerCase();

    if (lang === "zh") return "zh";
    if (lang === "en") return "en";
  }
  return "all";
}
