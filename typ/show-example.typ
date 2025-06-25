#import "@preview/tidy:0.4.3": show-example as tidy-example
#import "@preview/jumble:0.0.1": bytes-to-hex, sha1

#import "templates/html-fix.typ": reserve-text-fill
#import "templates/html-toolkit.typ": div, div-frame, img
#import "mode.typ": cache-dir, cache-ready, mode


/// -> str
#let GENERAL-PREAMBLE = ```typ
#set text(
  lang: "zh", // required for localization
  font: ((name: "New Computer Modern", covers: "latin-in-cjk"), "Noto Serif CJK SC"),
  // Make it reproducible.
  fallback: false,
)
```.text


/// Layout an example
///
/// Edit from test cases of tidy.
/// https://github.com/Mc-Zen/tidy/blob/3dbdde92b1de56e516886255ce25ed813a87d008/tests/show-example/test.typ
///
/// - code (content): a `raw` element containing the displayed code
/// - preview (content): previewed result
/// - annotation (str): an annotation shown when hovering
/// -> content
#let layout-example(code, preview, annotation: none, ..sink) = div(
  class: "example",
  ..if annotation != none { (title: annotation) },
  {
    {
      show text: reserve-text-fill
      code
    }
    div-frame(preview, class: "preview")
  },
)


/// Layout an external example
///
/// Drop the preview if the cache is not ready yet.
///
/// - code (content): a `raw` element containing the displayed code
/// - id (str): ID of the executed code
/// -> content
#let layout-external-example(code, id) = {
  let path = cache-dir + "{id}.svg".replace("{id}", id)
  layout-example(
    code,
    if cache-ready { image(path) },
    ..if mode == "dev" { (annotation: path) },
  )
}


/// `f: U → V`, `x: U | none` ⇒ `optional-map(f, x): V | none`
/// https://doc.rust-lang.org/stable/std/option/enum.Option.html#method.map
#let optional-map(f, x) = if x == none { none } else { f(x) }


/// Adds the language `example`, etc. to `raw` that can be used to render code examples side-by-side with an automatic preview.
///
/// Please refer to https://github.com/Mc-Zen/tidy/releases/latest/download/tidy-guide.pdf#tidy-render-examples() for more info.
#let render-examples(
  /// Body to apply the show rule to.
  /// -> any
  body,
) = {
  // Simple example, directly evaluated in main.typ.
  show raw.where(lang: "example"): it => {
    set text(4em / 3)

    tidy-example.show-example(
      raw(it.text, block: true, lang: "typ"),
      mode: "markup",
      preamble: ```typ
      // Some browsers hide the border. Therefore, the inset is necessary.
      #show: block.with(inset: 0.5em)
      {GENERAL-PREAMBLE}
      ```
        .text
        .replace("{GENERAL-PREAMBLE}", GENERAL-PREAMBLE)
        + "\n",
      layout: layout-example,
    )
  }

  // Page example, compiled by scripts/compile.ts.
  show raw.where(lang: "example-page"): it => {
    let lines = it.text.split("\n")

    let displayed = lines.filter(x => not x.starts-with(">>>")).map(x => x.trim("<<<", at: start)).join("\n")
    let executed = lines.filter(x => not x.starts-with("<<<")).map(x => x.trim(">>>", at: start)).join("\n")

    let full-executed = ````typ
    // Some browsers hide the border. Therefore, the margin is necessary.
    #set page(width: auto, height: auto, margin: 0.5em, fill: none)
    {GENERAL-PREAMBLE}

    {executed}
    ````
      .text
      .replace("{GENERAL-PREAMBLE}", GENERAL-PREAMBLE)
      .replace("{executed}", executed)

    let id = "example-" + bytes-to-hex(sha1(full-executed))
    [
      #metadata((id: id, content: full-executed)) <external-example>
    ]
    set text(4em / 3)
    layout-external-example(optional-map(raw.with(block: true, lang: "typ"), displayed), id)
  }

  // Bibliography example, compiled by scripts/compile.ts.
  show raw.where(lang: "example-bib"): it => {
    let lines = it.text.split("\n")

    let displayed = lines.filter(x => not x.starts-with("%")).join("\n")
    let expected = lines.filter(x => x.starts-with("%")).map(x => x.trim("%", at: start).trim())

    let executed = ````typ
    // Some browsers hide the border. Therefore, the margin is necessary.
    #set page(width: 30em, height: auto, margin: 0.5em, fill: none)
    {GENERAL-PREAMBLE}

    Current:

    #bibliography(
      bytes(```{displayed}```.text),
      style: "gb-7714-2015-numeric",
      title: none,
      full: true,
    )

    Expected:

    #set enum(numbering: "[1]")
    {expected}
    ````
      .text
      .replace("{GENERAL-PREAMBLE}", GENERAL-PREAMBLE)
      .replace("{displayed}", displayed)
      .replace("{expected}", expected.map(x => "+ " + x).join("\n"))

    let id = "example-" + bytes-to-hex(sha1(executed))
    [
      #metadata((id: id, content: executed)) <external-example>
    ]
    set text(4em / 3)
    layout-external-example(raw(displayed, block: true, lang: "bib"), id)
  }

  body
}
