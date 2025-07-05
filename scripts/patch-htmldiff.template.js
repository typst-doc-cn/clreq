if (
  window.location.origin + window.location.pathname ===
    "https://services.w3.org/htmldiff"
) {
  // Improve readability for `<pre>`.
  const style = document.createElement("style");
  style.textContent = `
      pre {
        white-space: normal;
      }
    `;
  document.head.appendChild(style);

  // Replace the keyboard navigation script.
  const observer = new MutationObserver((_mutations, observer) => {
    const old_script = document.querySelector(
      `script[src="https://w3c.github.io/htmldiff-nav/index.js"]`,
    );
    if (old_script !== null) {
      old_script.remove();
      observer.disconnect();

      const new_script = document.createElement("script");
      new_script.src = "{{ HTMLDIFF-NAV-SRC }}";
      new_script.type = "module";
      document.head.appendChild(new_script);
    }
  });
  observer.observe(document.head, { childList: true });
}
