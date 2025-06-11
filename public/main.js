const themeToggle = document.getElementById("theme-toggle");
/** @type {HTMLDivElement[]} */
const themeSelections = Array.from(themeToggle.querySelectorAll('div.theme-icon'));

// Load saved theme preference or default to auto (sync system)
if (typeof localStorage !== "undefined") {
  const theme = localStorage.getItem("theme") ?? 'auto';
  applyTheme(theme);
}

// Theme toggle functionality
themeToggle.addEventListener("click", () => {
  const current = themeSelections.findIndex(icon => !icon.hidden);
  const next = themeSelections[(current + 1) % themeSelections.length].classList;
  const theme = next.contains("auto") ? "auto" : next.contains("light") ? "light" : "dark";
  applyTheme(theme);
});


/**
 * @param {'auto' | 'light' | 'dark'} theme 
 */
function applyTheme(theme) {
  // Change the page’s theme
  const resolved = theme === 'auto' ? getSystemTheme() : theme;
  if (resolved === "dark") {
    document.documentElement.classList.add("dark");
  } else {
    document.documentElement.classList.remove("dark");
  }

  // Update theme selections
  themeSelections.forEach(icon => {
    icon.hidden = !icon.classList.contains(theme);
  });

  // Save for future loads
  localStorage.setItem("theme", theme);
}

/**
 * @returns {'dark' | 'light'}
 */
function getSystemTheme() {
  // We cannot use `&&` here, due to the limitation of typst v0.13.
  const match = !(!window.matchMedia ||
    !window.matchMedia("(prefers-color-scheme: dark)").matches);
  return match ? "dark" : "light";
}
