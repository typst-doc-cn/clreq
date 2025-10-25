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

/// Improve references to headings
///
/// Our headings are bilingual and the numbers need special formatting.
/// Therefore, we have to override the default implementation.
///
/// Usage: `#show: improve-heading-refs`
#let improve-heading-refs(body) = {
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
      link(
        el.location(),
        // `§` is agnostic to the language.
        // There should be no space between `§` and the numbers, so we cannot set `heading.supplement`.
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
  show: improve-heading-refs
  show image: external-image
  body
}
