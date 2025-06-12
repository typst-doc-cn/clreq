/// A module providing workarounds for HTML features not supported by typst yet

#import "./html-toolkit.typ": h

/// Display the linked URL in a new tab
///
/// Usage: `#show link: link-in-new-tab`
#let link-in-new-tab = it => h.a(target: "_blank", href: it.dest, it.body)

/// Make references to headings clickable
///
/// Usage: `#show: make-heading-refs-clickable`
///
/// “non-URL links are not yet supported by HTML export.”
#let make-heading-refs-clickable(body) = {
  // https://github.com/Glomzzz/typsite/blob/c5f99270eff92cfdad58bbf4a78ea127d1aed310/resources/root/lib.typ#L184-L229
  show heading: it => {
    let label = it.at("label", default: none)
    if label == none {
      it
    } else {
      // Add id to headings in html
      html.elem(
        "h" + str(it.level + 1),
        attrs: (id: str(label)),
        {
          counter(heading).display(it.numbering)
          [ ]
          it.body
        },
      )
    }
  }
  // https://github.com/Glomzzz/typsite/blob/c5f99270eff92cfdad58bbf4a78ea127d1aed310/resources/root/lib.typ#L155-L167
  show ref: it => {
    let el = it.element
    if el != none and el.func() == heading {
      // Override heading references.
      h.a(
        href: "#" + str(it.target),
        // `§` is agnostic to the language
        numbering("§" + el.numbering, ..counter(heading).at(el.location())),
      )
    } else {
      // Other references as usual.
      it
    }
  }
  body
}

#let html-fix = make-heading-refs-clickable
