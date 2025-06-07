/// = HTML Toolkit
///
/// This package provides a set of utility functions for working with HTML export.


#import "supports-text.typ": *

/// The target for the HTML export.
///
/// Avaiable targets:
/// - `web-light`: Light theme for web.
/// - `web-dark`: Dark theme for web.
/// - `pdf`: PDF export.
#let x-target = sys.inputs.at("x-target", default: "web-light")
/// Whether the target uses a dark theme.
#let x-is-dark = x-target.ends-with("dark")
/// Whether the target uses a light theme.
#let x-is-light = x-target.ends-with("light")

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

    html.elem(
      data.tag,
      attrs: data.attrs,
      data.children.map(to-html).join(),
    )
  }
}

/// Creats a ```html <meta>``` tag for the ```html <head>```.
///
/// - name (str): The name of the meta tag.
/// - content (str): The content of the meta tag.
/// -> content
#let head-meta(name, content) = html.elem(
  "meta",
  attrs: (
    "name": name,
    "content": content,
  ),
)

/// Loads the HTML template and inserts the content.
///
/// - template-path (str): The absolute path to the HTML template.
/// - content (content): The body to insert into the template.
/// - extra-head (content): Additional content to insert into the head.
/// ->
#let load-html-template(template-path, body, extra-head: none) = {
  let html-children = xml(template-path).at(0).children.filter(it => type(it) != str)
  let head = to-html(html-children.at(0)).body
  let body = to-html(html-children.at(1), slot: body)

  html.elem(
    "html",
    attrs: (
      "lang": "en",
      "xmlns": "http://www.w3.org/1999/xhtml",
    ),
    {
      html.elem(
        "head",
        {
          head
          extra-head
          context if document.description != none {
            head-meta("description", plain-text(document.description))
          }
        },
      )
      // html.elem("body", repr(body))
      body
    },
  )
}

/// Creates a preload link for the given CSS file.
///
/// - href (str): The URL of the CSS file.
/// -> content
#let preload-css(href) = to-html(
  xml
    .decode(
      ```xml
      <link
      rel="preload"
      as="style"
      href="{{href}}"
      onload="this.rel='stylesheet'"
      />
      ```
        .text
        .replace("{{href}}", href),
    )
    .at(0),
)

/// Creates a HTML element.
///
/// - content (content): The content of the element.
/// - tag (str): The tag of the element.
#let html-elem(content, ..attrs, tag: "div") = html.elem(
  tag,
  content,
  attrs: attrs.named(),
)

/// Creates a ```html <a>``` element with the given content.
#let a = html-elem.with(tag: "a")
/// Creates a ```html <span>``` element with the given content.
#let span = html-elem.with(tag: "span")
/// Creates a ```html <div>``` element with the given content.
#let div = html-elem.with(tag: "div")
/// Creates a ```html <style>``` element with the given content.
#let style = html-elem.with(tag: "style")
/// Creates a ```html <h1>``` element with the given content.
#let h1 = html-elem.with(tag: "h1")
/// Creates a ```html <h2>``` element with the given content.
#let h2 = html-elem.with(tag: "h2")

/// Creates an embeded block typst frame.
#let div-frame(content, attrs: (:)) = html.elem("div", html.frame(content), attrs: attrs)
