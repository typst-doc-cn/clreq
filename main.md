# (Draft) Chinese Layout Gap Analysis — Typst

## Text direction

### Writing mode

- [RFC: Vertical Writing Mode · Issue #5908 · typst/typst](https://github.com/typst/typst/issues/5908)

### Bidirectional text (N/A)

## Glyph shaping & positioning

### Fonts & font styles

#### Font selection

- [Writing non-Latin (e.g. Chinese) text without a configured font leads to unpredictable font fallback · Issue #5040 · typst/typst](https://github.com/typst/typst/issues/5040)

- [Wrong "monospace" font fallback for CJK characters in raw block · Issue #3385 · typst/typst](https://github.com/typst/typst/issues/3385)

  [为什么代码块里面的中文字体显示不正常？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/chinese-in-raw.html)

- [Language-dependant font configuration · Issue #794 · typst/typst](https://github.com/typst/typst/issues/794)

#### Font rendering

- [Chinese rendering error · Issue #5900 · typst/typst](https://github.com/typst/typst/issues/5900)
- [Size per font · Issue #6295 · typst/typst](https://github.com/typst/typst/issues/6295)
- [Compiler not rendering Chinese/CJK fonts · Issue #6054 · typst/typst](https://github.com/typst/typst/issues/6054)
- [Support variable fonts · Issue #185 · typst/typst](https://github.com/typst/typst/issues/185)

### Context-based shaping and positioning (N/A)

### Cursive text (N/A)

### Letterform slopes, weights, & italics

- [Fake text weight and style (synthesized bold and italic) · Issue #394 · typst/typst](https://github.com/typst/typst/issues/394)

  [中文没有加粗 | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/chinese-bold.html)

- [如何设置中文字体的斜体？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/chinese-skew.html)

### Case & other character transforms (N/A)

## Typographic units

### Characters & encoding

### Grapheme/word segmentation & selection

## Punctuation & inline features

### Phrase & section boundaries

### Quotations & citations

- [Typst 0.13 `covers: "latin-in-cjk"` doesn't cover apostrophes and quotation marks · Issue #5858 · typst/typst](https://github.com/typst/typst/issues/5858)
- [引号的字体不对 / 引号的宽度不对 | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html)

### Emphasis & highlighting

- [Superscripts in underlined text makes the underline change size and position · Issue #1210 · typst/typst](https://github.com/typst/typst/issues/1210)

  Underline breaks when mixing Chinese and English, mentioned in [#1716](https://github.com/typst/typst/issues/1716#issuecomment-1855739446)

  [中英文下划线错位了怎么办？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/underline-misplace.html)

### Abbreviation, ellipsis, & repetition

### Inline notes & annotations

- [Add support for ruby (CJK, e.g., furigana for Japanese) · Issue #1489 · typst/typst](https://github.com/typst/typst/issues/1489)
- warichu (mentioned in #193)

### Text decoration & other inline features

### Data formats & numbers

## Line and paragraph layout

### Line breaking & hyphenation

### Text alignment & justification

- [CJK-latin glues stretch only before latin characters · Issue #6062 · typst/typst](https://github.com/typst/typst/issues/6062)

- [Strict grid for CJK, hopefully via glue · Issue #4404 · typst/typst](https://github.com/typst/typst/issues/4404)

- [CJK brackets at the beginning of paragraph · Issue #4011 · typst/typst](https://github.com/typst/typst/issues/4011)

- [CJK punctuation at the start of paragraphs are not adjusted sometimes · Issue #2348 · typst/typst](https://github.com/typst/typst/issues/2348)

- [Paragraph should be able to contain tight lists and block-level equations · Issue #3206 · typst/typst](https://github.com/typst/typst/issues/3206)

  [如何避免公式、图表等块元素的下一行缩进？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/block-equation-in-paragraph.html)

- 均排 Even inter-character spacing

  [如何让几个汉字占固定宽度并均匀分布？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/character-intersperse.html)

### Text spacing

- [CJK-Latin-spacing not working with raw text · Issue #2702 · typst/typst](https://github.com/typst/typst/issues/2702)

- [Punctuation compression does not work with `#show` · Issue #5474 · typst/typst](https://github.com/typst/typst/issues/5474)

- [CJK-Latin-spacing not working with inline equation · Issue #2703 · typst/typst](https://github.com/typst/typst/issues/2703)

  [行内公式与中文之间没有自动空格 | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/chinese-space.html)

- [为什么连续标点会挤压在一起？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/weird-punct.html)

### Baselines, line-height, etc. (N/A)

### Lists, counters, etc.

- [Too wide spacing between heading numbering and title in CJK · Issue #5778 · typst/typst](https://github.com/typst/typst/issues/5778)

  [如何去掉标题的编号后面的空格？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/heading-numbering-space.html)

### Styling initials

## Page & book layout

### General page layout & progression

### Grids & tables

### Footnotes, endnotes, etc.

### Page headers, footers, etc.

### Forms & user interaction

## Bibliography

### Citing

- Continuous numbering, mentioned in [hayagriva#189](https://github.com/typst/hayagriva/issues/189)

  [参考文献条目中不连续页码显示错误（缺少“,”） | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/bib-missing-page-delimiter.html)

- [引用编号的数字高于括号 | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/cite-flying.html)

- [引用参考文献时，如何共存上标和非上标形式？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/ref-superscript.html)

### Bibliography listing

- [chinese et al. · Issue #291 · typst/hayagriva](https://github.com/typst/hayagriva/issues/291)

  [如何修复英文参考文献中的“等”？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html)

- [CJK sorting is based on unicode code points · Issue #259 · typst/hayagriva](https://github.com/typst/hayagriva/issues/259)

- `gb-7714-2015-note` show incorrectly, mentioned in [hayagriva#189](https://github.com/typst/hayagriva/issues/189)

- [Some entries in thesis and report bibliography items are not shown · Issue #112 · typst/hayagriva](https://github.com/typst/hayagriva/issues/112)

  [参考文献学位论文条目 `[D]` 后不显示“地点: 学校名称, 年份.” | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/bib-missing-school.html)

### Bibliography file

- [All (`Misc`?) entries with URL are recognized as `webpage` (in `gb-7714-2015-numeric`?) · Issue #312 · typst/hayagriva](https://github.com/typst/hayagriva/issues/312)
- [为什么指定参考文献 CSL 后，报错“failed to load CSL style”？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/bib-csl.html)

## Other

### Culture-specific features

- `第一章` vs. `章一`, mentioned in [Proper i18n for figure captions · Issue #2485 · typst/typst](https://github.com/typst/typst/issues/2485)
- [figure 的 caption 如何实现双语？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/dual_language_caption.html)
- [Section name should be after section number in reference in Chinese · Issue #5102 · typst/typst](https://github.com/typst/typst/issues/5102)

### What else?

- [Ignore linebreaks between CJK characters in source code · Issue #792 · typst/typst](https://github.com/typst/typst/issues/792)

  [写中文文档时，如何去掉源码中换行导致的空格？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/chinese-remove-space.html)

- [如何关闭 webapp 的拼写检查？ | Typst 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ/webapp-spellcheck.html)

## Addendum

### References

- [Requirements for Chinese Text Layout - 中文排版需求](https://www.w3.org/TR/clreq/)
- [Chinese Layout Gap Analysis](https://www.w3.org/TR/clreq-gap/)
- [FAQ 常见问题 | Typst Doc CN 中文社区导航](https://typst-doc-cn.github.io/guide/FAQ.html)

### To be done

- Content

  - Illustrations / minimal examples
  - [Prioritization](https://www.w3.org/TR/clreq-gap/#prioritization)
  - Links to available workarounds
  - Full Chinese/English translation
  - Include resolved issues (for historians)

- Live long

  - Documentation

    - Copy explanations of sections, if [the W3C license](https://www.w3.org/copyright/software-license-2023/) permits
    - Contributing guide

  - Check duplication
  - GitHub
    - Check/display issue status
    - Watch [label: cjk · Issues · typst/typst](https://github.com/typst/typst/issues?q=%20is%3Aopen%20label%3Acjk%20sort%3Areactions-desc)

### Umbrella/tracking issues

- [Advanced East-Asian layout features · Issue #193 · typst/typst](https://github.com/typst/typst/issues/193)
- [Better CJK support · Issue #276 · typst/typst](https://github.com/typst/typst/issues/276)
