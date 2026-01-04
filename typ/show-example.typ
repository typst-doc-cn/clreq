#import "@preview/digestify:0.1.0": bytes-to-hex, md5

#import "templates/html-toolkit.typ": div-frame
#import "templates/html-fix.typ": external-svg
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
/// -> content
#let layout-example(code, preview) = html.div(
  class: "example",
  {
    code
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
  html.div(
    class: "example",
    // Put an annotation when hovering
    ..if mode == "dev" { (title: path) },
    {
      code
      html.div(class: "preview", if cache-ready {
        show image: external-svg
        image(path)
      })
    },
  )
}


/// `f: U → V`, `x: U | none` ⇒ `optional-map(f, x): V | none`
/// https://doc.rust-lang.org/stable/std/option/enum.Option.html#method.map
#let optional-map(f, x) = if x == none { none } else { f(x) }

/// - x (str):
/// -> str
#let hash(x) = bytes-to-hex(md5(bytes(x)))


/// Adds the language `example`, etc. to `raw` that can be used to render code examples side-by-side with an automatic preview.
///
/// Please refer to https://github.com/Mc-Zen/tidy/releases/latest/download/tidy-guide.pdf#tidy-render-examples() for more info.
#let render-examples(
  /// Body to apply the show rule to.
  /// -> any
  body,
) = {
  /// - raw (str): The source of a simple or page example.
  /// -> dictionary `(displayed, executed)`
  let parse-example(raw) = {
    let lines = raw
      .split("\n")
      .map(x => if x.starts-with(">>>") {
        (
          displayed: none,
          executed: x.trim(">>>", at: start),
        )
      } else if x.starts-with("<<<") {
        (
          displayed: if x == "<<<" {
            "" // Support displaying an empty line
          } else {
            // The space after `<<<` is intentional. It is consistent with the official, but different with tidy.
            assert(
              x.starts-with("<<< "),
              message: "this line in the example is ambiguous; consider adding a space after `<<<`:\n" + x,
            )
            x.trim("<<< ", at: start)
          },
          executed: none,
        )
      } else {
        // Regular lines
        (displayed: x, executed: x)
      })


    let displayed = lines.map(x => x.displayed).filter(x => x != none).join("\n")
    let executed = lines.map(x => x.executed).filter(x => x != none).join("\n")

    (displayed: displayed, executed: executed)
  }

  let fix-scaling(it) = {
    // This reverts the default style for `raw`, making the result of `#context 1em.to-absolute()` in simple examples consistent with that in regular documents.
    //
    // We have to apply this to `layout*-example` functions in all kinds of examples.
    //
    // Reason: In typst v0.14.0-rc.1, `text.size` does not affect the apparent size of text in HTML, but does affect the conversion rate between the absolute lengths in Typst and HTML.
    // If an image is sized absolutely in points, then typst will make sure its relative size to text is the same in both PNG/SVG/PDF and HTML.
    // SVGs compiled from page and bibliography examples specify their sizes in absolute lengths.
    // To make scales of preview images consistent, we have to apply this rule to all kinds of examples.
    // https://github.com/typst/typst/issues/7114
    set text(1em / 0.8)

    it
  }

  // Simple example, directly evaluated in main.typ.
  show raw.where(lang: "example"): it => {
    let (displayed, executed) = parse-example(it.text)

    let full-executed = ````typ
    // Some browsers hide the border. Therefore, the inset is necessary.
    #show: block.with(inset: 0.5em)
    {GENERAL-PREAMBLE}

    {executed}
    ````
      .text
      .replace("{GENERAL-PREAMBLE}", GENERAL-PREAMBLE)
      .replace("{executed}", executed)

    show: fix-scaling
    layout-example(
      optional-map(raw.with(block: true, lang: "typ"), displayed),
      [#eval(full-executed, mode: "markup")],
    )
  }

  // Page example, compiled by scripts/compile.ts.
  show raw.where(lang: "example-page"): it => {
    let (displayed, executed) = parse-example(it.text)

    let full-executed = ````typ
    // Some browsers hide the border. Therefore, the margin is necessary.
    #set page(width: auto, height: auto, margin: 0.5em, fill: none)
    {GENERAL-PREAMBLE}

    {executed}
    ````
      .text
      .replace("{GENERAL-PREAMBLE}", GENERAL-PREAMBLE)
      .replace("{executed}", executed)

    let id = "example-" + hash(full-executed)
    [
      #metadata((id: id, content: full-executed)) <external-example>
    ]
    show: fix-scaling
    layout-external-example(optional-map(raw.with(block: true, lang: "typ"), displayed), id)
  }

  // Bibliography example, compiled by scripts/compile.ts.
  show raw.where(lang: "example-bib"): it => {
    let lines = it.text.split("\n")

    let lang = if it.text.trim().starts-with("@") { "bib" } else { "yaml" }
    let comment = if lang == "bib" { "%" } else { "#" }

    let displayed = lines.filter(x => not x.starts-with(comment)).join("\n")
    let expected = lines.filter(x => x.starts-with(comment)).map(x => x.trim(comment, at: start).trim())

    let executed = ````typ
    // Some browsers hide the border. Therefore, the margin is necessary.
    #set page(width: 30em, height: auto, margin: 0.5em, fill: none)
    {GENERAL-PREAMBLE}

    Current:

    #bibliography(
      bytes(```{lang}
    {displayed}
    ```.text),
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
      .replace("{lang}", lang) // `lang` is unnecessary here, but helps debugging
      .replace("{displayed}", displayed)
      .replace("{expected}", expected.map(x => "+ " + x).join("\n"))

    let id = "example-" + hash(executed)
    [
      #metadata((id: id, content: executed)) <external-example>
    ]
    show: fix-scaling
    layout-external-example(raw(displayed, block: true, lang: lang), id)
  }

  body
}

/// Layout a git log in a `<details>`
#let layout-git-log(summary: [], log) = html.details(class: "example", {
  html.summary(summary)
  raw(log, lang: "gitlog", block: true)
})
