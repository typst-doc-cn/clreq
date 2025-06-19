#import "typ/util.typ": babel, bbl, issue, workaround, prompt, unichar
#import "typ/prioritization.typ": level, level-table
#import "typ/show-example.typ": render-examples
#show: render-examples

#babel(en: [Chinese Layout Gap Analysis for Typst.], zh: [分析 Typst 与中文排版的差距。])

= #bbl(en: [Introduction], zh: [导语])

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
  en: [This document also attempts to prioritize the gaps in terms of the impact on Chinese end authors. The prioritization is indicated by colour, as shown in @fig:level-table.],
  zh: [根据对中文最终作者的影响程度，本文还尝试给这些差距排出优先顺序。优先级用颜色表示，如 @fig:level-table 所示。],
)

#figure(
  level-table,
  caption: bbl(en: [Priority levels], zh: [优先级]),
  kind: table,
) <fig:level-table>

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

#outline()

#set heading(numbering: "1.1")
#show heading.where(level: 3): set heading(numbering: none)

= #bbl(en: [Text direction], zh: [文本方向])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#direction")[
  #babel(
    en: [See also @page-layout for features such as column layout, page turning direction, etc. that are affected by text direction.],
    zh: [分栏布局、翻页方向等也受文本方向影响，这些请参阅@page-layout.],
  )
]

== #bbl(en: [Writing mode], zh: [行文模式])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#writing_mode")[
  #babel(
    en: [
      In what direction does text flow along a line and across a page? (If the basic direction is right-to-left see @bidi-text.) If the script uses vertically oriented text, what are the requirements? What about if you mix vertical text with scripts that are normally only horizontal? Do you need a switch to use different characters in vertical vs. horizontal text? Does typst support short runs of horizontal text in vertical lines (tate-chu-yoko in Japanese) as expected? Is the orientation of characters and the directional ordering of characters supported as needed?
    ],
    zh: [
      文本在行内和跨页时分别沿什么方向书写？（若基本方向就时从右到左，请移步@bidi-text）如果文段可能沿竖直方向排列（直排），有哪些要求？若直排文段中混入其它文字，而这种文字通常水平书写，又如何？是否需要开关以在直排、横排时使用不同字符？typst 能否正常在直排文本中将小段文本按横排插入（日文的“纵中横”）？字符的朝向及排列方向符合需求吗？
    ],
  )
]

=== #bbl(en: [Vertical Writing Mode], zh: [直排])

#level.advanced
#issue("typst#5908")

// Ref: https://www.w3.org/TR/clreq/#writing_modes_in_chinese_composition
#babel(
  en: [There are two writing modes in Chinese composition:],
  zh: [中文有两种行文模式：],
)

- #babel(
    en: [*Horizontal writing mode* is the mainstream mode in Chinese Mainland, and is also commonly used for books on natural science in Hong Kong, Macao, Taiwan.],
    zh: [*横排*是中国大陆的主流方法，港澳台的自然科学类书籍也常用横排。],
  )
- #babel(
    en: [*Vertical writing mode* is the traditional mode for Chinese publications, and still stands as an important cultural characteristic of regions where Traditional Chinese is used.],
    zh: [*直排*是中文书籍的传统方法，仍是繁体中文通行地区的重要文化标志。],
  )

#babel(
  en: [
    Compared with horizontal writing mode, vertical writing mode not only changes the direction of the text flow, but also adjusts the form, size, and position of punctuation marks (as shown in @fig:vertical-example-ancient and @fig:vertical-example-modern).
    Additionally, it requires adapting to mixed Chinese-Western text, captions of figures, multi-column layout, and more.
  ],
  zh: [
    与横排相比，直排除了更改行文方向，还会调整标点符号的形态、尺寸、位置（如 @fig:vertical-example-ancient、@fig:vertical-example-modern），此外还需适配中西混排、图表标题、分栏等。
  ],
)

#babel(
  en: [Considering that typst currently struggles even with basic vertical typesetting, we will not cover issues related to vertical writing mode in the following sections.],
  zh: [鉴于 typst 目前连基础直排也难以实现，下文各节将不再讨论直排相关的问题。],
)

#figure(
  image("/public/vertical-example-ancient.jpg", alt: "《永樂大典》The Yongle Encyclopedia"),
  caption: link(
    "https://commons.wikimedia.org/w/index.php?title=File:Shanghai_永樂大典卷之二千三百三十七.pdf&page=1",
    bbl(en: [An ancient example of vertical text], zh: [直排的古代例子]),
  ),
) <fig:vertical-example-ancient>

#figure(
  image(
    "/public/vertical-example-modern.jpg",
    alt: "Straight and wavy lines alongside vertical text 直排行间的专名号与书名号",
  ),
  caption: link(
    "https://github.com/w3c/type-samples/issues/56",
    bbl(en: [A modern example of vertical text], zh: [直排的现代例子]),
  ),
) <fig:vertical-example-modern>


== Bidirectional text <bidi-text>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#bidi_text")[
  If the general inline direction is right-to-left, are there any issues when handling that? Where the inline direction of text is mixed, is this bidirectional text adequately supported? What about numbers and expressions? Do the Unicode bidi controls and typst markup provide the support needed? Is isolation of directional runs problematic?
]

#level.na

= #bbl(en: [Glyph shaping & positioning], zh: [字形的变形与定位])

== #bbl(en: [Fonts selection], zh: [字体选择])

#prompt[
  #babel(
    en: [Do the standard fallback fonts used in typst match expectations? Is it convenient to select fonts?],
    zh: [typst 的标准回落字体符合预期吗？选择字体方便吗？],
  )
]

=== #bbl(
  en: [Writing Chinese without configuring any font leads to messy font fallback],
  zh: [若不配置字体就写中文，回落出的字体会很混乱],
)

#level.advanced
#issue("typst#5040")
#issue("typst#5900")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/install-fonts.html")

#babel(
  en: [
    The default main text font in typst does not include Chinese characters.
    Therefore, when compiling locally, if you write Chinese without configuring any font using `#set text(font: …)`, the fallback result may end up mixing fonts of different writing styles (as shown in @fig:font-fallback-messy), making the text hard to read.
    Moreover, there is no warning or hint.
  ],
  zh: [
    typst的正文默认字体不含汉字。因此本地编译时，若不用`#set text(font: …)`配置字体就写中文，回落结果可能混合不同风格的字体（如 @fig:font-fallback-messy），难以阅读，且无任何警告或提示。
  ],
)

#figure(
  image("/public/font-fallback-messy.png", alt: "“为什么字体这么奇怪”, literally “Why is the font so strange”"),
  caption: bbl(
    en: [The result might be a mixture of sans and serif fonts],
    zh: [结果可能混合了黑体和宋体],
  ),
) <fig:font-fallback-messy>

