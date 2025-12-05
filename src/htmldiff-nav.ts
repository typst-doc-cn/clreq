/**
 * Mouse and keyboard navigation.
 *
 * Replace the original https://w3c.github.io/htmldiff-nav/index.js.
 * https://github.com/w3c/htmldiff-nav/blob/ab28ebba333cc88407da0621f046c8f10eed1d52/index.js
 *
 * # Changes
 *
 * - Remove features related to `.annoying-warning` or `script[data-navigable-selector]`.
 * - If the current change is in a `<details>`, expand the `<details>`.
 * - If a change is clicked, update internal states.
 */

class FocusState {
  private readonly changes: HTMLElement[];
  private index: number | null = null;
  private readonly size: number;

  constructor(changes: HTMLElement[]) {
    this.changes = changes;
    this.size = changes.length;
  }

  human_position(): string {
    return `${(this.index ?? -1) + 1} of ${this.size}`;
  }
  current(): HTMLElement | null {
    return this.index !== null ? this.changes[this.index] : null;
  }
  previous(): HTMLElement {
    if (this.index === null) {
      this.index = 0;
    } else {
      this.index--;
      if (this.index < 0) {
        this.index = this.size - 1;
      }
    }
    return this.changes[this.index];
  }
  next(): HTMLElement {
    if (this.index === null) {
      this.index = 0;
    } else {
      this.index++;
      if (this.index >= this.size) {
        this.index = 0;
      }
    }
    return this.changes[this.index];
  }
  stop(): void {
    this.index = null;
  }

  /**
   * Set state to a change
   * @param change
   * @returns succeeded or not
   */
  set(change: HTMLElement): boolean {
    const index = this.changes.indexOf(change);
    if (index === -1) {
      return false;
    } else {
      this.index = index;
      return true;
    }
  }
}

class UI_State {
  static readonly CSS_BORDER = "outline: 2px dashed #00F";

  private state: FocusState;
  private position_el: HTMLElement;

  /**
   * Create and initialize the UI state.
   *
   * `position` is the element showing position of the current change.
   */
  constructor(
    { changes, position }: { changes: HTMLElement[]; position: HTMLElement },
  ) {
    this.state = new FocusState(changes);

    this.position_el = position;
    this.update_position_text();
  }

  private update_position_text() {
    this.position_el.textContent = this.state.human_position();
  }

  jump_to(clicked_change: HTMLElement) {
    const last = this.state.current();
    const succeeded = this.state.set(clicked_change);
    if (succeeded) {
      // Update texts and styles
      this.clear_style(last);
      this.set_style(clicked_change);
      this.update_position_text();
    }
  }

  /** Scroll the current change into view */
  private scroll_to(current: HTMLElement) {
    // Update texts and styles
    this.set_style(current);
    this.update_position_text();

    // If `current` is in a `<details>`, expand the `<details>`
    let parent = current.parentElement;
    while (parent) {
      if (parent.tagName.toLowerCase() === "details") {
        (parent as HTMLDetailsElement).open = true;
      }
      parent = parent.parentElement;
    }

    // Scroll `current` into view
    const bCR = current.getBoundingClientRect();
    const height = globalThis.innerHeight ||
      document.documentElement.clientHeight;
    if (
      bCR.top < 0 || // we've scrolled past element
      bCR.bottom > height // element is below the fold
    ) {
      current.scrollIntoView({ block: "center" });
    }
  }

  /** Clear the style of the current change */
  private clear_style(current: HTMLElement | null) {
    if (current) {
      current.style.cssText = "";
    }
  }
  /** Set the style of the current change */
  private set_style(current: HTMLElement) {
    current.style.cssText = UI_State.CSS_BORDER;
  }

  to_next() {
    this.clear_style(this.state.current());
    this.scroll_to(this.state.next());
  }

  to_previous() {
    this.clear_style(this.state.current());
    this.scroll_to(this.state.previous());
  }

  stop() {
    this.clear_style(this.state.current());
    this.state.stop();
    this.update_position_text();
  }
}

function create_elements(): {
  next: HTMLDivElement;
  previous: HTMLDivElement;
  position: HTMLSpanElement;
} {
  const CSS_TEXT =
    "float: left; padding: 5px 15px; border-left: 1px solid #999; cursor: pointer;";

  const container = document.createElement("div");
  const display = document.createElement("div");
  const previous = document.createElement("div");
  const next = document.createElement("div");
  const position = document.createElement("span");

  display.appendChild(position);
  container.appendChild(display);
  container.appendChild(previous);
  container.appendChild(next);
  document.body.appendChild(container);

  container.className = "w3c-htmldiff-nav";
  container.style.cssText =
    "background-image: linear-gradient(transparent,rgba(0,0,0,.05) 40%,rgba(0,0,0,.1)); font: 12px sans-serif; color: #666; border-top: 1px solid #999; border-right: 1px solid #999; border-left: 1px solid #999; position: fixed; bottom: 0; right: 25px; border-radius: 3px 3px 0 0; background-color: #eee; z-index: 2147483647;";
  next.style.cssText = CSS_TEXT;
  previous.style.cssText = CSS_TEXT;
  display.style.cssText = "float: left; padding: 5px 5px;";
  position.style.cssText =
    "background-color: #fff; border: 1px solid #999; padding: 1px 5px; box-shadow: inset 0 1px 3px #ddd; border-radius: 2px";
  next.textContent = "next ›";
  next.title = 'Keyboard nav: use "j" to jump to next change.';
  previous.textContent = "‹ previous";
  previous.title = 'Keyboard nav: use "k" to jump to previous change.';

  return { next, previous, position };
}

function init() {
  const { next, previous, position } = create_elements();

  const selector = "del.diff-old, ins.diff-chg, ins.diff-new";
  const changes = Array.from(document.querySelectorAll<HTMLElement>(selector))
    .filter((e) =>
      e.offsetWidth || e.offsetHeight || e.getClientRects().length
    );

  const state = new UI_State({ changes, position });

  // Add mouse navigation
  next.addEventListener("click", () => state.to_next());
  previous.addEventListener("click", () => state.to_previous());
  changes.forEach((el) =>
    el.addEventListener("click", () => state.jump_to(el))
  );

  // Add keyboard navigation
  document.addEventListener("keydown", (e) => {
    if (!e.metaKey && e.key === "j") {
      state.to_next();
    } else if (!e.metaKey && e.key === "k") {
      state.to_previous();
    } else if (!e.metaKey && (e.key === "Escape" || e.key === "Esc")) {
      state.stop();
    }
  }, false);
}

init();
