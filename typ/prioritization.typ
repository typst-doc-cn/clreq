/// Utilities on prioritization.
///
/// Usage: Put `#level.ok`, etc. at the beginning of a heading.

#import "templates/html-toolkit.typ": h, to-html

/// If cache is ready, use `target/cache/prioritization.level-table.svg`.
/// Otherwise, draw the table.
/// -> bool
#let cache-ready = sys.inputs.at("cache-ready", default: "true") == "true"

/// Configuration of levels, copied from clreq-gap.
#let config = (
  ok: (paint: rgb("008000"), human: "OK"),
  advanced: (paint: rgb("ffe4b5"), human: "Advanced"),
  basic: (paint: rgb("ffa500"), human: "Basic"),
  broken: (paint: rgb("ff0000"), human: "Broken"),
  tbd: (paint: rgb("eeeeee"), human: "To be done"),
)

/// The table explaining priority levels.
#let level-table = if cache-ready {
  to-html(xml("../target/cache/prioritization.level-table.svg").first())
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
    [*Needs further research* 🔎],
    table.cell(colspan: 2, align: center, level.tbd)
  )
}

#let paint-level(level) = {
  let l = config.at(level)
  h.span(
    html.frame(circle(radius: 0.5em, stroke: none, fill: l.paint)),
    title: l.human,
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
)
#assert.eq(level.len(), config.len())