=== #bbl(
  en: [Wrong monospace font fallback for Chinese in raw block],
  zh: [代码块内汉字回落的等宽字体不正常],
)

#level.advanced
#issue("typst#3385")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-in-raw.html")

#babel(
  en: [This issue continues the above issue.],
  zh: [这一问题接续上一问题。],
)

#babel(
  en: [
    Apart from the main text, typst presets another font for `raw` code blocks, which does not include Chinese characters either.
    Currently, this setting takes precedence over the main text font you specified, forcing you to re-declare the Chinese font by `#show raw: set text(font: …)`.
  ],
  zh: [
    在正文之外，typst对`raw`代码块预设了另一字体，同样不含汉字。该设置目前优先于你指定的正文字体，导致必须用`#show raw: set text(font: …)`再次指定中文字体。
  ],
)

=== #bbl(en: [Language-dependant font configuration], zh: [按语言设置字体])

#level.basic
#issue("typst#794")

#babel(
  en: [For punctuation marks such as quotation marks (see @quotations), Chinese and Western scripts share the same Unicode code points, but require different glyph forms. Therefore, their fonts must be set respectively. ],
  zh: [对于引号（见 @quotations）等标点符号，中西文在Unicode中共用码位#issue("w3c/clreq#534")，但要求不同形态，故必须分开设置字体。],
)

```example
>>> Current: \
我说：“T'Pol 是‘虚构’人物！”

>>> Expected: \
>>> 我说：“#text(font: "New Computer Modern")[T'Pol] 是‘虚构’人物！”
```

== #bbl(en: [Font rendering & font styles], zh: [字体渲染与字体风格]) <font-render>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#fonts")[
  #babel(
    en: [
      How are fonts grouped into recognisable writing styles? How is each writing style used?
      Are special font or OpenType features needed for this script that are not available? What other general, font-related issues arise? The font styles described here refer to alternative types of writing style, such as naskh vs nastaliq; for oblique, italic, and weights see instead @letterforms.
    ],
    zh: [
      字体如何分类成可辨识的字体风格？如何使用各类字体风格？这种文字是否还需要尚不可用的特定字体或 OpenType 特性？
      还有哪些字体相关的一般问题？此处“字体风格”是指书写风格的不同变体，例如阿拉伯文中naskh与nastaliq；至于倾斜体（oblique）、意大利体（italic）以及各级字重，请移步@letterforms。
    ],
  )
]

=== #bbl(en: [Size per font], zh: [按字体设置字号])

#level.advanced
#issue("typst#6295")

#babel(
  en: [It is common to use different fonts for Chinese and Western characters, and the visual sizes of different fonts may need to be fine-tuned for alignment.],
  zh: [中西文经常采用不同字体，而不同字体的视觉大小可能需要微调对齐。],
)

```example
>>> Current: \
共10人

>>> Expected: \
>>> 共#text(1.1em)[10]人
```

=== #bbl(en: [Variable font], zh: [可变字体])

#level.advanced
#issue("typst#185")
#issue("typst#6054")
#workaround("https://github.com/typst/typst/discussions/2508")

#babel(
  en: [Variable fonts offer more creative possibilities and have higher storage efficiency. Given the vast number of Chinese characters, designing and storing traditional static fonts can be challenging — for example, a static Noto Sans CJK OTF/TTC is often \~100 MB. This makes variable fonts especially valuable for the Chinese language.],
  zh: [可变字体的创意可能性更多，并且存储效率更高。汉字数量庞大，设计、存储传统不可变字体都相对困难——例如不可变思源黑体一般有 \~100 MB，所以可变字体对中文有独特价值。],
)

```example
>>> Current: \
>>> #[
#set text(font: "Source Han Serif SC VF")
可变字体
>>> ]

>>> Expected: \
>>> 可变字体
```

== Context-based shaping and positioning

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#glyphs")[
  If context-sensitive rendering support is needed to shape combinations of letters or position certain glyphs relative to others, is this adequately provided for? Does the script in question require additional user control features to support alterations to the position or shape of glyphs, for example adjusting the distance between the base text and diacritics, or changing the glyphs used in a systematic way? Do you need to be able to compose/decompose conjuncts or ligatures, or show characters that are otherwise hidden, etc? If text is cursive, see the separate @cursive.
]

#level.na

== Cursive text <cursive>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#cursive")[
  // TODO: The apostrophe here uses the wrong font.
  If this script is cursive (ie. letters are generally joined up, like in Arabic, N’Ko, Syriac, etc), are there problems or needed features related to the handling of cursive text? Do cursive links break if parts of a word are marked up or styled? Do Unicode joiner and non-joiner characters behave as expected?
]

#level.na

== #bbl(en: [Letterform slopes, weights, & italics], zh: [字体斜度、字重、意大利体]) <letterforms>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#letterforms")[
  #babel(
    en: [
      This covers ways of modifying the glyphs for a range of text, such as for italicisation, bolding, oblique, etc. Are italicisation, bolding, oblique, etc relevant? Do italic fonts lean in the right direction? Is synthesised italicisation or oblique problematic? Are there other problems relating to bolding or italicisation - perhaps relating to generalised assumptions of applicability? For alternative writing/font styles, see @font-render.
    ],
    zh: [
      这节讨论针对一串文本的字形的修改方法，例如意大利体（italic）、粗体、倾斜体（oblique）等。是否有意大利体、粗体、倾斜体的概念？意大利体的倾斜方向正确吗？倾斜体（即伪意大利体）有问题吗？还有其它加粗、倾斜相关的问题吗——也许某些普遍假设并不适用？至于各类字体风格，请移步@font-render。
    ],
  )
]

=== #bbl(en: [Fake (synthesized) bold], zh: [伪粗体])

#level.basic
#issue("typst#394")
#workaround("https://typst.app/universe/package/cuti")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-bold.html")

#babel(
  en: [Classic Chinese fonts often have only one level of text weight. Therefore, fake bold is crucial in practice.],
  zh: [传统中文字体通常只有单级字重，所以伪粗体在实用中很关键。],
)

```example
>>> Current: \
>>> #[
#set text(font: "SimSun")
想做出*最好的*灯泡。
>>> ]

>>> Expected: \
>>> #set text(font: "SimSun")
>>> #import "@preview/cuti:0.3.0": show-cn-fakebold
>>> #show: show-cn-fakebold
>>> 想做出*最好的*灯泡。
```

== Case & other character transforms

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#transforms")[
  Does your script need special text transforms that are not supported? For example, do you need to to convert between half-width and full-width presentation forms? Does your script convert letters to uppercase, capitalised and lowercase alternatives according to your typographic needs? How about other transforms?
]

#level.na

= #bbl(en: [Typographic units], zh: [排版单元])

