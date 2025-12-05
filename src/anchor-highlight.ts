import "./anchor-highlight.css";

function highlightElement(el: Element): void {
  const cls = "anchor-highlight";
  el.classList.add(cls);

  el.addEventListener("animationend", () => {
    el.classList.remove(cls);
  }, { once: true });
}

function highlightCurrentAnchor(): void {
  const id = decodeURIComponent(window.location.hash.replace(/^#/, ""));
  const target = document.getElementById(id);
  if (target !== null) {
    highlightElement(target);
  }
}

highlightCurrentAnchor();
window.addEventListener("hashchange", highlightCurrentAnchor);
