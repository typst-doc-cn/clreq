/// A module providing workarounds for HTML features not supported by typst yet

#import "./html-toolkit.typ": asset-url

/// Display the linked URL in a new tab
///
/// Usage: `#show link: link-in-new-tab`
#let link-in-new-tab(class: none, it) = html.a(
  target: "_blank",
  href: it.dest,
  ..if class != none { (class: class) },
  it.body,
)

/// Use proportional-width apostrophes
///
/// The main font is for Chinese, so it uses full-width apostrophes by default.
/// For Latin texts, it is better to use proportional-width ones.
/// https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html#若中西统一使用相同字体
///
/// Usage: `#show: enable-proportional-width`
#let latin-apostrophe = html.span.with(style: "font-feature-settings: 'pwid';")

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
    html.span(it, data-fill: fill, style: "--data-fill:" + fill)
  }
}

/// Externalize images in /public/
///
/// Usage: `#show image: external-image`
#let external-image(it) = {
  if type(it.source) == str and it.source.starts-with("/public/") {
    html.img(
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
          html.span(counter(heading).display(it.numbering), class: "secno")
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
      html.a(
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
