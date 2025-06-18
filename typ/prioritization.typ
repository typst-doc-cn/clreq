/// Utilities on prioritization.
///
/// Usage: Put `#level.ok`, etc. after a heading.

#import "templates/html-toolkit.typ": h, to-html
#import "mode.typ": cache-ready, cache-dir

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
#let level-table = if cache-ready {
  to-html(xml(cache-dir + "prioritization.level-table.svg").first())
} else {
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

  set text(font: ("Libertinus Serif", "Noto Color Emoji"))

  table(
    columns: 3,
    align: (x, y) => (if x == 0 { end } else if y <= 1 { center } else { start }) + horizon,
    stroke: none,
    table.cell(rowspan: 2, smallcaps[*Difficulty to Resolve*]),
    table.vline(),
    table.cell(colspan: 2, smallcaps[*Issue*]),
    table.hline(stroke: 0.5pt),
    [🚲 *Typical*],
    [🚀 *Specialized*],
    table.hline(),
    [*Works by default* 😃], level.ok, level.ok,
    [*Requires simple config* ✅], level.advanced, level.ok,
    [*Easy but not obvious* 🤨], level.basic, level.advanced,
    [*Hard or fragile* 💀], level.broken, level.basic,
    table.hline(stroke: 0.5pt),
    ..(
      ([*Needs further research* 🔎], level.tbd),
      ([*Irrelevant to this script* 🖖], level.na),
    )
      .map(((k, v)) => (k, table.cell(colspan: 2, box(inset: (left: 27%), width: 100%, v))))
      .flatten(),
  )
}

#let paint-level(level) = {
  let l = config.at(level)
  h.span(
    {
      h.span(
        style: "display: inline-block; width: 1em; height: 1em; margin: 0.25em; vertical-align: -5%",
        box(html.frame(circle(radius: 0.5em, stroke: none, fill: l.paint))),
      )
      l.human
    },
    class: "unbreakable",
    data-priority-level: level,
  )
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