== #bbl(en: [Characters & encoding], zh: [字符与编码])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#encoding")[
  Most languages are now supported by Unicode, but there are still occasional issues. In particular, there may be issues related to ordering of characters, or competing encodings (as in Myanmar), or standardisation of variation selectors or the encoding model (as in Mongolian). Are there any character repertoire issues preventing use of this script in typst? Do variation selectors need attention? Are there any other encoding-related issues?
]

#level.tbd

== Grapheme/word segmentation & selection

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#segmentation")[
  This is about how text is divided into graphemes, words, sentences, etc., and behaviour associated with that. Are there special requirements for the following operations: forwards/backwards deletion, cursor movement & selection, character counts, searching & matching, text insertion, line-breaking, justification, case conversions, sorting? Are words separated by spaces, or other characters? Are there special requirements when double-clicking or triple-clicking on the text? Are words hyphenated? (Some of the answers to these questions may be picked up in other sections, such as @line-breaking, or @initials.)
]

#level.tbd

= #bbl(en: [Punctuation & inline features], zh: [标点符号及其它行内特性])

== #bbl(en: [Phrase & section boundaries], zh: [短语与章节边界])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#punctuation_etc")[
  #babel(
    en: [
      What characters are used to indicate the boundaries of phrases, sentences, and sections? What about other punctuation, such as dashes, connectors, separators, etc? Are there specific problems related to punctuation or the interaction of the text with punctuation (for example, punctuation that is separated from preceding text but must not be wrapped alone to the next line)? Are there problems related to bracketing information or demarcating things such as proper nouns, etc? Some of these topics have their own sections; see also @quotations, and @abbrev.
    ],
    zh: [
      表示短语、句子或段落的边界用什么字符？破折号、连接符、分隔符等其它标点符号呢？关于标点符号或，或者文字与标点符号相互作用，是否存在特定问题（例如某标点符号与前文分开，但不允许换至下一行）？专有名词等需要明确括住的信息，使用正常吗？其中部分话题有专门章节，参见@quotations、@abbrev。
    ],
  )
]

#level.tbd

== #bbl(en: [Quotations & citations], zh: [引文]) <quotations>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#quotations")[
  #babel(
    en: [
      This is a subtopic of phrase & section boundaries that is worth handling separately. What characters are used to indicate quotations? Do quotations within quotations use different characters? What characters are used to indicate dialogue? Are the same mechanisms used to cite words, or for scare quotes, etc? What about citing book or article names? Are there any issues when dealing with quotations marks, especially when nested? Should block quotes be indented or handled specially? Do quotation marks take text direction into account appropriately?
    ],
    zh: [
      有些短语或章节边界需要单独处理，本节讨论这方面话题。引语用什么字符标识？引文中的引文是否要用不同字符？对话用什么字符标识？引用单词（即 scare quotes）的方法相同吗？引用书籍或文章名标题呢？处理引号有无问题，特别是嵌套时？用于整段的引号需要缩进或特别处理吗？引号是否考虑了文本方向？
    ],
  )
]

=== #bbl(
  en: [Quotation marks should have different widths for Chinese and Western text],
  zh: [中西文引号的宽度应当不同],
)

#level.basic
#issue("typst#5858")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html")

#babel(
  en: [Both Chinese and Western quotation marks (and apostrophes) use the same Unicode code points:],
  zh: [中西文的引号（及撇号）都使用相同Unicode码位：],
)
#"‘’“”".clusters().map(unichar).map(list.item).join()
#babel(
  en: [But punctuation in Chinese is usually supposed to be wider than that in Western languages. This cannot be achieved automatically yet.],
  zh: [但中文的标点通常应该比西文的宽。当前这还无法自动实现。],
)

```example
>>> Current: \
我说：“T'Pol 是‘虚构’人物！”

>>> Expected: \
>>> 我说：“#text(font: "New Computer Modern")[T'Pol] 是‘虚构’人物！”
```

== #bbl(en: [Emphasis & highlighting], zh: [强调与突出显示])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#emphasis")[
  #babel(
    en: [
      How are emphasis and highlighting achieved? If lines or marks are drawn alongside, over or through the text, do they need to be a special distance from the text itself? Is it important to skip characters when underlining, etc? How do things change for vertically set text?
    ],
    zh: [
      如何强调或突出显示一串文本？若在文字旁边、文字上方上方或穿过文字划线或者做标记，是否需与文字保持特定距离？加下划线时是否需要跳过某些字符？直排时规则又如何？
    ],
  )
]

=== #bbl(en: [Underline breaks when mixing Chinese and Western text], zh: [中西文下划线错位])

#level.advanced
#issue("typst#1210")
#issue("typst#1716", anchor: "#issuecomment-1855739446")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/underline-misplace.html")

#babel(
  en: [
    Unlike the Latin alphabet, Chinese characters have no concept of ascenders and descenders. Therefore, underlines in Chinese should be drawn completely below the glyphs.
    Additionally, it is common to use different fonts for Chinese and Western characters, creating more difficulties in aligning the underline.
  ],
  zh: [与拉丁字母不同，汉字没有升降部的概念，所以中文的下划线应当完全在字符之下。此外，中西文常用不同字体，导致下划线更难对齐。],
)

```example
>>> Current: \
#underline[中文和English]

>>> Expected: \
>>> #set underline(offset: .15em, stroke: .05em)
>>> #underline[中文和English]
```

== #bbl(en: [Abbreviation, ellipsis, & repetition], zh: [缩写、省略与重复]) <abbrev>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#abbrev")[
  #babel(
    en: [
      What characters or other methods are used to indicate abbreviation, ellipsis & repetition? Are there problems?
    ],
    zh: [
      缩写、省略和重复用什么字符或方法表示？有问题吗？
    ],
  )
]

== #bbl(en: [Inline notes & annotations], zh: [行内注与行间注]) <inline-notes>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#inline_notes")[
  #babel(
    en: [
      What mechanisms, if any, are used to create *inline* notes and annotations? Are the appropriate methods for inline annotations supported for this script?
      Both Hanyu Pinyin (Romanization) and Bopomofo (Phonetic Symbols) are included.
      This section deals with inline annotation approaches. For annotation methods where a marker in the text points out to another part of the document, see @footnotes-etc.
    ],
    zh: [
      如果这种文字有*行内*注与行间注，分别采用什么机制？相关方法是否支持？汉语拼音、注音符号都算在内。本节关注行内注释；至于指向文档其它部分的注释，请参考@footnotes-etc。
    ],
  )
]

=== #bbl(en: [Add support for ruby (CJK, e.g., furigana for Japanese)], zh: [支持标注拼音])

#level.advanced
#issue("typst#1489")

=== #bbl(en: [warichu], zh: [割注])

#level.advanced
#issue("typst#193", note: [mentioned])

