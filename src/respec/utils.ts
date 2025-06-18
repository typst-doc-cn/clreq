/**
 * As the name implies, this contains a ragtag gang of methods that just don't fit anywhere else.
 *
 * Adapted from ReSpec.
 *
 * https://github.com/speced/respec/blob/eaa1596ef5c4207ab350808c1593d3a39600fbed/src/core/utils.js
 * https://www.w3.org/Consortium/Legal/2015/copyright-software-and-document
 *
 * @module
 */

/**
 * A simple html template tag replacement for hyperHTML
 *
 * @param strings - Template string array.
 * @param values - Values to interpolate into the template.
 * @returns - The resulting DOM element or fragment.
 */
export function html(
  strings: TemplateStringsArray,
  ...values: (string | Element | DocumentFragment)[]
): Element | DocumentFragment {
  let str = "";
  for (let i = 0; i < strings.length; i++) {
    str += strings[i];
    if (i < values.length) {
      const value = values[i];
      if (value instanceof Element || value instanceof DocumentFragment) {
        // @ts-ignore
        str += value.outerHTML;
      } else {
        str += value;
      }
    }
  }
  const template = document.createElement("template");
  template.innerHTML = str.trim();
  return template.content.children.length === 1
    // @ts-ignore
    ? template.content.firstElementChild
    : template.content;
}

/**
 * Creates and sets an ID to an element (elem) using a specific prefix if
 * provided, and a specific text if given.
 * @param elem element
 * @param pfx prefix
 * @param txt text
 * @param noLC do not convert to lowercase
 * @returns generated (or existing) id for element
 */
export function addId(
  elem: HTMLElement,
  pfx: string | null = "",
  txt = "",
  noLC = false,
): string {
  if (elem.id) {
    return elem.id;
  }
  if (!txt) {
    // @ts-ignore
    txt = (elem.title ? elem.title : elem.textContent).trim();
  }
  let id = noLC ? txt : txt.toLowerCase();
  id = id
    .trim()
    .normalize("NFD")
    .replace(/[\u0300-\u036f]/g, "")
    .replace(/\W+/gim, "-")
    .replace(/^-+/, "")
    .replace(/-+$/, "");

  if (!id) {
    id = "generatedID";
  } else if (/\.$/.test(id) || !/^[a-z]/i.test(pfx || id)) {
    id = `x${id}`; // trailing . doesn't play well with jQuery
  }
  if (pfx) {
    id = `${pfx}-${id}`;
  }
  if (elem.ownerDocument.getElementById(id)) {
    let i = 0;
    let nextId = `${id}-${i}`;
    while (elem.ownerDocument.getElementById(nextId)) {
      i += 1;
      nextId = `${id}-${i}`;
    }
    id = nextId;
  }
  elem.id = id;
  return id;
}

/**
 * Changes name of a DOM Element
 * @param elem element to rename
 * @param newName new element name
 *
 * @returns new renamed element
 */
export function renameElement(
  elem: Element,
  newName: string,
  options = { copyAttributes: true },
): Element {
  if (elem.localName === newName) return elem;
  const newElement = elem.ownerDocument.createElement(newName);
  // copy attributes
  if (options.copyAttributes) {
    for (const { name, value } of elem.attributes) {
      newElement.setAttribute(name, value);
    }
  }
  // copy child nodes
  newElement.append(...elem.childNodes);
  elem.replaceWith(newElement);
  return newElement;
}
