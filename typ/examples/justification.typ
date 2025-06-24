#let cell(align: center, width: 1em, body) = box(width: width, stroke: none, std.align(align, {
  // Align with texts outside any cell.
  //
  // The box’s bottom touches the baseline, which can't be changed.
  // Therefore, we have to change the bottom edge of box's content.
  set text(bottom-edge: "baseline")

  body
}))

#let example(page-width: 8em, page-n-rows: 5, headers: (), pages: ()) = {
  assert.eq(headers.len(), pages.len())

  set text(
    // It's necessary for drawing grids
    top-edge: "ascender",
    bottom-edge: "descender",
    // We cannot mix font.
    // Otherwise, numbers and Han chars will not align, because distance(bottom-edge, baseline) = distance(descender, baseline) varies with fonts.
    font: "Noto Serif CJK SC",
  )

  set raw(lang: "typm")
  show raw: set text(0.9em)

  set box(stroke: 0.5pt)

  grid(
    columns: (page-width,) * headers.len(),
    column-gutter: 2em,
    row-gutter: 1em,
    ..headers.map(text.with(0.75em, font: "New Computer Modern")).map(grid.cell.with(align: center + horizon)),
    ..pages.map(it => {
      // Cells
      place(top + start, {
        let stroke-box = box(stroke: green, width: 1em, height: 1em)
        let fill-box = box(stroke: green, fill: green.lighten(50%), width: 1em, height: 1em)
        (
          (
            (stroke-box,) * int(page-width / 1em - 1) + (fill-box,)
          )
            * page-n-rows
        ).join()
      })

      // Frame
      place(top + start, box(
        stroke: (
          x: purple.mix(blue).lighten(50%),
          y: purple.lighten(50%),
        ),
        hide(it),
      ))

      it
      parbreak()
      it
    })
  )
}