== #bbl(en: [Text decoration & other inline features], zh: [文本标示与其他行内特性])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#text_decoration")[
  This section is a catch-all for inline features that do not fit under the previous sections. It can also be used to describe in one place a set of general requirements related to inline features when those features appear in more than one of the sections above. It covers characters or methods (eg. text decoration) that are used to convey information about a range of text. Are all needed forms of highlighting or marking of text available, such as wavy underlining, numeric overbars, etc. If lines are drawn alongside, over or through the text, do they need to be a special distance from the text itself? Is it important to skip characters when underlining, etc? How do things change for vertically set text? Are there other punctuation marks that were not covered in preceding sections? Are lines correctly drawn relative to vertical text?
]

#level.tbd

== #bbl(en: [Data formats & numbers], zh: [数据格式与数字])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#data_formats")[
  Relevant here are formats related to number, currency, dates, personal names, addresses, and so forth. If the script has its own set of number digits, are there any issues in how they are used? Does the script or language use special format patterns that are problematic (eg. 12,34,000 in India)? What about date/time formats and selection - and are non-Gregorian calendars needed? Do percent signs and other symbols associated with number work correctly, and do numbers need special decorations, (like in Ethiopic or Syriac)? How about the management of personal names, addresses, etc. in typst: are there issues?
]

#level.tbd

= #bbl(en: [Line and paragraph layout], zh: [行与段落版式])

== #bbl(en: [Line breaking & hyphenation], zh: [换行与断词连字]) <line-breaking>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#line_breaking")[
  Does typst capture the rules about the way text in your script wraps when it hits the end of a line? Does line-breaking wrap whole _words_ at a time, or characters, or something else (such as syllables in Tibetan and Javanese)? What characters should not appear at the end or start of a line, and what should be done to prevent that? Is hyphenation used for your script, or something else? If hyphenation is used, does it work as expected? (Note, this is about line-end hyphenation when text is wrapped, rather than use of the hyphen and related characters as punctuation marks.)
]

#level.ok

== #bbl(en: [Text alignment & justification], zh: [文本对齐]) <justification>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#justification")[
  #babel(
    en: [
      When text in a paragraph needs to have flush lines down both sides, does it follow the rules for your script? Does the script need assistance to conform to a grid pattern? Does your script allow punctuation to hang outside the text box at the start or end of a line? Where adjustments are need to make a line flush, how is that done? Do you shrink/stretch space between words and/or letters? Are word baselines stretched, as in Arabic? What about paragraph indents, or the need for logical alignment keywords, such as start/end, rather than left/right? Does the script indent the first line of a paragraph?
    ],
    zh: [
      若一段内的文字需要两端对齐，结果是否符合这种文字的习惯？文字是否需要辅助才能符合网格模式？这种文字允许标点符号在一行头尾悬挂到文本框以外吗？需要对齐某条线时，应当如何操作？正常会伸缩词间距、字间距吗？是否会像阿拉伯文那样拉伸文字基线？段落缩进如何，而逻辑对齐关键字（例如`start`/`end`而非`left`/`right`）又如何？这种文字是否缩进段落首行？
    ],
  )
]

=== #bbl(en: [CJK-latin glues stretch only before latin characters], zh: [中西间距只在拉丁字母之前拉伸])

#level.advanced
#issue("typst#6062")

```example
>>> Current:
#set par(justify: true)
#block(width: 3em)[第1回成段]

>>> Expected:
>>>
>>> #block(width: 3em)[第 1 回成段]
```

=== #bbl(en: [Strict grid aligned in both horizontal and vertical axes], zh: [严格纵横对齐的网格])

#level.advanced
#issue("typst#4404")

```example
>>> #set text(top-edge: "ascender", bottom-edge: "descender")
>>> Current:
#set par(justify: true)
#block(width: 7.5em)[
  天生我材必有用千金散尽还复来烹羊宰牛且为乐会须一饮三百杯
]

>>> Expected:
>>> #set par(justify: false)
>>> #set text(tracking: 0.5em / 6)
>>> #block(width: 7.5em)[
>>>   天生我材必有用#h(-0.5em / 6)千金散尽还复来#h(-0.5em / 6)烹羊宰牛且为乐#h(-0.5em / 6)会须一饮三百杯
>>> ]
```

=== #bbl(en: [Brackets at the beginning of paragraph], zh: [段首的方括号])

#level.tbd
#issue("typst#4011")

=== #bbl(
  en: [Parenthetical indication punctuation marks at the start of paragraphs are not adjusted sometimes],
  zh: [段首的夹注符号有时不会调整间距],
)

#level.advanced
#issue("typst#2348")

```example
>>> #show: block.with(width: 8em)
>>> Current:
>>>
#set par(justify: true)
《新生》的出版之期接近了……

#set par(first-line-indent: 2em)
《新生》的出版之期接近了……

>>> #set par(first-line-indent: 0em)
>>> Expected:
>>>
>>> 《新生》的出版之期接近了……
>>>
>>> #h(1.5em)《新生》#h(-0.5em)的出版之期接近了……
```

=== #bbl(
  en: [Paragraph should be able to contain tight lists and block-level equations],
  zh: [如何避免公式、图表等块元素的下一行缩进],
)

#level.basic
#issue("typst#3206")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/block-equation-in-paragraph.html")

#babel(
  en: [Chinese publications usually apply 2-em wide first-line indents.],
  zh: [中文出版品上，段首缩排以两个汉字的空间为标准。],
)

```example
>>> #show: block.with(width: 10em)
>>> Current:
#set par(first-line-indent: (amount: 2em, all: true))

段首起始该缩进
$ integral f dif x $
此处应当仍在段内，不该缩进。

>>> #set par(first-line-indent: 0em)
>>> Expected:
>>>
>>> #h(2em)段首起始该缩进
>>> $ integral f dif x $
>>> 此处应当仍在段内，不该缩进。
```

=== #bbl(en: [Even inter-character spacing], zh: [均排])

#level.advanced
#workaround("https://typst-doc-cn.github.io/guide/FAQ/character-intersperse.html")
#workaround("https://typst.app/universe/package/tricorder")

#babel(
  en: [Even inter-character spacing means letting several Chinese characters to occupy a fixed width and be evenly distributed.],
  zh: [均排是指让几个汉字占固定宽度并均匀分布。],
)

```example
>>> Current:
>>>
丁声树 黎锦熙 \
李荣 陆志韦

>>> Expected:
>>> #import "@preview/tricorder:0.1.0": tricorder
>>> #tricorder(
>>>   columns: 2,
>>>   .."丁声树、黎锦熙、李荣、陆志韦".split("、"),
>>> )
```

