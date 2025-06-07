#import "templates/html-toolkit.typ": a, span, div, div-frame

/// Link to a GitHub issue
///
/// - repo-num (str): Repo and issue number, e.g., `"typst#193"`, `"hayagriva#189"`
/// - anchor (str): Anchor in the page, e.g., `"#issuecomment-1855739446"`
/// -> content
#let issue(repo-num, anchor: "") = {
  let (repo, num) = repo-num.split("#")
  if not repo.contains("/") {
    repo = "typst/" + repo
  }

  show link: it => a(target: "_blank", href: it.dest, it.body)
  link(
    "https://github.com/" + repo + "/issues/" + num + anchor,
    {
      span(
        class: "icon",
        // https://primer.style/octicons/icon/issue-opened-16/
        html.elem(
          "svg",
          {
            html.elem("path", attrs: (d: "M8 9.5a1.5 1.5 0 1 0 0-3 1.5 1.5 0 0 0 0 3Z"))
            html.elem(
              "path",
              attrs: (d: "M8 0a8 8 0 1 1 0 16A8 8 0 0 1 8 0ZM1.5 8a6.5 6.5 0 1 0 13 0 6.5 6.5 0 0 0-13 0Z"),
            )
          },
        ),
      )
      repo-num
    },
  )
}


#import "@preview/tidy:0.4.3": show-example as tidy-example

/// Adds the two languages `example` and `examplec` to `raw` that can be used to render code examples side-by-side with an automatic preview.
///
/// Please refer to https://github.com/Mc-Zen/tidy/releases/latest/download/tidy-guide.pdf#tidy-render-examples() for more info.
#let render-examples = tidy-example.render-examples.with(
  // Edit from test cases of tidy.
  // https://github.com/Mc-Zen/tidy/blob/3dbdde92b1de56e516886255ce25ed813a87d008/tests/show-example/test.typ
  layout: (code, preview, ..sink) => {
    div(
      class: "example",
      {
        code
        div-frame(attrs: (class: "preview"), preview)
      },
    )
  },
)
