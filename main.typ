#import "typ/util.typ": babel, bbl, issue, render-examples, workaround
#show: render-examples

#html.elem("h1")[
  #link("https://www.w3.org/TR/clreq/")[clreq]-#link("https://www.w3.org/TR/clreq-gap/")[gap] for typst
]

#babel(en: [Chinese Layout Gap Analysis for Typst.], zh: [分析 Typst 与中文排版的差距。])

#babel(
  en: [
    Typst is a markup-based typesetting software, and this document describes gaps for the support of the Chinese script within Typst.
    In particular, it is concerned with #link("https://www.w3.org/TR/clreq/")[text layout] and #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A")[bibliography].
    It examines whether needed features are supported by the typst compiler, and provides information on potential workarounds.
  ],
  zh: [
    Typst 是一款基于标记的排版软件，这份文档描述了它在中文支持方面的差距，特别是#link("https://www.w3.org/TR/clreq/")[排版]和#link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A")[参考文献著录]。本文会检查 typst 编译器是否支持所需功能，并介绍可能的临时解决方案。
  ],
)

#babel(
  en: [
    #emoji.warning This document is only an early draft.
    Additionally, it is not endorsed by either #link("https://www.w3.org/")[W3C] or #link("https://typst.app/home")[Typst GmbH].
    Please refer to it with caution.
  ],
  zh: [
    #emoji.warning 这份文档仅是早期草稿。此外，本文并无 #link("https://www.w3.org/")[W3C] 或 #link("https://typst.app/home")[Typst GmbH] 背书。请谨慎参考。
  ],
)

#set heading(numbering: "1.1")
#show heading.where(level: 3): set heading(numbering: none)

= Text direction

== Writing mode

=== #bbl(en: [Vertical Writing Mode], zh: [直排])

#issue("typst#5908")

== Bidirectional text (N/A)

= Glyph shaping & positioning

== Fonts selection

=== #bbl(en: [Writing non-Latin (e.g.~Chinese) text without a configured font leads to unpredictable font fallback])
#issue("typst#5040")

=== #bbl(
  en: [Wrong "monospace" font fallback for CJK characters in raw block],
  zh: [为什么代码块里面的中文字体显示不正常？],
)

#issue("typst#3385")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-in-raw.html")

=== #bbl(en: [Language-dependant font configuration])

#issue("typst#794")

== Font rendering & font styles

=== #bbl(en: [Chinese rendering error])

#issue("typst#5900")

=== #bbl(en: [Size per font])

#issue("typst#6295")

=== #bbl(en: [Compiler not rendering Chinese/CJK fonts])

#issue("typst#6054")

=== #bbl(en: [Support variable fonts])

#issue("typst#185")

== Context-based shaping and positioning (N/A)

== Cursive text (N/A)

== Letterform slopes, weights, & italics

=== #bbl(en: [Fake text weight and style (synthesized bold and italic)], zh: [中文没有加粗或斜体])

#issue("typst#394")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-bold.html", note: "bold")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-skew.html", note: "skew")

== Case & other character transforms (N/A)

= Typographic units

== Characters & encoding

== Grapheme/word segmentation & selection

= Punctuation & inline features

== Phrase & section boundaries

== Quotations & citations

=== #bbl(
  en: [`covers: "latin-in-cjk"` doesn’t cover apostrophes and quotation marks],
  zh: [引号的字体不对 / 引号的宽度不对],
)

#issue("typst#5858")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html")

== Emphasis & highlighting

=== #bbl(en: [Underline breaks when mixing Chinese and English], zh: [中英文下划线错位])

#issue("typst#1210")
#issue("typst#1716", anchor: "#issuecomment-1855739446")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/underline-misplace.html")

```example
>>> Current:
#underline[中文和English]

>>> Expected:
>>> #set underline(offset: .15em, stroke: .05em)
>>> #underline[中文和English]
```

== Abbreviation, ellipsis, & repetition

== Inline notes & annotations

=== #bbl(en: [Add support for ruby (CJK, e.g., furigana for Japanese)])

#issue("typst#1489")

=== #bbl(en: [warichu])

#issue("typst#193", note: [mentioned])

== Text decoration & other inline features

== Data formats & numbers

= Line and paragraph layout

== Line breaking & hyphenation

== Text alignment & justification

=== #bbl(en: [CJK-latin glues stretch only before latin characters])

#issue("typst#6062")

=== #bbl(en: [Strict grid for CJK, hopefully via glue])

#issue("typst#4404")

=== #bbl(en: [CJK brackets at the beginning of paragraph])

#issue("typst#4011")

=== #bbl(en: [CJK punctuation at the start of paragraphs are not adjusted sometimes])

#issue("typst#2348")

=== #bbl(
  en: [Paragraph should be able to contain tight lists and block-level equations],
  zh: [如何避免公式、图表等块元素的下一行缩进],
)