== #bbl(en: [Text spacing], zh: [文本的间距调整])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#spacing")[
  #babel(
    en: [
      This section is concerned with spacing that is adjusted around and between characters on a line in ways other than attempts to fit text to a given width (ie. justification). Some scripts create emphasis or other effects by spacing out the words, letters or syllables in a word. Are there requirements for this script/language that are unsupported? If spacing needs to be applied between letters and numbers, is that possible? What about space associated with punctuation, such as the gap before a colon in French? (For justification related spacing, see @justification.)
    ],
    zh: [
      本节关注要使文本适应指定长度（对齐）时，如何在字符之间和字符周围添加空隙。有些文字通过空出单词、字母、音阶来表达强调等效果。能否满足这种语言文字的需求？若需在字母、数字间加空，能否做到？像法文冒号前间距那种标点符号相关的空隙呢？（关于对齐相关的间距，请见@justification。）
    ],
  )
]

=== #bbl(en: [CJK-Latin-spacing not working around `raw`], zh: [`raw`两边缺少中西间距])

#level.advanced
#issue("typst#2702")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-space.html")

```example
>>> Current: \
汉字`(code)`汉字

>>> Expected: \
>>> 汉字#h(0.25em)`(code)`#h(0.25em)汉字
```

=== #bbl(en: [CJK-Latin-spacing not working around inline equations], zh: [行内公式两边缺少中西间距])

#level.advanced
#issue("typst#2703")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-space.html")

```example
>>> Current: \
汉字$A$汉字

>>> Expected: \
>>> 汉字#h(0.25em)$A$#h(0.25em)汉字
```

=== #bbl(en: [Punctuation compression is interrupted by `#show`], zh: [`#show`会打断标点挤压])

#level.basic
#issue("typst#5474")

```example
>>> Current:
>>>
噫）。嘘）．唏

>>> #[
#show "。": "．"
噫）。嘘）．唏
>>> ]

>>> Expected:
>>>
>>> 噫）。嘘）．唏
>>>
>>> 噫）．嘘）．唏
```

// === #bbl(zh: [连续标点会挤压在一起])
// #workaround("https://typst-doc-cn.github.io/guide/FAQ/weird-punct.html")
// This issue has not been reproduced yet.

== #bbl(en: [Baselines, line-height, etc.], zh: [基线、行高等])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#baselines")[
  #babel(
    en: [
      Does typst support requirements for baseline alignment between mixed scripts and in general? Are there issues related to line height or inter-line spacing, etc.? Are the requirements for baseline or line height in vertical text covered?
    ],
    zh: [
      typst能否对齐多文种的基线？行高、行距等方面有无问题？直排时的基线、行高能否满足要求？
    ],
  )
]

=== #bbl(en: [Default line height is too tight for Chinese], zh: [默认行高对中文来说过小])

#level.basic
#workaround("https://typst-doc-cn.github.io/guide/FAQ/par-leading.html#typst-设置")

#babel(
  en: [
    Unlike the Latin alphabet, Chinese characters have no concept of ascenders and descenders.
    So even though the numerical values of the leading are the same, the visual spacing of Chinese is smaller than that of Western text.
  ],
  zh: [
    与拉丁字母不同，汉字没有升降部的概念。所以尽管行距的数值相同，中文的视觉效果会比西文紧。
  ],
)

```example
>>> #set box(fill: aqua.lighten(50%))
>>> Current: \
>>> // Default: cap-height to baseline.
<<<Typst 国王 \
<<<Typst 国王
>>> #box[Typst 国王] \
>>> #box[Typst 国王]

>>> Expected: \
>>> #set text(top-edge: "ascender", bottom-edge: "descender")
>>> #box[Typst 国王] \
>>> #box[Typst 国王]
```

== #bbl(en: [Lists, counters, etc.], zh: [列表、编号等])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#lists")[
  #babel(
    en: [
      Are there list or other counter styles in use? If so, what is the format used and can that be achieved? Are the correct separators available for use after list counters? Are there other aspects related to counters and lists that need to be addressed? Are list counters handled correctly in vertical text?
    ],
    zh: [
      是否使用列表或其它编号样式？若是，使用什么格式，能否实现？列表编号后的分隔符是否正确？编号、列表的其它方面还有要解决的吗？直排时列表编号是否正常？
    ],
  )
]

=== #bbl(
  en: [List and enum markers are not aligned with the baseline of the item's contents],
  zh: [`list`和`enum`的编号与内容未对齐基线],
)

#level.basic
#issue("typst#1204")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/enum-list-marker-fix.html")

#babel(
  en: [This issue occurs when the marker and the content have different heights. It is common in mixed Chinese-Western text layouts to use different fonts for Chinese and Western characters. As a result, the height of Western (numeric) markers is likely to differ from that of the Chinese content, triggering the issue. ],
  zh: [这一问题的触发条件是编号和内容的高度不同。而中西混排场景中，中西文经常采用不同字体，导致西文（数字）编号与中文内容很可能不一样高，从而触发问题。],
)

```example
#set text(font: (
  (name: "New Computer Modern", covers: "latin-in-cjk"),
  "SimSun",
))
>>>

>>> Current:
>>>
+ 鲁镇的酒店的格局，是和别处不同的。

>>>#parbreak()
>>> Expected:
>>>
>>> #[1.] 鲁镇的酒店的格局，是和别处不同的。
>>>
>>> Analysis: Their cap heights differs.
>>>
>>> #set box(fill: aqua)
>>> #box[1.]
>>> #box[鲁镇]
```

=== #bbl(en: [Too wide spacing between heading numbering and title], zh: [标题编号与内容之间的空隙过宽])

#level.basic
#issue("typst#5778")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/heading-numbering-space.html")

#babel(
  en: [In Chinese, the chapter number and its title are typically separated by the secondary comma #unichar("、"). Unlike the dot `.` used in formats like `1. Title`, no extra space should follow the `、` in examples such as `一、标题`. However, typst puts a hard-coded 0.3-em space here.],
  zh: [中文通常习惯用顿号 #unichar("、") 分隔章号和标题。与`1. Title`这种格式中的`.`不同，`一、标题`中的`、`后不应再插入空格。然而 typst 在这里硬编码插入了宽 0.3 em 的空格。],
)

```example-page
>>> #show heading: pad.with(top: -0.75em)
>>> Current:
#set heading(numbering: "一、")
= 标题

>>> Expected:
>>> #set heading(numbering: none)
>>> = 一、标题
```

== Styling initials <initials>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#initials")[
  Does typst correctly handle special styling of the initial letter of a line or paragraph, such as for drop caps or similar? How about the size relationship between the large letter and the lines alongide? where does the large letter anchor relative to the lines alongside? is it normal to include initial quote marks in the large letter? is the large letter really a syllable? etc. Are all of these things working as expected?
]

#level.tbd

= #bbl(en: [Page & book layout], zh: [页面与书籍版式])

