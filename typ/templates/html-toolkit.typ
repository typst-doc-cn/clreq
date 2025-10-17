/// = HTML Toolkit
///
/// This package provides a set of utility functions for working with HTML export.

/// CLI sets the `x-url-base` to the base URL for assets. This is needed if you host the website on the github pages.
///
/// For example, if you host the website on `https://username.github.io/project/`, you should set `x-url-base` to `/project/`.
#let assets-url-base = sys.inputs.at("x-url-base", default: none)
/// The base URL for content.
#let url-base = if assets-url-base != none { assets-url-base } else { "/dist/" }
/// The base URL for assets.
#let assets-url-base = if assets-url-base != none { assets-url-base } else { "/" }

/// Converts the path to the asset to the URL.
///
/// - path (str): The path to the asset.
/// -> str
#let asset-url(path) = {
  if path != none and path.starts-with("/") {
    assets-url-base + path.slice(1)
  } else {
    path
  }
}

/// Converts the xml loaded data to HTML.
///
/// - data (dict): The data to convert to HTML.
/// -> content
#let to-html(data, slot: none) = {
  let to-html = to-html.with(slot: slot)
  if type(data) == str {
    let data = data.trim()
    if data.len() > 0 {
      data
    }
  } else {
    if data.tag == "slot" {
      return slot
    }
    if data.tag.len() == 0 {
      return none
    }

    let rewrite(data, attr) = {
      let value = data.attrs.at(attr, default: none)
      if value != none and value.starts-with("/") {
        data.attrs.at(attr) = asset-url(value)
      }

      data
    }

    data = rewrite(data, "href")
    data = rewrite(data, "src")

    html.elem(data.tag, attrs: data.attrs, data.children.map(to-html).join())
  }
}

/// Loads the HTML template and inserts the content.
///
/// - template-path (str): The absolute path to the HTML template.
/// - content (content): The body to insert into the template.
/// - extra-head (content): Additional content to insert into the head.
/// ->
#let load-html-template(template-path, body, extra-head: none) = {
  let html-elem = xml(template-path).at(0)
  let html-children = html-elem.children.filter(it => type(it) != str)
  let head = to-html(html-children.at(0)).body
  let body = to-html(html-children.at(1), slot: body)

  html.html(..html-elem.attrs, {
    html.head({
      head
      extra-head
    })
    body
  })
}

/// Creates an embeded block typst frame.
#let div-frame(content, ..attrs) = html.div(html.frame(content), ..attrs)
