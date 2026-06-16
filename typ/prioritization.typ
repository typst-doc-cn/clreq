/// Utilities on prioritization.
///
/// Usage: Put `#level.ok`, etc. after a heading.

#import "templates/html-toolkit.typ": to-html
#import "mode.typ": cache-dir, cache-ready

/// Configuration of levels, copied from clreq-gap.
#let config = (
  ok: (paint: rgb("008000"), human: "OK"),
  advanced: (paint: rgb("ffe4b5"), human: "Advanced"),
  basic: (paint: rgb("ffa500"), human: "Basic"),
  broken: (paint: rgb("ff0000"), human: "Broken"),
  tbd: (paint: rgb("eeeeee"), human: "To be done"),
  na: (paint: rgb("008000"), human: "Not applicable"),
)

/// The table explaining priority levels.
///
/// If cache is ready, use the cached `prioritization.level-table.svg`.
/// Otherwise, draw the table.
#let level-table(lang: "en") = if cache-ready {
  to-html(xml(cache-dir + "prioritization.level-table." + lang + ".svg").first())
} else {
  // When preparing other caches for the html target, skip this.
  show: it => context if target() == "paged" { it }

  let level = config
    .pairs()
    .map(((k, v)) => (
      k,
      grid(
        columns: 2,
        gutter: 0.5em,
        circle(radius: 0.5em, stroke: none, fill: v.paint), v.human,
      ),
    ))
    .to-dict()

  set text(font: ("Libertinus Serif", "Source Han Serif SC", "Noto Color Emoji"))

  let bbl(en, zh) = if lang == "en" { en } else { zh }

  table(
    columns: 3,
    align: (x, y) => (if x == 0 { end } else if y <= 1 { center } else { start }) + horizon,
    stroke: none,
    table.cell(rowspan: 2, smallcaps[*#bbl[Difficulty to Resolve][解决难度]*]),
    table.vline(),
    table.cell(colspan: 2, smallcaps[*#bbl[Issue][问题]*]),
    table.hline(stroke: 0.5pt),
    [🚲 *#bbl[Typical][常见]*],
    [🚀 *#bbl[Specialized][专业]*],
    table.hline(),
    [*#bbl[Works by default][默认即可使用]* 😃], level.ok, level.ok,
    [*#bbl[Requires simple config][只需简单设置]* ✅], level.advanced, level.ok,
    [*#bbl[Easy but not obvious][容易但不直接]* 🤨], level.basic, level.advanced,
    [*#bbl[Hard or fragile][困难而不可靠]* 💀], level.broken, level.basic,
    table.hline(stroke: 0.5pt),
    ..(
      ([*#bbl[Needs further research][等待继续调查]* 🔎], level.tbd),
      ([*#bbl[Irrelevant to this script][不涉及此文字]* 🖖], level.na),
    )
      .map(((k, v)) => (k, table.cell(colspan: 2, box(inset: (left: 27%), width: 100%, v))))
      .flatten(),
  )
}

#let paint-level(level) = {
  let l = config.at(level)
  // In typst v0.14/v0.15, `html.span` does not support `data-*` attributes, so we have to use `html.elem("span", …)`.
  // https://github.com/typst/typst/issues/6870
  html.elem(
    "span",
    {
      html.span(
        style: "display: inline-block; width: 1em; height: 1em; margin-inline: 0.25em; vertical-align: -5%",
        box(
          html.frame(circle(radius: 0.5em * 11 / 12, stroke: none, fill: l.paint)),
        ),
      )
      l.human
    },
    attrs: (
      class: "unbreakable",
      data-priority-level: level,
    ),
  )
  [#metadata(level)<priority>]
}

/// Priority levels
#let level = (
  // Do not use `map` here, or LSP’s completion will be broken.
  ok: paint-level("ok"),
  advanced: paint-level("advanced"),
  basic: paint-level("basic"),
  broken: paint-level("broken"),
  tbd: paint-level("tbd"),
  na: paint-level("na"),
)
#assert.eq(level.len(), config.len())