== #bbl(en: [General page layout & progression], zh: [基本页面版式与装订方向]) <page-layout>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#page_layout")[
  How are the main text area and ancilliary areas positioned and defined? Are there any special requirements here, such as dimensions in characters for the Japanese kihon hanmen? The book cover for scripts that are read right-to-left scripts is on the right of the spine, rather than the left. Is that provided for? When content can flow vertically and to the left or right, how do you specify the location of objects, text, etc. relative to the flow? For example, keywords `left` and `right` are likely to need to be reversed for pages written in English and page written in Arabic. Do tables and grid layouts work as expected? How do columns work in vertical text? Can you mix block of vertical and horizontal text correctly? Does text scroll in the expected direction? Other topics that belong here include any local requirements for things such as printer marks, tables of contents and indexes. See also @grids-tables.
]

#level.tbd

== #bbl(en: [Grids & tables], zh: [网格与表格]) <grids-tables>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#grids_tables")[
  As a subtopic of page layout, does the script have special requirements for character grids or for tables?
]

#level.tbd

== #bbl(en: [Footnotes, endnotes, etc.], zh: [脚注、尾注等]) <footnotes-etc>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#footnotes_etc")[
  Does your script have special requirements for footnotes, endnotes or other necessary annotations of this kind in the way needed for your culture? (See @inline-notes for purely inline annotations, such as ruby or warichu. This section is more about annotation systems that separate the reference marks and the content of the notes.)
]

#level.tbd

== #bbl(en: [Page headers, footers, etc.], zh: [页眉、页脚等])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#headers_footers")[
  Are there special conventions for page numbering, or the way that running headers and the like are handled?
]

#level.tbd

== #bbl(en: [Forms & user interaction], zh: [表单和用户交互])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#interaction")[
  Are vertical form controls well supported? In right-to-left scripts, is it possible to set the base direction for a form field? Is the scroll bar on the correct side? etc. Are there other aspects related to user interaction that need to be addressed?
]

#level.tbd

= #bbl(en: [Bibliography], zh: [参考文献管理])

#prompt[
  #babel(
    en: [
      Is there any difficulty in complying with the Chinese national standard #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A")[GB/T 7714—2015 _Information and documentation—Rules for bibliographic references and citations to information resources_] (#link("https://lib.tsinghua.edu.cn/wj/GBT7714-2015.pdf")[PDF])?
    ],
    zh: [
      遵守中国国家标准 #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A")[GB/T 7714—2015《信息与文献　参考文献著录规则》]（#link("https://lib.tsinghua.edu.cn/wj/GBT7714-2015.pdf")[PDF]）有无困难？
    ],
  )
]

#babel(
  en: [GB/T 7714—2015 specifies the following three citation styles. Each style uses a dedicated citing format in the main text, and the bibliography list at the end also arranges differently. However, the rules on recording each individual work are identical.],
  zh: [GB/T 7714—2015 规定了以下三种标注方法。各方法采用不同的正文引注样式，末尾参考文献表的排布方式也不尽相同；不过，每项文献的著录规则完全相同。],
)

- numeric 顺序编码
- author-date 著者-出版年
- note 注释/脚注

#babel(
  en: [The first style is the most widely used. The following sections will refer to this method unless otherwise specified.],
  zh: [第一种方法应用最广。下文默认指这种方法。],
)

== #bbl(en: [Citing], zh: [参考文献引注])

#prompt[
  #babel(
    en: [Is it possible to cite a work in the main text using `cite`? Does the result meet expectations?],
    zh: [能否用`cite`在正文中标注参考文献？结果符合预期吗？],
  )
]

=== #bbl(en: [Citation numbers are flying over their brackets], zh: [引用编号的数字高于括号])

#level.basic
#workaround("https://typst-doc-cn.github.io/guide/FAQ/cite-flying.html")

#babel(
  en: [The style `gb-7714-2015-numeric` formats a citation with a number enclosed in square brackets (e.g., `[1]`) and render them in superscript. However, some fonts only provide dedicated superscript glyphs for numbers, not for brackets. This can cause misalignment, with the numbers appearing higher than the brackets in the superscript.],
  zh: [`gb-7714-2015-numeric`样式会用括号包裹引用编号（例：`[1]`）并上标。不过有些字体只给数字提供了专用上标版本，而括号未提供。这导致上标时未对齐，数字显得比括号高。],
)

````example-page
>>> Current: \
#set text(font: "Noto Serif CJK SC")
孔乙己@key\上大人