#issue("typst#3206")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/block-equation-in-paragraph.html")

=== #bbl(en: [Even inter-character spacing], zh: [均排])

#workaround("https://typst-doc-cn.github.io/guide/FAQ/character-intersperse.html")

#babel(zh: [均排是指让几个汉字占固定宽度并均匀分布。])

== Text spacing

=== #bbl(en: [CJK-Latin-spacing not working with raw text])

#issue("typst#2702")

=== #bbl(en: [Punctuation compression does not work with `#show`])

#issue("typst#5474")

=== #bbl(en: [CJK-Latin-spacing not working with inline equation], zh: [行内公式与中文之间没有自动空格])

#issue("typst#2703")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-space.html")

=== #bbl(zh: [连续标点会挤压在一起])
#workaround("https://typst-doc-cn.github.io/guide/FAQ/weird-punct.html")

== Baselines, line-height, etc. (N/A)

== Lists, counters, etc.

=== #bbl(en: [Too wide spacing between heading numbering and title in CJK], zh: [标题的编号后面的空格])

#issue("typst#5778")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/heading-numbering-space.html")

== Styling initials

= Page & book layout

== General page layout & progression

== Grids & tables

== Footnotes, endnotes, etc.

== Page headers, footers, etc.

== Forms & user interaction

= Bibliography

== Citing

=== #bbl(en: [Continuous numbering], zh: [参考文献条目中不连续页码显示错误（缺少“,”）])

#issue("hayagriva#189", note: [mentioned])

#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-page-delimiter.html")

=== #bbl(zh: [引用编号的数字高于括号])

#workaround("https://typst-doc-cn.github.io/guide/FAQ/cite-flying.html")

=== #bbl(zh: [引用参考文献时，如何共存上标和非上标形式])

#workaround("https://typst-doc-cn.github.io/guide/FAQ/ref-superscript.html")

== Bibliography listing

=== #bbl(en: [chinese et al.], zh: [修复英文参考文献中的“等”])

#issue("hayagriva#291")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html")

=== #bbl(en: [CJK sorting is based on unicode code points])

#issue("hayagriva#259")

=== #bbl(en: [`gb-7714-2015-note` show incorrectly])

#issue("hayagriva#189", note: [mentioned])

=== #bbl(
  en: [Some entries in thesis and report bibliography items are not shown],
  zh: [参考文献学位论文条目`[D]`后不显示“地点: 学校名称, 年份.”],
)

#issue("hayagriva#112")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-school.html")

== Bibliography file

=== #bbl(en: [All (`Misc`?) entries with URL are recognized as `webpage` (in `gb-7714-2015-numeric`?)])

#issue("hayagriva#312")

=== #bbl(zh: [指定参考文献 CSL 后，报错“failed to load CSL style”])

#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-csl.html")

= Other

== Culture-specific features

=== #bbl(en: [Proper i18n for figure captions], zh: [`第一章` vs.~`章一`])

#issue("typst#2485", note: [mentioned])

=== #bbl(zh: [figure 的 caption 如何实现双语])

#workaround("https://typst-doc-cn.github.io/guide/FAQ/dual_language_caption.html")

=== #bbl(en: [Section name should be after section number in reference in Chinese])

#issue("typst#5102")

== What else?

=== #bbl(
  en: [Ignore linebreaks between CJK characters in source code],
  zh: [写中文文档时，如何去掉源码中换行导致的空格],
)

#issue("typst#792")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-remove-space.html")
#workaround("https://typst.app/universe/package/cjk-unbreak")

=== #bbl(zh: [关闭 webapp 的拼写检查])

#workaround("https://typst-doc-cn.github.io/guide/FAQ/webapp-spellcheck.html")

#set heading(numbering: none)

= Addendum

== References

- #link("https://www.w3.org/TR/clreq/")[Requirements for Chinese Text Layout - 中文排版需求]
- #link("https://www.w3.org/TR/clreq-gap/")[Chinese Layout Gap Analysis]
- #link("https://typst-doc-cn.github.io/guide/FAQ.html")[FAQ 常见问题 | Typst Doc CN 中文社区导航]

== To be done

- Content

  - Illustrations / minimal examples
  - #link("https://www.w3.org/TR/clreq-gap/#prioritization")[Prioritization]
  - Links to available workarounds
  - Full Chinese/English translation
  - Include resolved issues (for historians)

- Live long

  - Documentation

    - Copy explanations of sections, if
      #link("https://www.w3.org/copyright/software-license-2023/")[the W3C license]
      permits
    - Contributing guide

  - Check duplication

  - GitHub

    - Check/display issue status
    - Watch
      #link("https://github.com/typst/typst/issues?q=%20is%3Aopen%20label%3Acjk%20sort%3Areactions-desc")[label: cjk · Issues · typst/typst]

== Umbrella/tracking issues

- Advanced East-Asian layout features #issue("typst#193")
- Better CJK support #issue("typst#276")
