#import "/typ/templates/html-toolkit.typ": load-html-template, h
#import "/typ/templates/html-fix.typ": html-fix
#import "/typ/respec.typ"
#import "/typ/packages/vite.typ"

/// Wraps the following content with the HTML template.
#show: load-html-template.with(
  "/typ/templates/template.html",
  extra-head: {
    vite.load-files(("src/main.ts", "src/theme.ts#nomodule"))
  },
)

#show: h.main

#show outline: respec.toc
#show: html-fix

#show "W3C": h.abbr("W3C", title: "World Wide Web Consortium")
#show figure.where(kind: table): set figure.caption(position: top)

#h.h1[
  #h.span(style: "display: inline-block;")[
    #link("https://www.w3.org/TR/clreq/")[clreq]-#link("https://www.w3.org/TR/clreq-gap/")[gap] for #link("https://typst.app/home")[typst]
  ]
  #h.span(style: "display: inline-block; font-weight: normal; font-size: 1rem; color: var(--gray-color);")[
    #datetime.today().display(), typst v#sys.version
  ]
]

#include "main.typ"
