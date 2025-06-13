/// Loader of the table of contents (a ReSpec module)

#import "./templates/html-toolkit.typ": h, asset-url

#let respec-asset(path) = asset-url("/respec/" + path)

/// Extra heads required by this module
///
/// - base-url (str): Base URL without a trailing slash
/// -> content
#let extra-heads = {
  // `base.override.css` should be put _after_ `base.css`.
  // Reason: The former overrides the latter.
  h.link({ }, rel: "stylesheet", href: respec-asset("base.css"))
  h.link({ }, rel: "stylesheet", href: respec-asset("base.override.css"))

  // `sidebar.js` should be put after `structure.js`.
  // Reason: The former add an event listener to `#toc`, but the latter creates a new `#toc` and replaces the original one, discarding all listeners.
  h.script(
    type: "module",
    ```js
    import { makeToc } from "[[structure.js]]"
    makeToc({ maxTocLevel: 2 })
    ```
      .text
      .replace("[[structure.js]]", respec-asset("structure.js")),
  )
  h.script({ }, src: respec-asset("sidebar.js"), defer: "true")

  h.script({ }, src: respec-asset("language.js"), type: "module")
}

/// The table of contents that will be created by this module
///
/// Usage: `#show outline: toc`
#let toc = html.elem("nav", attrs: (id: "toc"))
