/// Integrate typst as a backend for vite
/// https://vite.dev/guide/backend-integration.html

#import "../templates/html-toolkit.typ": h, asset-url
#import "../mode.typ": mode

#let manifest-path = "/dist/.vite/manifest.json"

/// Load a file
///
/// - paths (array<str>):
/// - mode ("dev" | "prod"):
/// -> content
#let load-files(paths) = {
  let url(path) = asset-url("/" + path)

  if mode == "dev" {
    h.script({ }, type: "module", src: url("@vite/client"))
    for path in paths {
      h.script({ }, type: "module", src: url(path))
    }
  } else {
    let manifest = json(manifest-path)

    for chunk in manifest.values() {
      assert("imports" not in chunk, message: "the `imports` field is not supported yet")

      h.script({ }, type: "module", src: url(chunk.file))

      for css in chunk.css {
        h.link({ }, rel: "stylesheet", href: url(css))
      }
    }
  }
}
