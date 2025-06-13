#import "/typ/templates/html-toolkit.typ": load-html-template, h
#import "/typ/templates/html-fix.typ": html-fix
#import "/typ/respec.typ"

/// Wraps the following content with the HTML template.
#show: load-html-template.with(
  "/typ/templates/template.html",
  extra-head: {
    // Inline files
    h.style(read("public/global.css"))
    h.script(read("/public/main.js"), type: "module")

    // External files
    respec.extra-heads
  },
)

#show: h.main

#show outline: respec.toc
#show: html-fix

#import "typ/templates/html-toolkit.typ": abbr
#show "W3C": abbr("W3C", title: "World Wide Web Consortium")

#include "main.typ"
