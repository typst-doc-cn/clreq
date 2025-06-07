#import "/typ/templates/html-toolkit.typ": load-html-template

/// Wraps the following content with the HTML template.
#show: load-html-template.with(
  "/typ/templates/template.html",
  extra-head: {
    html.elem("style", read("public/global.css"))
    html.elem("script", read("/public/main.js"))
  },
)

#show: html.elem.with("main")

#include "main.typ"
