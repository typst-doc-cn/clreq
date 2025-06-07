#import "/typ/templates/html-toolkit.typ": load-html-template, h

/// Wraps the following content with the HTML template.
#show: load-html-template.with(
  "/typ/templates/template.html",
  extra-head: {
    h.style(read("public/global.css"))
    h.script(read("/public/main.js"))
  },
)

#show: h.main

#include "main.typ"
