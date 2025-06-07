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


= Text direction

== Writing mode

- #link("https://github.com/typst/typst/issues/5908")[RFC: Vertical Writing Mode · Issue \#5908 · typst/typst]

== Bidirectional text (N/A)

= Glyph shaping & positioning

== Fonts & font styles

=== Font selection

- #link("https://github.com/typst/typst/issues/5040")[Writing non-Latin (e.g.~Chinese) text without a configured font leads to unpredictable font fallback · Issue \#5040 · typst/typst]

- #link("https://github.com/typst/typst/issues/3385")[Wrong "monospace" font fallback for CJK characters in raw block · Issue \#3385 · typst/typst]

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-in-raw.html")[为什么代码块里面的中文字体显示不正常？ | Typst 中文社区导航]

- #link("https://github.com/typst/typst/issues/794")[Language-dependant font configuration · Issue \#794 · typst/typst]

=== Font rendering

- #link("https://github.com/typst/typst/issues/5900")[Chinese rendering error · Issue \#5900 · typst/typst]
- #link("https://github.com/typst/typst/issues/6295")[Size per font · Issue \#6295 · typst/typst]
- #link("https://github.com/typst/typst/issues/6054")[Compiler not rendering Chinese/CJK fonts · Issue \#6054 · typst/typst]
- #link("https://github.com/typst/typst/issues/185")[Support variable fonts · Issue \#185 · typst/typst]

== Context-based shaping and positioning (N/A)

== Cursive text (N/A)

== Letterform slopes, weights, & italics

- #link("https://github.com/typst/typst/issues/394")[Fake text weight and style (synthesized bold and italic) · Issue \#394 · typst/typst]

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-bold.html")[中文没有加粗 | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-skew.html")[如何设置中文字体的斜体？ | Typst 中文社区导航]

== Case & other character transforms (N/A)

= Typographic units

== Characters & encoding

== Grapheme/word segmentation & selection

= Punctuation & inline features

== Phrase & section boundaries

== Quotations & citations

- #link("https://github.com/typst/typst/issues/5858")[Typst 0.13 `covers: "latin-in-cjk"` doesn’t cover apostrophes and quotation marks · Issue \#5858 · typst/typst]
- #link("https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html")[引号的字体不对 / 引号的宽度不对 | Typst 中文社区导航]

== Emphasis & highlighting

- #link("https://github.com/typst/typst/issues/1210")[Superscripts in underlined text makes the underline change size and position · Issue \#1210 · typst/typst]

  Underline breaks when mixing Chinese and English, mentioned in
  #link("https://github.com/typst/typst/issues/1716#issuecomment-1855739446")[\#1716]

  #link("https://typst-doc-cn.github.io/guide/FAQ/underline-misplace.html")[中英文下划线错位了怎么办？ | Typst 中文社区导航]

== Abbreviation, ellipsis, & repetition

== Inline notes & annotations

- #link("https://github.com/typst/typst/issues/1489")[Add support for ruby (CJK, e.g., furigana for Japanese) · Issue \#1489 · typst/typst]
- warichu (mentioned in \#193)

== Text decoration & other inline features

== Data formats & numbers

= Line and paragraph layout

== Line breaking & hyphenation

== Text alignment & justification

- #link("https://github.com/typst/typst/issues/6062")[CJK-latin glues stretch only before latin characters · Issue \#6062 · typst/typst]

- #link("https://github.com/typst/typst/issues/4404")[Strict grid for CJK, hopefully via glue · Issue \#4404 · typst/typst]

- #link("https://github.com/typst/typst/issues/4011")[CJK brackets at the beginning of paragraph · Issue \#4011 · typst/typst]

- #link("https://github.com/typst/typst/issues/2348")[CJK punctuation at the start of paragraphs are not adjusted sometimes · Issue \#2348 · typst/typst]

- #link("https://github.com/typst/typst/issues/3206")[Paragraph should be able to contain tight lists and block-level equations · Issue \#3206 · typst/typst]

  #link("https://typst-doc-cn.github.io/guide/FAQ/block-equation-in-paragraph.html")[如何避免公式、图表等块元素的下一行缩进？ | Typst 中文社区导航]

- 均排 Even inter-character spacing

  #link("https://typst-doc-cn.github.io/guide/FAQ/character-intersperse.html")[如何让几个汉字占固定宽度并均匀分布？ | Typst 中文社区导航]

== Text spacing

- #link("https://github.com/typst/typst/issues/2702")[CJK-Latin-spacing not working with raw text · Issue \#2702 · typst/typst]

- #link("https://github.com/typst/typst/issues/5474")[Punctuation compression does not work with `#show` · Issue \#5474 · typst/typst]

- #link("https://github.com/typst/typst/issues/2703")[CJK-Latin-spacing not working with inline equation · Issue \#2703 · typst/typst]

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-space.html")[行内公式与中文之间没有自动空格 | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/weird-punct.html")[为什么连续标点会挤压在一起？ | Typst 中文社区导航]

