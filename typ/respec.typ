/// Loader of the table of contents (a ReSpec module)

#import "./templates/html-toolkit.typ": h, asset-url

#let respec-asset(path) = asset-url("/respec/" + path)

/// Extra heads required by this module
///
/// - base-url (str): Base URL without a trailing slash
/// -> content
#let extra-heads = {
  h.link({ }, rel: "stylesheet", href: respec-asset("base.css"))
  h.link({ }, rel: "stylesheet", href: respec-asset("base.override.css"))

  h.script({ }, src: respec-asset("sidebar.js"), defer: "true")
  h.script(
    type: "module",
    ```js
    import { makeToc } from "[[structure.js]]"
    makeToc({ maxTocLevel: 2 })
    ```
      .text
      .replace("[[structure.js]]", respec-asset("structure.js")),
  )
}

/// The table of contents that will be created by this module
///
/// Usage: `#show outline: toc`
#let toc = html.elem("nav", attrs: (id: "toc"))