>>> #show cite: set super(typographic: false)
>>> Expected: \
>>> 孔乙己@key\上大人
>>> #show bibliography: none
#let bib = ```bib
@misc{key,
  title = {Title},
}
```.text
#bibliography(bytes(bib), style: "gb-7714-2015-numeric")
````

=== #bbl(en: [Compression of continuous citation numbers], zh: [压缩连续的引用编号])

#level.basic
#issue("hayagriva#189", note: [mentioned])

#babel(
  en: [Compression should start from two citations., but the current threshold is three.],
  zh: [压缩应从两篇文献开始，而目前是从三篇开始。],
)

````example-page
>>> Current: \
两篇@a @b \
三篇@a @b @c

>>> Expected: \
>>> 两篇#super[[1--2]] \
>>> 三篇@a @b @c
>>> #show bibliography: none
#let bib = (
  "abc".clusters().map(n => "@misc{[n], title = {Title}}".replace("[n]", n)).sum()
)
#bibliography(bytes(bib), style: "gb-7714-2015-numeric")
````

=== #bbl(en: [Superscript and non-superscript forms should coexist], zh: [共存上标和非上标形式])

#level.broken
#workaround("https://typst-doc-cn.github.io/guide/FAQ/ref-superscript.html")

#babel(
  en: [Bothe the superscript and non-superscript forms are needed in practice.],
  zh: [实际中，上标、非上标两种引用形式都需要。],
)

````example-page
>>> Expected: \
<<< 孔乙己@key，另见文献~#parencite(<key>)。
>>> 孔乙己#super[[1]]，另见文献#h(0.25em)#[[1]]。
````

== #bbl(en: [Bibliography listing], zh: [参考文献表])

#prompt[
  #babel(
    en: [Can `bibliography` generate a bibliography / reference listing at the end of the article or the page? Does each entry have all parts? Does the citation format meet the standard?],
    zh: [用`bibliography`能否在文末或页脚正常生成参考文献表？著录项目完整吗？著录格式符合标准吗？],
  )
]

=== #bbl(en: [Use `et al.` for English and `等` for Chinese], zh: [英文用`et al.`，中文用`等`])

#level.broken
#issue("citationberg#5")
#issue("hayagriva#291")
#issue("nju-lug/modern-nju-thesis#3")
#issue("csimide/SEU-Typst-Template#1")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html")
#workaround("https://typst.app/universe/package/modern-nju-thesis")

#babel(
  en: [It is extremely common to cite both Chinese and English works in an article. For multi-author literature, some authors may be omitted. In such cases, we should use `et al.` for English and `等` for Chinese.],
  zh: [一篇文章同时引用中英文献极其常见。多著者文献可能省略部分作者，这时英文应加`et al.`，中文应加`等`。],
)

```example-bib
@article{吴伟仁2017,
  title = {“嫦娥4号”月球背面软着陆任务设计},
  author = {{吴伟仁} and {王琼} and {唐玉华} and {于国斌} and {刘继忠} and {张玮} and {宁远明} and {卢亮亮}},
  date = {2017-01},
  journaltitle = {深空探测学报},
  volume = {4},
  number = {2},
  pages = {111--117},
  doi = {10.15982/j.issn.2095-7777.2017.02.002},
  langid = {chinese}
}
% 吴伟仁, 王琼, 唐玉华, 等.“嫦娥4号”月球背面软着陆任务设计[J/OL]. 深空探测学报, 2017, 4(2): 111-117. DOI:10.15982/j.issn.2095-7777.2017.02.002.
@article{su2025,
  title = {South {{Pole}}–{{Aitken}} Massive Impact 4.25 Billion Years Ago Revealed by {{Chang}}'e-6 Samples},
  author = {Su, Bin and Chen, Yi and Wang, Zeling and Zhang, Di and Chen, Haojie and Gou, Sheng and Yue, Zongyu and Liu, Yanhong and Yuan, Jiangyan and Tang, Guoqiang and Guo, Shun and Li, Qiuli and Lin, Yang-Ting and Li, Xian-Hua and Wu, Fu-Yuan},
  date = {2025-03-20},
  journaltitle = {National Science Review},
  shortjournal = {Natl. Sci. Rev.},
  pages = {nwaf103},
  issn = {2095-5138},
  doi = {10.1093/nsr/nwaf103},
  langid = {english},
}
% SU B, CHEN Y, WANG Z, et al. South Pole–Aitken Massive Impact 4.25 Billion Years Ago Revealed by #text(font: "New Computer Modern")[Chang’e-6] Samples[J/OL]. National Science Review, 2025: nwaf103. DOI:10.1093/nsr/nwaf103.
```

=== #bbl(
  en: [Some entries in thesis and report bibliography items are not shown],
  zh: [参考文献学位论文条目`[D]`后不显示“地点: 学校名称, 年份.”],
)

#level.broken
#issue("hayagriva#112")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-school.html")

```example-bib
@thesis{王楠2016,
  title = {在“共产主义视镜”下想象科学 ——“十七年”期间的中国科幻文学与科学话语},
  author = {王楠},
  date = {2016-08-05},
  institution = {新加坡国立大学},
  location = {新加坡},
  url = {https://scholarbank.nus.edu.sg/handle/10635/132143},
  urldate = {2025-02-15},
  langid = {chinese}
}
% 王楠. 在“共产主义视镜”下想象科学 ——“十七年”期间的中国科幻文学与科学话语[D/OL]. 新加坡: 新加坡国立大学, 2016[2025-02-15]. https://scholarbank.nus.edu.sg/handle/10635/132143.
```

=== #bbl(
  en: [Discontinuous page numbers are displayed incorrectly, missing a comma],
  zh: [不连续页码显示错误，缺少逗号],
)

#level.basic
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-page-delimiter.html")

```example-bib
@phdthesis{alterego,
  type = {{超高校级学位论文}},
  title = {{基于图书室的笔记本电脑的 Alter Ego 系统}},
  author = {不二咲, 千尋},
  year = {2010},
  address = {某地},
  school = {私立希望ヶ峰学園},
  publisher = {私立希望ヶ峰学園},
  pages = {1--3, 5},
}
% 不二咲千尋. 基于图书室的笔记本电脑的 Alter Ego 系统[D]. 某地: 私立希望ヶ峰学園, 2010: 1–3, 5.
```

=== #bbl(
  en: [Chinese works should be ordered by the pinyin or strokes of the authors for `gb-7714-2015-author-date`],
  zh: [采用`gb-7714-2015-author-date`时，中文文献应按著者汉语拼音字顺或笔画笔顺排列],
)

#level.advanced
#issue("hayagriva#259")

#babel(
  en: [The style `gb-7714-2015-author-date` currently sorts works by Unicode code points. However, according to the standard, when using this style, the cited works should first be grouped by scripts, then arranged by author names and publication dates. For Chinese works, they may be ordered by either pinyin or strokes.],
  zh: [目前`gb-7714-2015-author-date`样式按Unicode码位排序。而标准规定，采用这种样式时，各篇文献首先按文种集中，然后按著者字顺和出版年排列，其中中文文献可按著者汉语拼音字顺或笔画笔顺排列。],
)

=== #bbl(en: [`gb-7714-2015-note` is totally broken], zh: [`gb-7714-2015-note`完全无法使用])

#level.advanced
#issue("hayagriva#189", note: [mentioned])

- #bbl(
    en: [The references need only be listed in the footnotes, and should not be repeated at the end of the article.],
    zh: [文献只需在脚注列出，无需在文末重复。],
  )

- #bbl(
    en: [If the same work is cited multiple times, then its footnote should be repeated in most cases.],
    zh: [若一篇文献被重复引用，则大多数情况下，相应脚注也应重复。],
  )

````example-page
>>> = Current
孔乙己@key \
上大人@key

#let bib = ```bib
@misc{key,
  author = {Author},
  title = {Title},
  date = {2025-06-17},
}
```.text
#bibliography(bytes(bib), style: "gb-7714-2015-note")
````

```example-page
>>> = Expected
>>> 孔乙己#footnote[AUTHOR. Title[Z]. 2025.] \
>>> 上大人#footnote[AUTHOR. Title[Z]. 2025.]
```

== #bbl(en: [Bibliography file], zh: [参考文献文件])

#prompt[
  #babel(
    en: [Are there difficulties creating files related to bibliography? Including the database of reference entires (Hayagriva `*.yml`, BibTeX `*.bib`) and the #link("https://docs.citationstyles.org/en/stable/specification.html")[Citation Style Language] style `*.csl`.],
    zh: [准备参考文献相关的文件是否存在困难？包括参考文件数据库（Hayagriva `*.yml`、BibTeX `*.bib`）和 #link("https://docs.citationstyles.org/en/stable/specification.html")[Citation Style Language] 样式 `*.csl`。],
  )
]

=== #bbl(en: [`@standard` is not correctly interpreted], zh: [`@standard`被错误解释])

#level.basic
#issue("hayagriva#312")

#babel(
  en: [`@standard` is the `[S]` type in GB/T 7714—2015. It is #link("https://docs.citationstyles.org/en/stable/specification.html#appendix-iii-types")[a regular type in CSL], and a non-standard type in BibTeX (but accepted by biber). However, typst interprets it as `@misc` (`[Z]`) or `@webpage` (`[EB]`).],
  zh: [`@standard`是 GB/T 7714—2015 里的`[S]`类型文献。它#link("https://docs.citationstyles.org/en/stable/specification.html#appendix-iii-types")[在 CSL 中是个正常类型]，不过并非 BibTeX 的标准类型（但 biber 支持）。然而 typst 将它解释为`@misc`（`[Z]`）或`@webpage`（`[EB]`）。],
)

```example-bib
@standard{DASH,
  title = {Information Technology — {{Dynamic}} Adaptive Streaming over {{HTTP}} ({{DASH}}) — {{Part}} 1: {{Media}} Presentation Description and Segment Formats},
  author = {{ISO/IEC}},
  date = {2022-08},
  number = {ISO/IEC 23009-1:2022(E)},
  publisher = {International Organization for Standardization},
  url = {https://www.iso.org/standard/83314.html},
  pubstate = {Published},
  version = {5},
}
% ISO/IEC. Information Technology — Dynamic Adaptive Streaming over HTTP (DASH) — Part 1: Media Presentation Description and Segment Formats[S/OL]. International Organization for Standardization, 2022. https://www.iso.org/standard/83314.html. Published.
```

=== #bbl(en: [Failed to load some CSL styles], zh: [无法加载某些 CSL 样式])

#level.advanced
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-csl.html")

#babel(
  en: [The compiler does not support the CSL-M standard yet, nor is it compatible with some extensions of citeproc-js.],
  zh: [编译器暂不支持 CSL-M 标准，也不兼容 citeproc-js 的一些扩展。],
)

= #bbl(en: [Other], zh: [杂项])

== #bbl(en: [Culture-specific features], zh: [文化独有特性])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#culturespecific")[
  #babel(
    en: [
      Sometimes a script or language does things that are not common outside of its sphere of influence. This is a loose bag of additional items that were not previously mentioned. This section may also be relevant for observations related to locale formats (such as number, date, currency, format support).
    ],
    zh: [
      有时语言文字会其有特殊做法。本节兜底补充，覆盖上文未提及的特殊情况。本节也可讨论本地化格式（如数字、日期、货币）的支持情况。
    ],
  )
]

=== #bbl(en: [Proper i18n for figure captions], zh: [`第一章` vs.~`章一`])

#level.tbd
#issue("typst#2485", note: [mentioned])

=== #bbl(en: [Bilingual figure captions], zh: [figure 的 caption 如何实现双语])

#level.tbd
#workaround("https://typst-doc-cn.github.io/guide/FAQ/dual_language_caption.html")

=== #bbl(en: [Section name should be after section number in reference in Chinese])

#level.tbd
#issue("typst#5102")

== #bbl(en: [What else?], zh: [其它])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#other")[
  There are many other modules and specifications which may need review for script-specific requirements. What else is likely to cause problems for worldwide usage of typst, and what requirements need to be addressed to make typst function well locally?
]

=== #bbl(
  en: [Ignore linebreaks between CJK characters in source code],
  zh: [写中文文档时，如何去掉源码中换行导致的空格],
)

#level.advanced
#issue("typst#792")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-remove-space.html")
#workaround("https://typst.app/universe/package/cjk-unbreak")

=== #bbl(en: [Disable the spell checker of webapp], zh: [关闭 webapp 的拼写检查])

#level.advanced
#workaround("https://typst-doc-cn.github.io/guide/FAQ/webapp-spellcheck.html")

#babel(
  en: [The spell checker embedded in the webapp does not support Chinese, marking all lines as misspelled.],
  zh: [webapp 内嵌的拼写检查器不支持中文，每一行都会被标为拼写错误。],
)

#set heading(numbering: none)

= #bbl(en: [Addendum], zh: [附录])

== #bbl(en: [Environment of the examples], zh: [例子的环境信息])

- #bbl(en: [Update date], zh: [更新日期]) \
  #datetime.today().display()

- #bbl(en: [Compiler], zh: [编译器]) \
  typst v#sys.version

#if "github" in sys.inputs {
  let github = json(bytes(sys.inputs.github))
  [
    - #bbl(en: [Document version], zh: [文档版本]) \
      commit #link(github.commit_url, github.name) (#link(github.run_url)[log])
  ]
}

- #bbl(en: [Default fonts], zh: [默认字体]) \
  New Computer Modern, Noto Serif CJK SC

== #bbl(en: [References], zh: [参考资料])

- W3C documents

  - #link("https://www.w3.org/TR/clreq/")[Requirements for Chinese Text Layout - 中文排版需求]
  - #link("https://www.w3.org/TR/clreq-gap/")[Chinese Layout Gap Analysis]

- #link("https://typst-doc-cn.github.io/guide/FAQ.html")[FAQ 常见问题 | Typst Doc CN 中文社区导航]

- Standards

  - #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A")[GB/T 7714—2015《信息与文献　参考文献著录规则》_Information and documentation—Rules for bibliographic references and citations to information resources_] (#link("https://lib.tsinghua.edu.cn/wj/GBT7714-2015.pdf")[PDF])
  - #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D7FE25D3A7E05397BE0A0AB82A")[GB/T 15834—2011《标点符号用法》_General rules for punctuation_] (#link("http://www.moe.gov.cn/jyb_sjzl/ziliao/A19/201001/W020190128580990138234.pdf")[PDF])
  - #link("https://std.samr.gov.cn/hb/search/stdHBDetailed?id=8B1827F23645BB19E05397BE0A0AB44A")[CY/T 154—2017《中文出版物夹用英文的编辑规范》_Rules for editing Chinese publications interpolated with English_] (#link("https://www.nppa.gov.cn/xxgk/fdzdgknr/hybz/202210/P020221004608768453140.pdf")[PDF])

- Reference implementations

  - #link("https://ctan.org/pkg/biblatex-gb7714-2015")[`biblatex-gb7714-2015`], #bbl(zh: [符合 GB/T 7714—2015 标准的 biblatex 参考文献样式], en: [A BibLaTeX implementation of the GB/T 7714—2015 bibliography style for Chinese users]) (#link("https://texdoc.org/serve/biblatex-gb7714-2015/0")[TeXdoc PDF])

== To be done

- Content

  - Illustrations / minimal examples
  - Full Chinese/English translation
  - Include resolved issues (for historians)

- Live long

  - Documentation

    - Contributing guide

  - GitHub

    - Check/display issue status
    - Watch
      #link("https://github.com/typst/typst/issues?q=%20is%3Aopen%20label%3Acjk%20sort%3Areactions-desc")[label: cjk · Issues · typst/typst]

== Umbrella/tracking issues

- Advanced East-Asian layout features #issue("typst#193")
- Better CJK support #issue("typst#276")