== Baselines, line-height, etc. (N/A)

== Lists, counters, etc.

- #link("https://github.com/typst/typst/issues/5778")[Too wide spacing between heading numbering and title in CJK · Issue \#5778 · typst/typst]

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
  #link("https://github.com/typst/hayagriva/issues/189")[hayagriva\#189]

  #link("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-page-delimiter.html")[参考文献条目中不连续页码显示错误（缺少“,”） | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/cite-flying.html")[引用编号的数字高于括号 | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/ref-superscript.html")[引用参考文献时，如何共存上标和非上标形式？ | Typst 中文社区导航]

== Bibliography listing

- #link("https://github.com/typst/hayagriva/issues/291")[chinese et al.~· Issue \#291 · typst/hayagriva]

  #link("https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html")[如何修复英文参考文献中的“等”？ | Typst 中文社区导航]

- #link("https://github.com/typst/hayagriva/issues/259")[CJK sorting is based on unicode code points · Issue \#259 · typst/hayagriva]

- `gb-7714-2015-note` show incorrectly, mentioned in
  #link("https://github.com/typst/hayagriva/issues/189")[hayagriva\#189]

- #link("https://github.com/typst/hayagriva/issues/112")[Some entries in thesis and report bibliography items are not shown · Issue \#112 · typst/hayagriva]

  #link("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-school.html")[参考文献学位论文条目 `[D]` 后不显示“地点: 学校名称, 年份.” | Typst 中文社区导航]

== Bibliography file

- #link("https://github.com/typst/hayagriva/issues/312")[All (`Misc`?) entries with URL are recognized as `webpage` (in `gb-7714-2015-numeric`?) · Issue \#312 · typst/hayagriva]
- #link("https://typst-doc-cn.github.io/guide/FAQ/bib-csl.html")[为什么指定参考文献 CSL 后，报错“failed to load CSL style”？ | Typst 中文社区导航]

= Other

== Culture-specific features

- `第一章` vs.~`章一`, mentioned in
  #link("https://github.com/typst/typst/issues/2485")[Proper i18n for figure captions · Issue \#2485 · typst/typst]
- #link("https://typst-doc-cn.github.io/guide/FAQ/dual_language_caption.html")[figure 的 caption 如何实现双语？ | Typst 中文社区导航]
- #link("https://github.com/typst/typst/issues/5102")[Section name should be after section number in reference in Chinese · Issue \#5102 · typst/typst]

== What else?

- #link("https://github.com/typst/typst/issues/792")[Ignore linebreaks between CJK characters in source code · Issue \#792 · typst/typst]

  #link("https://typst-doc-cn.github.io/guide/FAQ/chinese-remove-space.html")[写中文文档时，如何去掉源码中换行导致的空格？ | Typst 中文社区导航]

- #link("https://typst-doc-cn.github.io/guide/FAQ/webapp-spellcheck.html")[如何关闭 webapp 的拼写检查？ | Typst 中文社区导航]

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

- #link("https://github.com/typst/typst/issues/193")[Advanced East-Asian layout features · Issue \#193 · typst/typst]
- #link("https://github.com/typst/typst/issues/276")[Better CJK support · Issue \#276 · typst/typst]
