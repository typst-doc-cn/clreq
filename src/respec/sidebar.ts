/**
 * The following script is copied from W3C/ReSpec under CC0-1.0 license
 * https://github.com/speced/bikeshed/blob/527e9641607d686e5c439f9999d40360607ee792/bikeshed/spec-data/readonly/boilerplate/footer.include
 * https://www.w3.org/scripts/TR/2021/fixup.js
 */

const tocToggleId = "toc-toggle";
const tocJumpId = "toc-jump";
const tocCollapseId = "toc-collapse";
const tocExpandId = "toc-expand";

interface CreatedElements {
  /** The button that toggles ToC sidebar, `#{tocToggleId}` */
  toggle: HTMLAnchorElement;
}

const t = {
  collapseSidebar: "Collapse Sidebar",
  expandSidebar: "Pop Out Sidebar",
  jumpToToc: "Jump to Table of Contents",
};
const collapseSidebarText = '<span aria-hidden="true">←</span> ' +
  `<span id="${tocCollapseId}-text">${t.collapseSidebar}</span>`;
const expandSidebarText = '<span aria-hidden="true">→</span> ' +
  `<span id="${tocExpandId}-text">${t.expandSidebar}</span>`;
const tocJumpText = '<span aria-hidden="true">↑</span> ' +
  `<span id="${tocJumpId}-text">${t.jumpToToc}</span>`;

/** `true` means toc-sidebar, `false` means toc-inline */
type SidebarStatus = boolean;

/** Matches if default to toc-sidebar, does not match if default to toc-inline */
const sidebarMedia = window.matchMedia("screen and (min-width: 78em)");

function toggleSidebar(
  { toggle }: CreatedElements,
  /** `SidebarStatus` to select the desired status, `undefined` to toggle between them */
  on: SidebarStatus | undefined = undefined,
  /** Whether to force to skip scroll */
  skipScroll: boolean = false,
): SidebarStatus {
  if (on === undefined) {
    on = !document.body.classList.contains("toc-sidebar");
  }

  if (!skipScroll) {
    /* Don't scroll to compensate for the ToC if we're above it already. */
    let headY = 0;
    const head = document.querySelector<HTMLElement>(".head");
    if (head) {
      // terrible approx of "top of ToC"
      headY += head.offsetTop + head.offsetHeight;
    }
    skipScroll = window.scrollY < headY;
  }

  const tocNav = document.getElementById("toc") as HTMLElement;
  if (on) {
    document.body.classList.add("toc-sidebar");
    document.body.classList.remove("toc-inline");

    toggle.innerHTML = collapseSidebarText;
    toggle.setAttribute("aria-labelledby", `${tocCollapseId}-text`);

    if (!skipScroll) {
      const tocHeight = tocNav.offsetHeight;
      window.scrollBy(0, 0 - tocHeight);
    }

    tocNav.focus();
  } else {
    document.body.classList.add("toc-inline");
    document.body.classList.remove("toc-sidebar");

    toggle.innerHTML = expandSidebarText;
    toggle.setAttribute("aria-labelledby", `${tocExpandId}-text`);

    if (!skipScroll) {
      window.scrollBy(0, tocNav.offsetHeight);
    }

    if (toggle.matches(":hover")) {
      /* Unfocus button when not using keyboard navigation,
         because I don't know where else to send the focus. */
      toggle.blur();
    }
  }

  return on;
}

function createSidebarToggle(): CreatedElements {
  /* Create the sidebar toggle in JS; it shouldn't exist when JS is off. */
  const toggle = document.createElement("a");
  /* This should probably be a button, but appearance isn't standards-track.*/
  toggle.id = tocToggleId;
  toggle.classList.add("toc-toggle");
  toggle.href = "#toc";
  toggle.innerHTML = collapseSidebarText;
  toggle.setAttribute("aria-labelledby", `${tocCollapseId}-text`);

  /* Get <nav id=toc-nav>, or make it if we don't have one. */
  let tocNav = document.getElementById("toc-nav");
  if (!tocNav) {
    tocNav = document.createElement("p");
    tocNav.id = "toc-nav";
    /* Prepend for better keyboard navigation */
    document.body.insertBefore(tocNav, document.body.firstChild);
  }

  /* While we're at it, make sure we have a Jump to Toc link. */
  let tocJump = document.getElementById(tocJumpId) as HTMLAnchorElement | null;
  if (!tocJump) {
    tocJump = document.createElement("a");
    tocJump.id = tocJumpId;
    tocJump.href = "#toc";
    tocJump.innerHTML = tocJumpText;
    tocJump.setAttribute("aria-labelledby", `${tocJumpId}-text`);
    tocNav.appendChild(tocJump);
  }

  tocNav.appendChild(toggle);

  return { toggle };
}

function setupToggleListener({ toggle }: CreatedElements): void {
  const toggleToDefault = (e: MediaQueryListEvent): void => {
    toggleSidebar({ toggle }, e.matches);
  };

  // Toggle the sidebar to the default state at start up
  // Force to skip scroll because it will be the first view
  toggleSidebar({ toggle }, sidebarMedia.matches, true);

  // Listen to width changes, and auto-collapse when out of room
  sidebarMedia.addEventListener("change", toggleToDefault);

  // Toggle the sidebar when clicked
  toggle.addEventListener("click", (e) => {
    e.preventDefault();

    // Persist explicit off states
    sidebarMedia.removeEventListener("change", toggleToDefault);

    // Toggle the sidebar
    const finallyOn = toggleSidebar({ toggle });

    // If the sidebar is finally on, auto-collapse when out of room later
    if (finallyOn) {
      sidebarMedia.addEventListener("change", toggleToDefault);
    }

    return false;
  }, false);
}

export default function (): void {
  const toc = document.getElementById("toc");
  if (!toc) {
    console.warn(
      "Can't find Table of Contents. Please use <nav id='toc'> around the ToC.",
    );
    return;
  }

  const created = createSidebarToggle();
  setupToggleListener(created);

  /* If the sidebar has been manually opened and is currently overlaying the text
     (window too small for the MQ to add the margin to body),
     then auto-close the sidebar once you click on something in there. */
  toc.addEventListener("click", (e) => {
    if (
      document.body.classList.contains("toc-sidebar") && !sidebarMedia.matches
    ) {
      let el = e.target as HTMLElement;
      while (el != toc) { // find closest <a>
        if (el.tagName.toLowerCase() === "a") {
          toggleSidebar(created, false);
          return;
        }
        el = el.parentElement!;
      }
    }
  }, false);
}
