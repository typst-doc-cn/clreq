/**
 * Theme toggle.
 *
 * This script should be executed before DOM is loaded.
 * Otherwise, the screen will flash in the dark mode.
 */

type Theme = "auto" | "light" | "dark";

/** Same as `applyTheme`, but works before DOM is loaded */
function applyThemeWithoutDOM(theme: Theme): void {
  // Change the page’s theme
  const resolved = theme === "auto" ? getSystemTheme() : theme;
  if (resolved === "dark") {
    document.documentElement.classList.add("dark");
  } else {
    document.documentElement.classList.remove("dark");
  }
}

// Load saved theme preference or default to auto (sync system)
if (typeof localStorage !== "undefined") {
  const theme = localStorage.getItem("theme") ?? "auto";
  applyThemeWithoutDOM(theme as Theme);
}

document.addEventListener("DOMContentLoaded", () => {
  const themeToggle = document.getElementById("theme-toggle") as HTMLElement;
  const themeSelections: HTMLDivElement[] = Array.from(
    themeToggle.querySelectorAll("div.theme-icon"),
  );

  // Load saved theme preference or default to auto (sync system)
  if (typeof localStorage !== "undefined") {
    const theme = localStorage.getItem("theme") ?? "auto";
    applyTheme(theme as Theme);
  }

  // Theme toggle functionality
  themeToggle.addEventListener("click", () => {
    const current = themeSelections.findIndex((icon) => !icon.hidden);
    const next =
      themeSelections[(current + 1) % themeSelections.length].classList;
    const theme = next.contains("auto")
      ? "auto"
      : next.contains("light")
      ? "light"
      : "dark";
    applyTheme(theme);
  });

  function applyTheme(theme: Theme): void {
    applyThemeWithoutDOM(theme);

    // Update theme selections
    themeSelections.forEach((icon) => {
      icon.hidden = !icon.classList.contains(theme);
    });

    // Save for future loads
    localStorage.setItem("theme", theme);
  }
});

function getSystemTheme(): "dark" | "light" {
  const match = window.matchMedia &&
    window.matchMedia("(prefers-color-scheme: dark)").matches;
  return match ? "dark" : "light";
}
