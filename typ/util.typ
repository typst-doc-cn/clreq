#import "@preview/unichar:0.3.0": codepoint

#import "icon.typ"
#import "templates/html-toolkit.typ": h
#import "templates/html-fix.typ": link-in-new-tab

/// Multilingual
#let _babel(en: [], zh: [], tag: "span") = {
  // Add “todo”
  if int(en != []) + int(zh != []) >= 1 {
    if zh == [] {
      zh = [TODO: 待译]
    }
    if en == [] {
      en = [TODO: to be translated]
    }
  }

  set text(lang: "en")
  html.elem(tag, en, attrs: (lang: "en", its-locale-filter-list: "en"))

  if tag == "span" { [ ] }

  set text(lang: "zh", region: "CN")
  html.elem(tag, zh, attrs: (lang: "zh-Hans", its-locale-filter-list: "zh"))
}
/// For paragraphs
#let babel = _babel.with(tag: "p")
/// For headings
#let bbl = _babel.with(tag: "span")


/// Link to a GitHub issue
///
/// - repo-num (str): Repo and issue number, e.g., `"typst#193"`, `"hayagriva#189"`
/// - anchor (str): Anchor in the page, e.g., `"#issuecomment-1855739446"`
/// - note (content): Annotation
/// - closed (bool): State of the issue
/// -> content
#let issue(repo-num, anchor: "", note: auto, closed: false) = {
  let (repo, num) = repo-num.split("#")
  if not repo.contains("/") {
    repo = "typst/" + repo
  }

  show link: link-in-new-tab.with(class: "unbreakable")
  link("https://github.com/" + repo + "/issues/" + num + anchor, {
    if closed { icon.issue-closed } else { icon.issue-open }
    repo-num
    if note == auto {
      if anchor != "" { [~(comment)] }
    } else { [~(#note)] }
  })
  [#metadata((repo: repo, num: num, note: repr(note), closed: closed)) <issue>]
}

/// Link to a GitHub pull request
///
/// - repo-num (str): Repo and pull request number, e.g., `"typst#5777"`
/// - merged (bool): State of the pull request
/// -> content
#let pull(repo-num, merged: false) = {
  let (repo, num) = repo-num.split("#")
  if not repo.contains("/") {
    repo = "typst/" + repo
  }

  show link: link-in-new-tab.with(class: "unbreakable")
  link("https://github.com/" + repo + "/pull/" + num, {
    if merged { icon.git-merge } else { icon.git-pull-request }
    repo-num
  })
  [#metadata((repo: repo, num: num, merged: merged)) <pull>]
}

/// Link to a workaround
///
/// - dest (str): URL
/// - note (content): Annotation
/// -> content
#let workaround(dest, note: none) = {
  let human-dest = if dest.starts-with("https://typst.app/universe/package/") {
    "universe/" + dest.trim("https://typst.app/universe/package/", at: start)
  } else {
    dest.trim("https://", at: start).split(".").at(0).trim("typst-", at: start)
  }

  let body = if note == none {
    [fix (#human-dest)]
  } else {
    [fix (#human-dest, #note)]
  }

  show link: link-in-new-tab.with(class: "unbreakable")
  link(dest, {
    icon.light-bulb
    body
  })
}

/// A formatted description of the Unicode character for a given codepoint
///
/// Usage: `unichar("‘")`
#let unichar(code) = h.span(class: "unichar", {
  let c = codepoint(code)

  show smallcaps: h.span.with(class: "small-caps")

  h.span(class: "code-point")[U+#lower(c.id)]
  [~]
  raw(str.from-unicode(c.code))
  [ ]
  smallcaps(lower(c.name))
})

/// Introduction of a section
///
/// If it is derived from #link("https://github.com/w3c/i18n-activity/blob/5cfa8e5d304c8db0473562defab7032d90217f1b/templates/gap-analysis/prompts.js")[W3C i18n-activity gap-analysis prompts],
/// then provide the URL as `from-w3c`.
///
/// - from-w3c (str): URL to the original W3C prompt, if applicable.
/// - body (content):
/// -> content
#let prompt(from-w3c: none, body) = h.article(
  class: "prompt",
  {
    body

    if from-w3c != none {
      h.p(class: "license")[
        #show link: link-in-new-tab
        #bbl(
          en: [(derived from #link(from-w3c)[a W3C document] under #h.a(target: "_blank", href: "https://www.w3.org/copyright/software-license-2023/", title: "Software and Document License")[its license])],
          zh: [（按#h.a(target: "_blank", href: "https://www.w3.org/zh-hans/copyright/software-license-2023/", title: "软件和文档许可协议")[相应协议]修改自 #link(from-w3c)[W3C 文档]）],
        )
      ]
    }
  },
)

/// A side note
///
/// - summary (content): A short summary of the note
/// - body (content):
/// -> content
#let note(summary: bbl(en: [Note], zh: [注]), body) = h.aside(class: "note", role: "note", {
  h.p(class: "note-title", {
    icon.comment
    summary
  })

  body
})
