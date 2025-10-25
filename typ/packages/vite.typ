/// Integrate typst as a backend for vite
/// https://vite.dev/guide/backend-integration.html

#import "../templates/html-toolkit.typ": asset-url
#import "../mode.typ": mode

#let manifest-path = "/dist/.vite/manifest.json"

/// - raw-path (str):
/// -> (path: str, as-module: bool)
#let _parse-path(raw-path) = {
  if raw-path.ends-with("#nomodule") {
    (path: raw-path.trim("#nomodule", at: end), as-module: false)
  } else {
    (path: raw-path, as-module: true)
  }
}

/// Load a file
///
/// All scripts will be loaded as a module be default.
///
/// If a script should be executed before DOM is loaded, add a `#nomodule` suffix.
/// Note that it is not officially supported by vite, and does not work in `dev` mode.
///
/// - paths (array<str>): Path to typescript entry points.
/// -> content
#let load-files(paths) = {
  let url(path) = asset-url("/" + path)

  if mode == "dev" {
    html.script(type: "module", src: url("@vite/client"))
    for raw-path in paths {
      let (path, as-module) = _parse-path(raw-path)
      html.script(type: "module", src: url(path))
    }
  } else {
    let manifest = json(manifest-path)

    for raw-path in paths {
      let (path, as-module) = _parse-path(raw-path)
      let chunk = manifest.at(path)

      assert("imports" not in chunk, message: "the `imports` field is not supported yet")

      html.script(src: url(chunk.file), ..if as-module { (type: "module") })

      for css in chunk.at("css", default: ()) {
        html.link(rel: "stylesheet", href: url(css))
      }
    }
  }
}
