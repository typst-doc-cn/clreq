#import "@preview/tidy:0.4.3": show-example as tidy-example
#import "@preview/jumble:0.0.1": sha1, bytes-to-hex

#import "templates/html-toolkit.typ": img, div, div-frame

#let cache-ready = sys.inputs.at("cache-ready", default: "true") == "true"
// If cache is ready, use files in `target/cache/`.
// Otherwise, skip these files.

/// Layout an example
///
/// Edit from test cases of tidy.
/// https://github.com/Mc-Zen/tidy/blob/3dbdde92b1de56e516886255ce25ed813a87d008/tests/show-example/test.typ
///
/// - code (content): a `raw` element containing the displayed code
/// - preview (content): previewed result
/// -> content
#let layout-example(code, preview, ..sink) = div(
  class: "example",
  {
    code
    div-frame(preview, class: "preview")
  },
)


/// Layout an external example
///
/// - code (content): a `raw` element containing the displayed code
/// - id (str): ID of the executed code
/// -> content
#let layout-external-example(code, id) = layout-example(
  code,
  if cache-ready {
    image("../target/cache/{id}.svg".replace("{id}", id))
  },
)


/// Adds the language `example`, etc. to `raw` that can be used to render code examples side-by-side with an automatic preview.
///
/// Please refer to https://github.com/Mc-Zen/tidy/releases/latest/download/tidy-guide.pdf#tidy-render-examples() for more info.
#let render-examples(
  /// Body to apply the show rule to.
  /// -> any
  body,
) = {
  // Internal example, directly compiled in main.typ.
  show raw.where(lang: "example"): it => {
    set text(4em / 3)

    tidy-example.show-example(
      raw(it.text, block: true, lang: "typ"),
      mode: "markup",
      preamble: ```typ
      // Some browsers hide the border. Therefore, the inset is necessary.
      #show: block.with(inset: 0.5em)
      // Make it reproducible.
      #set text(font: ((name: "New Computer Modern", covers: "latin-in-cjk"), "Noto Serif CJK SC"), fallback: false)
      ```.text
        + "\n",
      layout: layout-example,
    )
  }

  // External example, compiled by scripts/compile.mts.
  show raw.where(lang: "example-bib"): it => {
    let lines = it.text.split("\n")

    let displayed = lines.filter(x => not x.starts-with("%")).join("\n")
    let expected = lines.filter(x => x.starts-with("%")).map(x => x.trim("%", at: start).trim())

    let executed = ````typ
    #set page(width: 30em)

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
