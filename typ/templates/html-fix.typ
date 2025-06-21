/// A module providing workarounds for HTML features not supported by typst yet

#import "./html-toolkit.typ": h, asset-url

/// Display the linked URL in a new tab
///
/// Usage: `#show link: link-in-new-tab`
#let link-in-new-tab(class: none, it) = h.a(target: "_blank", href: it.dest, class: class, it.body)

/// Reserve the `fill` of `text` in HTML data attrs and CSS vars
///
/// Usage: `#show text: reserver-text-fill`
///
/// Inspired by zebraw.
/// https://github.com/hongjr03/typst-zebraw/blob/99028bf9eebe89cf0b07764e3775a4ea8aa5b5c4/src/html.typ#L21-L35
#let reserve-text-fill(it) = {
  if text.fill == black {
    it // Ignore default color
  } else {
    let fill = text.fill.to-hex()
    h.span(it, data-fill: fill, style: "--data-fill:" + fill)
  }
}

/// Externalize images in /public/
///
/// Usage: `#show image: external-image`
#let external-image(it) = {
  if type(it.source) == str and it.source.starts-with("/public/") {
    h.img(
      { },
      src: asset-url(it.source.trim("/public", at: start)),
      ..if it.alt != none { (alt: it.alt, title: it.alt) },
      ..if type(it.width) == relative { (style: "width:" + repr(it.width.ratio)) },
    )
  } else {
    it
  }
}

/// Make references to headings clickable
///
/// Usage: `#show: make-heading-refs-clickable`
///
/// “non-URL links are not yet supported by HTML export.”
#let make-heading-refs-clickable(body) = {
  // https://github.com/Glomzzz/typsite/blob/c5f99270eff92cfdad58bbf4a78ea127d1aed310/resources/root/lib.typ#L184-L229
  show heading: it => {
    if it.numbering == none {
      it
    } else {
      html.elem(
        "h" + str(it.level + 1),
        // Add id to headings in html if there exists a label
        attrs: if it.at("label", default: none) != none { (id: str(it.label)) } else { (:) },
        {
          // Wrap the numbering with a class
          h.span(counter(heading).display(it.numbering), class: "secno")
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

/// A collection of all fixes
#let html-fix(body) = {
  show: make-heading-refs-clickable
  show image: external-image
  body
}
