
#import "/typ/templates/html-toolkit.typ": load-html-template
#import "@preview/cmarker:0.1.6"

/// Wraps the following content with the HTML template.
#show: load-html-template.with(
  "/typ/templates/template.html",
  extra-head: {
    html.elem("style", read("public/global.css"))
    html.elem("script", read("/public/main.js"))
  },
)

#show: html.elem.with("main")

#html.elem("h1")[
  clreq Analysis for Typst
]

#cmarker.render(read("main.md"))


