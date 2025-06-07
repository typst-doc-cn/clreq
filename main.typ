#import "typ/util.typ": issue

#html.elem("h1")[
  #link("https://www.w3.org/TR/clreq/")[clreq]-#link("https://www.w3.org/TR/clreq-gap/")[gap] for typst
]

Chinese Layout Gap Analysis for Typst.

This document describes gaps for the support of the Chinese script within Typst, a markup-based typesetting software.
In particular, it is concerned with #link("https://www.w3.org/TR/clreq/")[text layout] and #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A")[bibliography].
It examines whether needed features are supported by the typst compiler, and provides information on potential workarounds.

#emoji.warning This document is only an early draft.
Additionally, it is not endorsed by either #link("https://www.w3.org/")[W3C] or #link("https://typst.app/home")[Typst GmBH].
Please refer to it with caution.

#set heading(numbering: "1.1")

= Text direction

== Writing mode

- RFC: Vertical Writing Mode #issue("typst#5908")

== Bidirectional text (N/A)

= Glyph shaping & positioning

== Fonts & font styles

=== Font selection

- Writing non-Latin (e.g.~Chinese) text without a configured font leads to unpredictable font fallback #issue("typst#5040")

- Wrong "monospace" font fallback for CJK characters in raw block #issue("typst#3385")

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-in-raw.html")[为什么代码块里面的中文字体显示不正常？ | Typst 中文社区导航]

- Language-dependant font configuration #issue("typst#794")

=== Font rendering

- Chinese rendering error #issue("typst#5900")
- Size per font #issue("typst#6295")
- Compiler not rendering Chinese/CJK fonts #issue("typst#6054")
- Support variable fonts #issue("typst#185")

== Context-based shaping and positioning (N/A)

== Cursive text (N/A)

== Letterform slopes, weights, & italics

- Fake text weight and style (synthesized bold and italic) #issue("typst#394")

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-bold.html")[中文没有加粗 | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-skew.html")[如何设置中文字体的斜体？ | Typst 中文社区导航]

== Case & other character transforms (N/A)

= Typographic units

== Characters & encoding

== Grapheme/word segmentation & selection

= Punctuation & inline features

== Phrase & section boundaries

== Quotations & citations

- Typst 0.13 `covers: "latin-in-cjk"` doesn’t cover apostrophes and quotation marks #issue("typst#5858")
- #link("https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html")[引号的字体不对 / 引号的宽度不对 | Typst 中文社区导航]

== Emphasis & highlighting

- Superscripts in underlined text makes the underline change size and position #issue("typst#1210")

  Underline breaks when mixing Chinese and English, mentioned in
  #issue("typst#1716", anchor: "#issuecomment-1855739446")

  #link("https://typst-doc-cn.github.io/guide/FAQ/underline-misplace.html")[中英文下划线错位了怎么办？ | Typst 中文社区导航]

== Abbreviation, ellipsis, & repetition

== Inline notes & annotations

- Add support for ruby (CJK, e.g., furigana for Japanese) #issue("typst#1489")
- warichu (mentioned in #issue("typst#193"))

== Text decoration & other inline features

== Data formats & numbers

= Line and paragraph layout

== Line breaking & hyphenation

== Text alignment & justification

- CJK-latin glues stretch only before latin characters #issue("typst#6062")

- Strict grid for CJK, hopefully via glue #issue("typst#4404")

- CJK brackets at the beginning of paragraph #issue("typst#4011")

- CJK punctuation at the start of paragraphs are not adjusted sometimes #issue("typst#2348")

- Paragraph should be able to contain tight lists and block-level equations #issue("typst#3206")

  #link("https://typst-doc-cn.github.io/guide/FAQ/block-equation-in-paragraph.html")[如何避免公式、图表等块元素的下一行缩进？ | Typst 中文社区导航]

- 均排 Even inter-character spacing

  #link("https://typst-doc-cn.github.io/guide/FAQ/character-intersperse.html")[如何让几个汉字占固定宽度并均匀分布？ | Typst 中文社区导航]

== Text spacing

- CJK-Latin-spacing not working with raw text #issue("typst#2702")

- Punctuation compression does not work with `#show` #issue("typst#5474")

- CJK-Latin-spacing not working with inline equation #issue("typst#2703")

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-space.html")[行内公式与中文之间没有自动空格 | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/weird-punct.html")[为什么连续标点会挤压在一起？ | Typst 中文社区导航]

== Baselines, line-height, etc. (N/A)

== Lists, counters, etc.

- Too wide spacing between heading numbering and title in CJK #issue("typst#5778")

  #link("https://typst-doc-cn.github.io/guide/FAQ/heading-numbering-space.html")[如何去掉标题的编号后面的空格？ | Typst 中文社区导航]

== Styling initials

= Page & book layout

== General page layout & progression

== Grids & tables

== Footnotes, endnotes, etc.

== Page headers, footers, etc.

== Forms & user interaction

= Bibliography

== Citing

- Continuous numbering, mentioned in
  #issue("hayagriva#189")

  #link("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-page-delimiter.html")[参考文献条目中不连续页码显示错误（缺少“,”） | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/cite-flying.html")[引用编号的数字高于括号 | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/ref-superscript.html")[引用参考文献时，如何共存上标和非上标形式？ | Typst 中文社区导航]

== Bibliography listing

- chinese et al. #issue("hayagriva#291")

  #link("https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html")[如何修复英文参考文献中的“等”？ | Typst 中文社区导航]

- CJK sorting is based on unicode code points #issue("hayagriva#259")

- `gb-7714-2015-note` show incorrectly, mentioned in #issue("hayagriva#189")

- Some entries in thesis and report bibliography items are not shown #issue("hayagriva#112")

  #link("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-school.html")[参考文献学位论文条目 `[D]` 后不显示“地点: 学校名称, 年份.” | Typst 中文社区导航]

== Bibliography file

- All (`Misc`?) entries with URL are recognized as `webpage` (in `gb-7714-2015-numeric`?) #issue("hayagriva#312")
- #link("https://typst-doc-cn.github.io/guide/FAQ/bib-csl.html")[为什么指定参考文献 CSL 后，报错“failed to load CSL style”？ | Typst 中文社区导航]

= Other

== Culture-specific features

- `第一章` vs.~`章一`, mentioned in
  Proper i18n for figure captions #issue("typst#2485")
- #link("https://typst-doc-cn.github.io/guide/FAQ/dual_language_caption.html")[figure 的 caption 如何实现双语？ | Typst 中文社区导航]
- Section name should be after section number in reference in Chinese #issue("typst#5102")

== What else?

- Ignore linebreaks between CJK characters in source code #issue("typst#792")

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-remove-space.html")[写中文文档时，如何去掉源码中换行导致的空格？ | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/webapp-spellcheck.html")[如何关闭 webapp 的拼写检查？ | Typst 中文社区导航]

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
