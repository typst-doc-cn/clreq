#import "typ/templates/html-fix.typ": latin-apostrophe
#import "typ/packages/till-next.typ": mark-till-next, till-next
#import "typ/util.typ": babel, bbl, issue, note, now-fixed, prompt, pull, unichar, workaround
#import "typ/prioritization.typ": level, level-table
#import "typ/show-example.typ": layout-git-log, render-examples
#show: render-examples

/// URL to the source repository and branch of this document
#let repo-blob = "https://github.com/typst-doc-cn/clreq/blob/main"

#babel(en: [Chinese Layout Gap Analysis for Typst.], zh: [分析 Typst 与中文排版的差距。])

= #bbl(en: [Introduction], zh: [导语])

#{
  import "@preview/cmarker:0.1.6": render

  let include-intro(path) = {
    let lines = read(path).split(regex("\r?\n"))
    let start = lines.position(l => l.trim() == `<!-- <included #intro by="main.typ"> -->`.text) + 1
    let end = lines.position(l => l.trim() == "<!-- </included> -->")

    render(lines.slice(start, end).join("\n"))
  }

  babel(en: include-intro("README.en.md"), zh: include-intro("README.md"))
}

#babel(
  en: [This document also attempts to prioritize the gaps in terms of the impact on Chinese end authors. The prioritization is indicated by colour, as shown in @tab-level-table.],
  zh: [根据对中文最终作者的影响程度，本文还尝试给这些差距排出优先顺序。优先级用颜色表示，如 @tab-level-table 所示。],
)

#figure(
  bbl(en: level-table(lang: "en"), zh: level-table(lang: "zh")),
  caption: bbl(en: [Priority levels], zh: [优先级]),
  kind: table,
) <tab-level-table>

#babel(
  en: [
    #emoji.warning This document is only an early draft.
    Additionally, it is not endorsed by either #link("https://www.w3.org/")[W3C] or #link("https://typst.app/home")[Typst GmbH].
    Please refer to it with caution and #link(repo-blob + "/README.en.md")[give feedback at any time].
  ],
  zh: [
    #emoji.warning 这份文档仅是早期草稿。此外，本文并无 #link("https://www.w3.org/")[W3C] 或 #link("https://typst.app/home")[Typst GmbH] 背书。请谨慎参考，#link(repo-blob + "/README.md")[随时反馈]。
  ],
)

= #bbl(en: [Summary], zh: [概要])

#import "typ/respec.typ": summary
#summary

#outline()

#set heading(numbering: "1.1")
#show heading.where(level: 3): set heading(numbering: none)
#show: mark-till-next

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
#pull("typst#7399", rejected: true)

// Ref: https://www.w3.org/TR/clreq/#writing_modes_in_chinese_composition
#babel(en: [There are two writing modes in Chinese composition:], zh: [中文有两种行文模式：])

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
    Compared with horizontal writing mode, vertical writing mode not only changes the direction of the text flow, but also adjusts the form, size, and position of punctuation marks (as shown in @fig-vertical-example-ancient and @fig-vertical-example-modern).
    Additionally, it requires adapting to mixed Chinese-Western text, captions of figures, multi-column layout, and more.
  ],
  zh: [
    与横排相比，直排除了更改行文方向，还会调整标点符号的形态、尺寸、位置（如 @fig-vertical-example-ancient、@fig-vertical-example-modern），此外还需适配中西混排、图表标题、分栏等。
  ],
)

#babel(
  en: [Considering that typst currently struggles even with basic vertical typesetting, we will not cover issues related to vertical writing mode in the following sections.],
  zh: [鉴于 typst 目前连基础直排也难以实现，下文各节将不再讨论直排相关的问题。],
)

#figure(image("/public/vertical-example-ancient.jpg", alt: "《永樂大典》The Yongle Encyclopedia"), caption: link(
  "https://commons.wikimedia.org/w/index.php?title=File:Shanghai_永樂大典卷之二千三百三十七.pdf&page=1",
  bbl(en: [An ancient example of vertical text], zh: [直排的古代例子]),
)) <fig-vertical-example-ancient>

#figure(
  image(
    "/public/vertical-example-modern.jpg",
    alt: "Straight and wavy lines alongside vertical text 直排行间的专名号与书名号",
  ),
  caption: link("https://github.com/w3c/type-samples/issues/56", bbl(
    en: [A modern example of vertical text],
    zh: [直排的现代例子],
  )),
) <fig-vertical-example-modern>


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
#issue("webapp-issues#590", closed: true)
#workaround("https://typst-doc-cn.github.io/guide/FAQ/install-fonts.html")

#babel(
  en: [
    The default main text font in typst does not include Chinese characters.
    Therefore, when compiling locally, if you write Chinese without configuring any font using `#set text(font: …)`, the fallback result may end up mixing fonts of different writing styles (as shown in @fig-font-fallback-messy), making the text hard to read.
    Moreover, there is no warning or hint.
  ],
  zh: [
    typst 的正文默认字体不含汉字。因此本地编译时，若不用`#set text(font: …)`配置字体就写中文，回落结果可能混合不同风格的字体（如 @fig-font-fallback-messy），难以阅读，且无任何警告或提示。
  ],
)

#figure(
  image("/public/font-fallback-messy.png", alt: "“为什么字体这么奇怪”, literally “Why is the font so strange”"),
  caption: bbl(en: [The result might be a mixture of sans and serif fonts], zh: [结果可能混合了黑体和宋体]),
) <fig-font-fallback-messy>

=== #bbl(en: [Wrong monospace font fallback for Chinese in raw block], zh: [代码块内汉字回落的等宽字体不正常])

#level.advanced
#issue("typst#3385")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-in-raw.html")

#babel(en: [This issue continues the above issue.], zh: [这一问题接续上一问题。])

#babel(
  en: [
    Apart from the main text, typst presets another font for `raw` code blocks, which does not include Chinese characters either.
    Currently, this setting takes precedence over the main text font you specified, forcing you to re-declare the Chinese font by `#show raw: set text(font: …)`.
  ],
  zh: [
    在正文之外，typst 对`raw`代码块预设了另一字体，同样不含汉字。该设置目前优先于你指定的正文字体，导致必须用`#show raw: set text(font: …)`再次指定中文字体。
  ],
)

```example
>>> Current: \
正文汉字 vs. `let foo = "汉字"`

>>> Expected: \
>>> #show raw: set text(font: (
>>>   (name: "DejaVu Sans Mono", covers: "latin-in-cjk"),
>>>   "Noto Serif CJK SC",
>>> ))
>>> 正文汉字 vs. `let foo = "汉字"`
```

=== #bbl(en: [Wrong font fallback for Chinese in math equations], zh: [数学公式中汉字回落的字体不正常])

#level.advanced
#issue("typst#366")
#issue("typst#6737")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/equation-chinese-font.html")

#babel(
  en: [This is a variant of the above issue in `math.equation`.],
  zh: [这是以上问题在`math.equation`数学公式的变体。],
)

```example
>>> Current: \
因此，
$ f(x) = y "（定义8）" $

>>> Expected: \
>>> #show math.equation: set text(font: (
>>>   (name: "New Computer Modern Math", covers: "latin-in-cjk"),
>>>   (name: "Noto Serif CJK SC", covers: regex(".")),
>>>   "New Computer Modern Math",
>>> ))
>>> 因此，
>>> $ f(x) = y "（定义8）" $
```

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

#babel(
  en: [The current typst will render them as the lightest weight when exporting SVG, and turn them into tofus when exporting PDF or PNG.],
  zh: [目前 typst 导出 SVG 会渲染成最细字重，导出 PDF、PNG 会变成豆腐块。],
)

```example-page
>>> Current: \
>>> #[
#set text(font: "Source Han Serif SC VF")
可变字体
>>> ]

>>> Expected: \
>>> 可变字体
```
// This example would emit a warning: variable fonts are not currently supported and may render incorrectly.
// To avoid receiving the message repeatedly when running `pnpm dev`, we use `example-page` instead of `example`.

=== #bbl(
  en: [Unable to infer the writing script across elements, making `locl` sometimes ineffective],
  zh: [无法跨越元素推断文字种类，导致`locl`特性有时失效],
)

#level.basic
#issue("typst#7396")

#babel(
  en: [
    Typographical rules may have regional differences. For example, when writing Chinese horizontally, #unichar("。") is placed at the _lower left_ corner in the square space in Chinese Mainland, but placed at the _center_ in Taiwan and Hong Kong.
    Some fonts handle these differences with the #link("https://learn.microsoft.com/typography/opentype/spec/features_ko#tag-locl")[OpenType `locl` (Localized Forms) feature], which requires the text to be properly tagged with both the language system and the writing script.
    However, typst does not infer the script across elements, making `locl` sometimes ineffective.
  ],
  zh: [
    排版规则可能存在地区差异。例如横排中文时，中国大陆把 #unichar("。") 放在字面的左下角，而港台则放在中央。有些字体使用 #link("https://learn.microsoft.com/typography/opentype/spec/features_ko#tag-locl")[OpenType 特性`locl` (Localized Forms)] 处理这种差异，而这要求文本同时正确标注了语言和文字。然而，typst 不会跨元素推断文字种类，导致`locl`特性有时失效。
  ],
)

#babel(
  en: [
    In the example below, typst infers the script of the first `。` from its surrounding Han texts, and uses the correct localized glyph. However, typst fails to do so for the second `。`, whose both sides are `ref` elements, and uses the wrong default glyph.
  ],
  zh: [
    在下例中，typst 从相邻汉字推断出了第一个`。`的文字种类，选用了正确的本地化字形；可是未能应对夹在两个`ref`元素中间的第二个`。`，选用了错误的默认字形。
  ],
)

```example-page
#set text(lang: "zh", region: "TW", font: "Noto Serif CJK SC")
#set heading(numbering: "1")
<<< #hide[= 何故 <a>]
>>> #place(hide[= 何故 <a>])

>>> Current: \
句號。@a。@a

>>> Expected: \
>>> 句號。小節 1。小節 1
```

== Context-based shaping and positioning

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#glyphs")[
  If context-sensitive rendering support is needed to shape combinations of letters or position certain glyphs relative to others, is this adequately provided for? Does the script in question require additional user control features to support alterations to the position or shape of glyphs, for example adjusting the distance between the base text and diacritics, or changing the glyphs used in a systematic way? Do you need to be able to compose/decompose conjuncts or ligatures, or show characters that are otherwise hidden, etc? If text is cursive, see the separate @cursive.
]

#level.na

== Cursive text <cursive>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#cursive")[
  #show: latin-apostrophe
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
  #babel(
    en: [Most languages are now supported by Unicode, but there are still occasional issues. In particular, there may be issues related to ordering of characters, or competing encodings (as in Myanmar), or standardisation of variation selectors or the encoding model (as in Mongolian). Are there any character repertoire issues preventing use of this script in typst? Do variation selectors need attention? Are there any other encoding-related issues?],
    zh: [Unicode 已支持大部分语言，但仍有零星问题。特别是在字符排序、编码竞争（如缅甸文）、变体选择器及编码模型标准化（如蒙文）等方面。这种文字是否因字符集支持问题而难以使用 typst？变体选择器需要特别关注吗？还有其他编码相关的问题吗？],
  )
]

=== #bbl(en: [Ideographic variation sequence disappears at end of line], zh: [行末的表意文字异体字序列无效])

#level.advanced
#issue("typst#5319")
#issue("typst#5785", closed: true) // duplicate but cleaner

#babel(
  en: [#link("https://www.unicode.org/ivd/")[Ideographic Variation Sequence (IVS)] is a mechanism for plain text #link("https://www.unicode.org/versions/Unicode16.0.0/core-spec/chapter-23/#G19053")[specified by Unicode] to change the glyph to be used to display a character. For more information, please refer to #link("https://unicode.org/faq/vs.html")[the FAQ on Unicode.org].],
  zh: [#link("https://www.unicode.org/ivd/")[表意文字异体字序列（ideographic variation sequence, IVS）]是 #link("https://www.unicode.org/versions/Unicode16.0.0/core-spec/chapter-23/#G19053")[Unicode 定义]的一种纯文本机制，可以更换某个字符显示用的异体字字形。更多信息请参考 #link("https://unicode.org/faq/vs.html")[Unicode.org 上的常见问题]。],
)

#babel(
  en: [This issue is marked as advanced, because IVS is rarely used and can be replaced by settings such as `#set text(lang: …, region: …)`.],
  zh: [这一问题算作 Advanced，因为 IVS 很少用，并且可用`#set text(lang: …, region: …)`等设置替代。],
)

=== #bbl(
  en: [Links containing non ASCII characters are wrong when viewing PDF in Safari],
  zh: [链接若包含非 ASCII 字符，用 Safari 查看 PDF 时会错],
)

#level.basic
#issue("typst#6128")
#workaround("https://typst.app/universe/package/percencode")
#workaround("https://typst.app/universe/package/lure")

#babel(
  en: [In the typst document, if the URL of a link uses Chinese characters rather than escape sequences, then it will be wrong when viewing PDF in Safari. The UTF-8 encoded bytes are decoded as Latin-1.],
  zh: [在 typst 文档中设置链接的 URL 时，若不加转义，直接用汉字，那么用 Safari 查看 PDF 时会错。UTF-8 编码的字节被按 Latin-1 解码。],
)

```example-page
<<< #link("https://w3c.github.io/clreq/home#discussions-讨论-討論")[Discussions 讨论 討論]

>>> #import "@preview/percencode:0.1.0": percent-decode, url-encode
>>> #set page(width: 26em)
>>> #show raw: set text(font: (
>>>   (name: "DejaVu Sans Mono", covers: "latin-in-cjk"),
>>>   "Noto Serif CJK SC",
>>> ))
>>> #let pretty-repr(it) = raw(repr(it), lang: "typc")
>>>
>>> Current in Safari: \
>>> #let hash = "#discussions-%C3%A8%C2%AE%C2%A8%C3%A8%C2%AE%C2%BA-%C3%A8%C2%A8%C2%8E%C3%A8%C2%AB%C2%96"
>>> #raw(hash) \
>>> (decoded: #pretty-repr(percent-decode(hash)))
>>>
>>> Expected: \
>>> #let hash = "#discussions-讨论-討論"
>>> #raw(url-encode(hash)) \
>>> (decoded: #pretty-repr(hash))
```

== Grapheme/word segmentation & selection

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#segmentation")[
  This is about how text is divided into graphemes, words, sentences, etc., and behaviour associated with that. Are there special requirements for the following operations: forwards/backwards deletion, cursor movement & selection, character counts, searching & matching, text insertion, line-breaking, justification, case conversions, sorting? Are words separated by spaces, or other characters? Are there special requirements when double-clicking or triple-clicking on the text? Are words hyphenated? (Some of the answers to these questions may be picked up in other sections, such as @line-breaking, or @initials.)
]

#level.ok

= #bbl(en: [Punctuation & inline features], zh: [标点符号及其它行内特性])

== #bbl(en: [Phrase & section boundaries], zh: [短语与章节边界])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#punctuation_etc")[
  #babel(
    en: [
      What characters are used to indicate the boundaries of phrases, sentences, and sections? What about other punctuation, such as dashes, connectors, separators, etc? Are there specific problems related to punctuation or the interaction of the text with punctuation (for example, punctuation that is separated from preceding text but must not be wrapped alone to the next line)? Are there problems related to bracketing information or demarcating things such as proper nouns, etc? Some of these topics have their own sections; see also @quotations, and @abbrev.
    ],
    zh: [
      表示短语、句子或段落的边界用什么字符？破折号、连接符、分隔符等其它标点符号呢？关于标点符号或者文字与标点符号相互作用，是否存在特定问题（例如某标点符号与前文分开，但不允许换至下一行）？专有名词等需要明确括住的信息，使用正常吗？其中部分话题有专门章节，参见@quotations、@abbrev。
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

#note(
  summary: bbl(en: [Note: The input method of quotation marks], zh: [注：引号的输入方法]),
  {
    babel(
      en: [Chinese characters are not directly mapped to keys on the keyboards because there are too many of them. Instead, people press a sequence of keys on an ordinary QWERTY keyboard, and let IME (Input Methods Editors, a software built into the computer) convert them into one or more Chinese characters. Please refer to #link("https://unicode.org/faq/font_keyboard.html#Inputting_Chinese")[FAQ about inputting Chinese characters on Unicode.org] for more details.],
      zh: [汉字非常多，所以不会直接映射到键盘上。人们会在普通 QWERTY 键盘上按几个键，让输入法（input methods editors, IME，电脑内置的软件）转换成一个或一串汉字。细节请参考 #link("https://unicode.org/faq/font_keyboard.html#Inputting_Chinese")[Unicode.org 上关于输入汉字的常见问题]。],
    )

    babel(
      en: [Thanks to IME, in Chinese writing, it is easy and typical to input opening and closing quotation marks (`‘’“”` listed above), while people hardly input straight ASCII quotes (`'"`) and convert automatically using the #link("https://typst.app/docs/reference/text/smartquote/")[`smartquote`] feature. #workaround("https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html") relies on this distinction from Western writing.],
      zh: [由于输入法，写中文时很容易输入配对的引号（以上列出的`‘’“”`），通常也这样输入。人们很少输入 ASCII 直引号（`'"`）再利用#link("https://typst.app/docs/reference/text/smartquote/")[`smartquote`]自动转换。#workaround("https://typst-doc-cn.github.io/guide/FAQ/smartquote-font.html") 依赖这种中西差异。],
    )
  },
)

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
  #babel(
    en: [
      Relevant here are formats related to number, currency, dates, personal names, addresses, and so forth. If the script has its own set of number digits, are there any issues in how they are used? Does the script or language use special format patterns that are problematic (eg. 12,34,000 in India)? What about date/time formats and selection - and are non-Gregorian calendars needed? Do percent signs and other symbols associated with number work correctly, and do numbers need special decorations, (like in Ethiopic or Syriac)? How about the management of personal names, addresses, etc. in typst: are there issues?],
    zh: [本节讨论数字、货币、日期、人名、地址等的格式。这种文字如果自有一套数码，使用是否有问题？这种文字或语言如果会用特殊模式的格式（例如印度的 12,34,000），它是否还有问题？是否会用公历以外的历法，时间及日期的格式和选择方式又如何？百分号等与数字一同使用的符号是否正常？数字是否需要特别装饰（如埃塞俄比亚文、叙利亚文）？在管理人名、地址等方面，typst 是否还有问题？],
  )
]

=== #bbl(en: [Numbers in Simplified Chinese], zh: [简体中文数字])

#level.ok

```example
>>> Current & Expected:
>>>
#numbering("一", 299792458)

#numbering("壹", 299792458)
```

#babel(
  en: [Natively supported. Mentioned here to prevent future people from reimplementing it.],
  zh: [内置支持。为避免又有人不知道而重复开发，提及一下。],
)

=== #bbl(en: [Numbers in Traditional Chinese], zh: [繁体中文数字])

#level.advanced
#issue("typst#6484")
#workaround("https://typst.app/universe/package/conjak")

#babel(
  en: [The characters used for numbers are not identical between traditional and simplified Chinese, but there is no mechanism to distinguish them yet.],
  zh: [繁简中文数字所用字符不完全一致，但尚无机制区分。],
)

```example
>>> Current: \
#set text(lang: "zh", region: "TW")
#numbering("壹", 2 * calc.pow(10, 8))

>>> Expected: \
>>> 貳億
```

#babel(
  en: [The expected output may vary with regions and personal preferences. For example, `#numbering("壹", 3)` can be written in multiple ways such as #"叁參叄".clusters().map(unichar).intersperse(", ").join().],
  zh: [具体期望结果可能还有地区变体和个人偏好变体，例如`#numbering("壹", 3)`会有 #"叁參叄".clusters().map(unichar).intersperse("、").join() 多种写法。],
)

= #bbl(en: [Line and paragraph layout], zh: [行与段落版式])

== #bbl(en: [Line breaking & hyphenation], zh: [换行与断词连字]) <line-breaking>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#line_breaking")[
  #babel(
    en: [
      Does typst capture the rules about the way text in your script wraps when it hits the end of a line? Does line-breaking wrap whole _words_ at a time, or characters, or something else (such as syllables in Tibetan and Javanese)? What characters should not appear at the end or start of a line, and what should be done to prevent that? Is hyphenation used for your script, or something else? If hyphenation is used, does it work as expected? (Note, this is about line-end hyphenation when text is wrapped, rather than use of the hyphen and related characters as punctuation marks.)
    ],
    zh: [
      typst 是否遵循这种文字在行末的换行规则？换行按整词换行，还是按字符或其它单元（例如藏文与爪哇文的音节）？哪些字符禁止出现在一行首尾，又有哪些规避方法？这种文字是否使用断词连字或类似机制？若使用断字，其结果正常吗？（注：此处指在文本换行处用连字符标记断字，而非把连字符相关字符当作标点使用。）
    ],
  )
]

=== #bbl(en: [Interpuncts should not appear at line start], zh: [间隔号不能出现在行首])

#level.advanced
#issue("typst#6774")

#babel(
  en: [According to #link("https://www.w3.org/TR/clreq/#prohibition_rules_for_line_start_end")[prohibition rules for line start and line end] (basic), #unichar("·") should not appear at the line start.],
  zh: [按照#link("https://www.w3.org/TR/clreq/#prohibition_rules_for_line_start_end")[行首行尾禁则]（基本处理），#unichar("·") 不能出现在一行的开头。],
)

```example
>>> Current: \
#show: block.with(width: 7em)
噫，克里斯蒂娜·罗塞蒂，还有阿加莎·克里斯蒂！

>>> Expected: \
>>> #show "·": it => box(width: 0.5em, align(center + horizon, text(bottom-edge: "baseline", it)))
>>> 噫，#h(-0.5em)克里斯蒂娜·罗塞蒂，还有阿加莎·克里斯蒂！
```
// This example is agnostic to the region — regardless of whether the base width is 1em or 0.5em, it should be adjusted to 0.5em here.

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

```example-page
>>> #import "/typ/examples/justification.typ": cell, example
>>> #example(
>>>   headers: (
>>>     [*Current* \ `#set par(justify: false)`],
>>>     [*Current & Expected* \ `#set par(justify: true)`],
>>>     [*Expected* \ (full-width `“”`)],
>>>   ),
>>>   pages: (
>>>     {
>>>       set par(justify: false)
>>>       [“十四五”前四年我国能耗强度累计降低11.6%；2025年黄河调水调沙今天启动。]
>>>     },
>>>     {
>>>       set par(justify: true)
>>>       [“十四五”前四年我国能耗强度累计降低11.6%；2025年黄河调水调沙今天启动。]
>>>     },
>>>     {
>>>       cell(align: end)[“]
>>>       [十四五]
>>>       cell(align: start)[”]
>>>       [前四年我国能耗强度累计降低]
>>>       cell(width: 3em, align: end)[11.6%]
>>>       [；]
>>>       cell(width: 2em)[2025]
>>>       [年黄河调水调沙今天启动。]
>>>     },
>>>   ),
>>> )
```

#babel(
  en: [As the above example, the frame grid is the conventional typesetting mechanism in Chinese. It is difficult to strictly implement the mechanism in current typst. People usually `#set par(justify: true)` to achieve similar results. However, this workaround can lead to several issues in this section.],
  zh: [如上例，中文习惯按稿纸网格排版。这目前在 typst 中难以严格实现，通常变通设置`#set par(justify: true)`。然而这权宜之计触发了本节若干问题。],
)

#note(
  summary: bbl(en: [Note: Why two expected results?], zh: [注：为何有两种期望结果？]),
  babel(
    en: [In the above example, the middle version resembles traditional typesetting, and the right version is close to the ordinary output of non-professional desktop publishing softwares. Most people find the left version hard to read, whereas opinions on the other two versions vary—some prefer the middle, and others favor the right. Therefore, both the middle and the right versions are considered acceptable.],
    zh: [上例中，中间版本接近传统效果，最右版本接近一般非专业计算机软件排版效果。大多数人认为最左版本难以阅读，而中间与最右版本则各有所好。因此中间、最右均可接受。],
  ),
)

#babel(
  en: [Furthermore, as illustrated in the following example, since Chinese characters are square-shaped, simple texts can often be aligned acceptably (and occasionally better) using the default `justify: false`. Only in complex cases---such as when text includes numbers, mathematical formulae, acronyms, or Western words---is it necessary to set `justify: true`. Nevertheless, for the sake of simplicity and robustness, we will continue to use simple text to demonstrate issues.],
  zh: [此外如下例，由于汉字是方块字，若文本比较简单，默认`justify: false`即可对齐（有时效果还更好）；只有遇到数字及数学公式、首字母缩写甚至西文单词等复杂情况时，才必须`justify: true`。不过为了简洁可靠，以下演示问题仍会采用简单文本。],
)

```example-page
>>> #import "/typ/examples/justification.typ": cell, example
>>> #example(
>>>   headers: (
>>>     [*Current & Expected* \ `#set par(justify: false)`],
>>>     [*Current & Expected* \ `#set par(justify: true)`],
>>>   ),
>>>   pages: (
>>>     {
>>>       set par(justify: false)
>>>       [我国在“十四五”前四年累计降低一成能耗强度；本年度黄河调水调沙今天启动。]
>>>     },
>>>     {
>>>       set par(justify: true)
>>>       [我国在“十四五”前四年累计降低一成能耗强度；本年度黄河调水调沙今天启动。]
>>>     },
>>>   ),
>>> )
```

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

#babel(
  en: [The above simple examples demonstrate the principle, and the following complex examples are closer to practicality.],
  zh: [以上简单例子展示了原理，下面的复杂例子更接近实用],
)

```example
>>> #set text(top-edge: "ascender", bottom-edge: "descender")
>>> Current:
#set par(justify: true)
#block(width: 8em)[
  天生我材必有用，千金散尽还复来。烹羊宰牛且为乐，会须一饮三百杯。
]

>>> Expected:
>>> #block(width: 8em)[
>>>   天生我材必有用，千金散尽还复来。烹羊宰牛且为乐，会须一饮三百杯#box[。]#linebreak(justify: true)
>>> ]
```

```example-page
>>> // This example behaves differently in `example` and `example-page` because of cjk-latin-spacing.
>>> #set text(top-edge: "ascender", bottom-edge: "descender")
>>> Current:
#set par(justify: true)
#block(width: 12em)[
  每年的消费量约4,000吨，每年的消费量
]

>>> Expected:
>>> #block(width: 12em)[
>>>   每年的消费量约4,000吨，每年的消费量#hide[约4,000吨#box[。]]#linebreak(justify: true)
>>> ]
```

=== #bbl(en: [Two-em dashes should not be overhung], zh: [破折号不应悬挂])

#level.basic
#issue("typst#6735")

#babel(
  en: [Two-em dashes have a width of 2 em and should not be overhung. This punctuation has two forms in Unicode: #unichar("⸺") is recommended, and two adjacent #unichar("—") characters are often used in practice. At present, the latter forms will be overhung.],
  zh: [破折号宽 2 em， 且不应悬挂。这一标点在 Unicode 中有两种形式：#unichar("⸺") 推荐使用，而两个连续的 #unichar("—") 实际更常用。目前后者会被悬挂。],
)

```example-page
>>> Current: \
#set par(justify: true)
#block(width: 9em, stroke: (right: green))[
  娜拉走后怎样？——别人可是也发表过意见的。一个英国人曾作一篇戏剧……
]

>>> Expected: \
>>> #block(width: 9em, stroke: (right: green))[
>>>   娜拉走后怎样？——\ 别人可是也发表过意见的。一个英国人曾作一篇戏剧……
>>> ]
```

=== #bbl(en: [Customize punctuation overhang], zh: [定制标点悬挂])

#level.advanced
#issue("typst#261")
#issue("typst#6582")

#babel(
  en: [#link("https://www.w3.org/TR/clreq/#hanging_punctuation_marks_at_line_end")[Most Chinese publications do not use hanging punctuation at line end], and there are also certain styles that prefer hanging. The #link("https://typst.app/docs/reference/text/text/#parameters-overhang")[`text.overhang`] parameter needs to be more configurable.],
  zh: [#link("https://www.w3.org/TR/clreq/#hanging_punctuation_marks_at_line_end")[绝大多数的中文出版物没有悬挂行尾点号的惯例]，但也有特定体例会悬挂。#link("https://typst.app/docs/reference/text/text/#parameters-overhang")[`text.overhang`]参数需要支持更多定制。],
)

```example-page
#set page(width: 7em + 2 * 1em, margin: 1em)
>>> #show heading: set text(1em / 1.4)
>>> #show heading: set block(below: 1em)

>>> = Current & \ Expected
第二天我起得非常迟，午饭之后，出去看了朋友。

>>> = Current & \ Expected
#set par(justify: true)
第二天我起得非常迟，午饭之后，出去看了朋友。

// Expected to be possible:
<<< #set text(overhang: ("、": 1.0, "，": 1.0, "。": 1.0))
>>> = Expected
>>> #set par(justify: false)
<<< 第二天我起得非常迟，午饭之后，出去看了朋友。
>>> 第二天我起得非常迟，午饭之后，#h(-1em)出去看了朋友。
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

=== #bbl(en: [Unexpected indentation after figures, lists and block equations], zh: [图表、列表、块级公式后异常缩进])

#level.basic
#issue("typst#3206")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/block-equation-in-paragraph.html")

#babel(
  en: [Figures, lists and block equations will break the paragraph, causing the following text to start a new paragraph. This becomes visually noticeable when a first-line indent is applied. In Chinese, it is common practice to use a 2-em first-line indent, making this issue particularly apparent.],
  zh: [图表、列表、块级公式会终结段落，导致后文另起一段。若设置了首行缩进，换段会很明显。而中文出版物普遍设置首行缩进两字，导致这一问题尤为突出。],
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

#level.ok
#workaround("https://typst-doc-cn.github.io/guide/FAQ/character-intersperse.html")
#workaround("https://typst.app/universe/package/tricorder")

#babel(
  en: [Even inter-character spacing means letting several Chinese characters to occupy a fixed width and be evenly distributed. It is often used for listing items.],
  zh: [均排是指让几个汉字占固定宽度并均匀分布。常用于列出项目。],
)

#babel(
  en: [Currently, it can be achieved by using #link("https://typst.app/docs/reference/text/linebreak/#parameters-justify")[`linebreak(justify: true)`] and aligning in the middle horizontally, as shown below.],
  zh: [当前可用#link("https://typst.app/docs/reference/text/linebreak/#parameters-justify")[`linebreak(justify: true)`]及左右居中实现，如下例。],
)

```example
>>> Current & \ Expected:
#table(
  align: center,
  stroke: (_, y) => if y > 0 { (top: 0.5pt) },
  inset: (x: 1em),
  table.hline(),
  ..(
    [质量],
    [体积],
    [能],
    [级差],
    [线密度],
    [土地面积],
  ).map(cell => cell + linebreak(justify: true)),
  table.hline(),
)
```
#babel(
  en: [In most cases, complex variants such as rosters can also be implemented in combination with #link("https://typst.app/docs/reference/layout/grid/")[`grid`], as shown below.],
  zh: [花名册等复杂变体通常也可结合#link("https://typst.app/docs/reference/layout/grid/")[`grid`]实现，如下例。],
)

```example
>>> Current & Expected:
#grid(
  columns: 2,
  gutter: 1em,
  .."丁声树、黎锦熙、李荣、陆志韦"
    .split("、")
    .map(cell => cell + linebreak(justify: true)),
)
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

=== #bbl(en: [Redundant CJK-Latin space at manual line breaks], zh: [人为换行时多余中西间距])

#level.ok
#issue("typst#6539", closed: true)
#pull("typst#6700", merged: true)

#till-next(now-fixed.with(last-affected: "0.13.1", last-level: "advanced"))

#babel(
  en: [If the line is manually broken between a CJK and a Latin character, then typst will insert an extra CJK-Latin space. This space becomes noticeable when text is aligned to the right or center.],
  zh: [若在汉字和拉丁字母间手动换行，typst 会插入多余中西间距。如果文本右对齐或居中对齐，这个间距会显现出来。],
)

```example
>>> Current: \
#set text(cjk-latin-spacing: auto)
#box(width: 3em, stroke: (right: green), align(right, [国国\ TT]))

>>> Expected: \
>>> #box(width: 3em, stroke: (right: green), align(right, [国国TT]))
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
      typst 能否对齐多文种的基线？行高、行距等方面有无问题？直排时的基线、行高能否满足要求？
    ],
  )
]

=== #bbl(en: [Default line height is too tight for Chinese], zh: [默认行高对中文来说过小])

#level.basic
#issue("typst#5644")
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
<<< Typst 国王 \
<<< Typst 国王
>>> #box[Typst 国王] \
>>> #box[Typst 国王]

>>> Expected: \
>>> #set text(top-edge: "ascender", bottom-edge: "descender")
>>> #box[Typst 国王] \
>>> #box[Typst 国王]
```

=== #bbl(
  en: [`box` is not aligned if `text.bottom-edge` is not baseline],
  zh: [`text.bottom-edge`不是基线时，`box`未对齐],
)

#level.advanced
#issue("tianyi-smile/itemize#8")

#babel(en: [This issue continues the above issue.], zh: [这一问题接续上一问题。])

#babel(
  en: [At present, #link("https://typst.app/docs/reference/layout/box/", `box`) is always put on the baseline, even if `text.bottom-edge` is not `"baseline"`, leading to misalignment.],
  zh: [目前即使`text.bottom-edge`不是`"baseline"`，#link("https://typst.app/docs/reference/layout/box/", `box`)也总是放到基线上，导致对不齐。],
)

```example
>>> Current: \
#set text(bottom-edge: "descender")
淇水#box[汤]汤

>>> Expected: \
>>> 淇水#box[#set text(bottom-edge: "baseline");汤]汤
```

#babel(
  en: [This affects Chinese particularly. All Chinese characters have a square-shaped frame, so the natural definition of bottom edge is the bottom edge of the squares, and most Chinese fonts will mark it as the descender line. As a result, some people prefer `bottom-edge: "descender"` to the default `bottom-edge: "baseline"` for their Chinese documents.],
  zh: [中文特别受此影响。汉字都是方块字，所以底线的自然定义就是方块的底边，而中文字体大多将它标成下降部的边缘线。因此，有些人会选择将中文文档从默认的`bottom-edge: "baseline"`改为`bottom-edge: "descender"`。],
)

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
  en: [
    #show: latin-apostrophe
    List and enum markers are not aligned with the baseline of the item’s contents
  ],
  zh: [`list`和`enum`的编号与内容未对齐基线],
)

#level.basic
#issue("typst#1204")
#issue("typst#1610")
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

=== #bbl(en: [The auto hanging indents of multiline headings are inaccurate], zh: [多行标题的自动悬挂缩进不准确])

#level.advanced
#issue("typst#6527")
#workaround("https://github.com/typst/typst/issues/6527#issuecomment-3026200835")

#babel(
  en: [The default value of `heading.hanging-indent` is `auto`, which indicates that the subsequent heading lines will be indented based on the width of the numbering. However, the `auto` width is not accurate if the numbering ends with a full-width punctuation, e.g., #unichar("、").],
  zh: [`heading.hanging-indent`默认为`auto`，表示标题从第二行起按编号的宽度缩进。然而若编号以全宽标点结尾，例如 #unichar("、")，那么`auto`得出的宽度并不准确。],
)

```example-page
#set page(width: 5 * 12pt + 2 * 1em, margin: 1em)
#show heading: set text(12pt)

>>> #show heading: pad.with(top: -0.75em)
>>> Current:
#set heading(numbering: "一、")
= 寻寻觅觅

>>> Expected:
>>> #set heading(numbering: none, hanging-indent: 2em)
>>> = 一、寻寻觅觅
```

== Styling initials <initials>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#initials")[
  Does typst correctly handle special styling of the initial letter of a line or paragraph, such as for drop caps or similar? How about the size relationship between the large letter and the lines alongside? where does the large letter anchor relative to the lines alongside? is it normal to include initial quote marks in the large letter? is the large letter really a syllable? etc. Are all of these things working as expected?
]

#level.tbd

= #bbl(en: [Page & book layout], zh: [页面与书籍版式])

== #bbl(en: [General page layout & progression], zh: [基本页面版式与装订方向]) <page-layout>

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#page_layout")[
  How are the main text area and ancillary areas positioned and defined? Are there any special requirements here, such as dimensions in characters for the Japanese kihon hanmen? The book cover for scripts that are read right-to-left scripts is on the right of the spine, rather than the left. Is that provided for? When content can flow vertically and to the left or right, how do you specify the location of objects, text, etc. relative to the flow? For example, keywords `left` and `right` are likely to need to be reversed for pages written in English and page written in Arabic. Do tables and grid layouts work as expected? How do columns work in vertical text? Can you mix block of vertical and horizontal text correctly? Does text scroll in the expected direction? Other topics that belong here include any local requirements for things such as printer marks, tables of contents and indexes. See also @grids-tables.
]

=== #bbl(en: [Chinese size system (hào-system)], zh: [中文字号的号数制])

#level.advanced
#workaround("https://typst.app/universe/package/pointless-size")

#babel(
  en: [号数制 (hào-system, or number system) is the system to specify text size in Chinese and Japanese typesetting. The unit is not linearly related to points: 五号 (size 5) = 10.5 pt, 小四 (size small 4) = 12 pt, 四号 (size 4) = 14 pt… The hào-system is still commonly used in China. An average person may be familiar with the size of 小四, but likely has little intuition about 12 pt without referring to a conversion table..],
  zh: [号数制是中文和日文排版中指定字号的系统。这种单位无法线性转换成点数：五号 = 10.5点，小四 = 12点，四号 = 14点……号数制在中国仍然普遍使用。普通人通常理解小四字多大，但可能对 12 pt 没有直观感受，除非查阅转换表。],
)

#babel(
  en: [The following is #link("https://ccjktype.fonts.adobe.com/2009/04/post_1.html#ENG")[a typical conversion table in Chinese].],
  zh: [#link("https://ccjktype.fonts.adobe.com/2009/04/post_1.html#ZHS")[中文典型转换表]如下。],
)

```example-page
>>> #import "@preview/pointless-size:0.1.1": zh
>>>
>>> #table(
>>>   columns: 4,
>>>   align: (right, left).map(a => a + horizon),
>>>   stroke: none,
>>>   table.hline(),
>>>   [*hào 号数*], [*point 点数*],
>>>   table.vline(stroke: 0.5pt),
>>>   [*hào 号数*], [*point 点数*],
>>>   table.hline(stroke: 0.5pt),
>>>   ..(
>>>     "初号",
>>>     "小初",
>>>     range(1, 9).map(n => (
>>>       numbering("一号", n),
>>>       if n < 7 { numbering("小一", n) } else { none },
>>>     )),
>>>   )
>>>     .flatten()
>>>     .map(n => if n != none {
>>>       (text(zh(n), n), [#zh(n)])
>>>     } else { (none, none) })
>>>     .flatten(),
>>>   table.hline(),
>>> )
```

#babel(
  en: [This issue should have been marked as Basic. However, considering that the hào-system was not standardized by the various foundries in the past (for example, nowadays, #link("https://github.com/YDX-2147483647/typst-pointless-size/blob/main/docs/ref.md")[四号 is 14 pt in CTeX, MS Word, WPS, and Adobe], but others may prefer 13.75 pt), we mark it as Advanced for the moment.],
  zh: [这一问题本该算作 Basic，但由于号数制当年在各地金属活字厂家并未统一（例如今日 #link("https://github.com/YDX-2147483647/typst-pointless-size/blob/main/docs/ref.md")[CTeX、MS Word、WPS、Adobe 的四号是14点]，但其它可能用13.75点），暂且算作 Advanced。],
)

=== #bbl(
  en: [Directly setting the width of the type area, instead of the paper width],
  zh: [直接设置版心宽度而非纸张宽度],
)

#level.advanced

// Ref: https://www.w3.org/TR/clreq/#considerations_in_designing_type_area
#babel(
  en: [In Chinese typography, line length should be multiples of the character size. Otherwise, several alignment issues described in @justification may occur.],
  zh: [中文排版中，一行的行长应为文字尺寸的整数倍，不然容易触发 @justification 中的若干对齐问题。因此通常“先确定版心，再余出空白”，而不是“先确定边距，再剩出版心”。],
)

```example
<<< // Current:
<<< #set page(paper: "a4", margin: (x: (100% - 42em) / 2))
<<<
<<< // Expected to be easier:
<<< #set page(paper: "a4", inner-width: 42em)

>>> #let k = 7 // scale factor
>>>
>>> #box(width: 210mm / k, height: 297mm / k, stroke: 1pt, align(center + horizon, box(
>>>   width: 42em / k,
>>>   height: (297mm - 5cm) / k,
>>>   fill: blue.lighten(50%),
>>>   {
>>>     import math: arrow, stretch
>>>     set raw(lang: "typc")
>>>     set text(42em / k / 5)
>>>     set par(leading: 0em)
>>>
>>>     `42em`
>>>     v(-1.5em)
>>>     stretch(arrow.l.r, size: 5em)
>>>
>>>     parbreak()
>>>
>>>     `210mm`
>>>     v(-1.5em)
>>>     stretch(arrow.l.r, size: 210mm / k)
>>>   },
>>> )))
```

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

#level.ok
#issue("typst#633", closed: true)
#issue("typst#6513", closed: true)
#issue("typst#4203", closed: true)
#pull("typst#5777", merged: true)
#workaround("https://typst-doc-cn.github.io/guide/FAQ/cite-flying.html")

#till-next(now-fixed.with(last-affected: "0.13.1", last-level: "basic"))

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

#babel(
  en: [This issue is caused by an imperfect font, but typst can still provide a better default. For example, we can use the dedicated superscript glyphs only when all characters in `[1]` have them. According to the following example, the mechanism is already implemented for `#super`, but `#cite` processes prefix (`[`), number (`1`), and suffix (`]`) separately, thereby ignoring that mechanism.],
  zh: [此一问题由字体不完善导致，但 typst 仍可改进默认处理方式。例如，只有`[1]`中所有字符都有专用上标版本时，才使用它。根据下例，`#super`已实现此机制，但`#cite`分别处理前缀（`[`）、数字（`1`）和后缀（`]`），导致绕开了这一机制。],
)

````example-page
>>> Analysis:
>>> #show regex("[✅❌]"): set text(fallback: true)
#set text(font: "Noto Serif CJK SC")

❌国@key
✅国#super("[1]")
❌国#"[1]".clusters().map(super).join()

#set super(typographic: false)

✅国@key
✅国#super("[1]")
✅国#"[1]".clusters().map(super).join()

>>> #show bibliography: none
>>> #let bib = ```bib
>>> @misc{key,
>>>   title = {Title},
>>> }
>>> ```.text
>>> #bibliography(bytes(bib), style: "gb-7714-2015-numeric")
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
  en: [Both the superscript and non-superscript forms are needed in practice.],
  zh: [实际中，上标、非上标两种引用形式都需要。],
)

````example-page
>>> Expected: \
<<< 孔乙己@key，另见#cite(<key>, form: "prose-short")。
>>> 孔乙己#super[[1]]，另见文献#h(0.25em)#[[1]]。
````

=== #bbl(en: [Cite with page numbers], zh: [带页码引用])

#level.advanced
#workaround("https://forum.typst.app/t/how-to-cite-with-a-page-number-in-gb-t-7714-2015-style/1501/4")

````example-page
>>> Current: \
初次@a[260] \
再次@a[326--329] @b @c @d

>>> Expected: \
>>> 初次#super[[1]260] \
>>> 再次#super[[1]326--329] @b @c @d
>>> #show bibliography: none
#let bib = (
  "abcd".clusters().map(n => "@misc{[n], title = {Title}}".replace("[n]", n)).sum()
)
#bibliography(bytes(bib), style: "gb-7714-2015-numeric")
````

#babel(
  en: [This issue is marked as advanced, because citing with page number is not common. According to GB/T 7714—2015 §10.1.3, in most cases, page numbers should be recorded in the bibliography list. Citing with page number is only necessary when the work is cited multiple times with different page numbers.],
  zh: [这一问题算作 Advanced，因为带页码引用并不常见。根据 GB/T 7714—2015 §10.1.3，大多数情况下页码应当记录在参考文献表中；只有多次引用同一文献的不同页码时，才需在引用处标注页码。],
)

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
#issue("typst#3168")
#issue("nju-lug/modern-nju-thesis#3")
#issue("csimide/SEU-Typst-Template#1")
#pull("biblatex#78", merged: true)
#pull("hayagriva#126", rejected: true)
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-etal-lang.html")
#workaround("https://typst.app/universe/package/modern-nju-thesis")

#babel(
  en: [It is extremely common to cite both Chinese and English works in an article. For multi-author literature, some authors may be omitted. In such cases, we should use `et al.` for English and `等` for Chinese.],
  zh: [一篇文章同时引用中英文献极其常见。多著者文献可能省略部分作者，这时英文应加`et al.`，中文应加`等`。],
)

#babel(
  en: [Currently, `#set text(lang: …)` can select `et al.` (en) or `等` (zh) for all entries, but it is not possible to set each entry individually.],
  zh: [当前可用`#set text(lang: …)`统一选择`et al.`（en）与`等`（zh），但无法逐文献设置。],
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

=== #bbl(en: [`institution` and `school` are not shown], zh: [`institution`机构名称和`school`学校名称不显示])

#level.broken
#issue("hayagriva#112")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-missing-school.html")

#babel(
  en: [`institution` and `school` are not recognized as aliases of `publisher`, and typst does not understand `institute` in CSL either. The `school` field is conventionally associated with `@thesis` (`[D]`), and the `institute` field with `@report` (`[R]`). These fields should be placed between the location and the date after `[D]`/`[R]`.],
  zh: [`institution`机构名称和`school`学校名称未被识别成`publisher`的别名，typst 亦不支持解析 CSL 中的 `institution`。`school`字段常用于学位论文`@thesis`（`[D]`），`institute`字段常用于报告`@report`（`[R]`），它们应显示在`[D]`/`[R]`后的地点与日期之间。],
)

```example-bib
@report{report,
  author = {Robert Swearingen},
  title = {Morphology and syntax of British sailors’ English},
  series = {Technical Report},
  number = {249},
  institution = {Profanity Institute},
  address = {New York},
  year = {1985},
}
% SWEARINGEN R. #text(font: "New Computer Modern")[Morphology and syntax of British sailors’ English] [R]. 249. New York: Profanity Institute, 1985.
@thesis{王楠2016,
  title = {在“共产主义视镜”下想象科学——“十七年”期间的中国科幻文学与科学话语},
  author = {王楠},
  date = {2016-08-05},
  institution = {新加坡国立大学},
  location = {新加坡},
  url = {https://scholarbank.nus.edu.sg/handle/10635/132143},
  urldate = {2025-02-15},
  langid = {chinese}
}
% 王楠. 在“共产主义视镜”下想象科学——“十七年”期间的中国科幻文学与科学话语[D/OL]. 新加坡: 新加坡国立大学, 2016[2025-02-15]. https://scholarbank.nus.edu.sg/handle/10635/132143.
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
#issue("hayagriva#193")

#babel(
  en: [The style `gb-7714-2015-author-date` currently sorts works by Unicode code points. However, according to the standard, when using this style, the cited works should first be grouped by scripts, then arranged by author names and publication dates. For Chinese works, they may be ordered by either pinyin or strokes.],
  zh: [目前`gb-7714-2015-author-date`样式按Unicode码位排序。而标准规定，采用这种样式时，各篇文献首先按文种集中，然后按著者字顺和出版年排列，其中中文文献可按著者汉语拼音字顺或笔画笔顺排列。],
)

=== #bbl(en: [`gb-7714-2015-note` is totally broken], zh: [`gb-7714-2015-note`完全无法使用])

#level.ok
#issue("hayagriva#189", note: [mentioned])
#issue("hayagriva#280", closed: true)
#pull("hayagriva#301", merged: true)
#issue("typst#6612")
#issue("typst#7113", closed: true)

#till-next(now-fixed.with(last-affected: "0.13.1", last-level: "advanced"))

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
#issue("citationberg#35", closed: true)
#issue("hayagriva#405")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/bib-csl.html")
#workaround("https://typst-doc-cn.github.io/csl-sanitizer/", note: "csl-sanitizer")

#babel(
  en: [The compiler does not support the CSL-M standard yet, nor is it compatible with some extensions of citeproc-js.],
  zh: [编译器暂不支持 CSL-M 标准，也不兼容 citeproc-js 的一些扩展。],
)

#babel(
  en: [As of October 2025, 222 of 302 (74%) #link("https://zotero-chinese.com/styles/")[Chinese CSL styles] are considered malformed by hayagriva. Unfortunately, hayagriva hardly provides clear error messages, making it very difficult to debug.],
  zh: [截至2025年十月，302个#link("https://zotero-chinese.com/styles/")[中文 CSL 样式]中的222个（74%）都会被 hayagriva 判为 malformed。而且很不幸，hayagriva 提供的错误信息一般并不清晰，导致调试异常困难。],
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

=== #bbl(
  en: [For references to headings, the supplement should not be put before the number],
  zh: [引用章节时，名称不该在编号之前],
)

#level.broken
#issue("typst#5102")
#issue("typst#2485", anchor: "#issuecomment-2097524535", note: [mentioned])

#babel(
  en: [When referencing chapters and sections in Chinese, it is standard to write `第一章` or `2.1小节`, while forms like `小节2.1` are rarely used, and `章一` is virtually nonexistent. Therefore, the `supplement` parameter of `ref` or `heading` is useless for Chinese, making it inevitable to use `#show ref: it => …`.],
  zh: [引用章节时，中文通常写`第一章`或`2.1小节`，而几乎不写`小节2.1`，更不会写`章一`。因此，中文无法使用`ref`或`heading`的`supplement`参数，必须`#show ref: it => …`。],
)

#bbl(en: [Literal meanings:], zh: [字面含义：])

- ✅ `第一章`—— number one chapter
- ✅ `2.1小节`—— 2.1 tiny section
- 😟 `小节2.1`—— tiny section 2.1
- ❌ `章一`—— chapter one

```example-page
>>> = Current
>>> #counter(heading).update(2)
#set heading(numbering: "1.1")
== 标题 <sec>
见@sec。

>>> #heading(numbering: none)[Expected]
>>> #counter(heading).update(2)
>>> == 标题
>>> 见 2.1 小节。
```

#babel(
  en: [Besides, defining a show rule to replace `ref` with `link(it.element.location(), …)` will cause other problems, such as difficulty in coloring `link` and `ref` separately.],
  zh: [此外，若在 show 规则中用`link(it.element.location(), …)`替代`ref`，又会引发其它问题，例如难以给`link`、`ref`分别上色。],
)

=== #bbl(en: [Bilingual figure captions], zh: [双语插图标题])

#level.advanced
#workaround("https://typst-doc-cn.github.io/guide/FAQ/dual_language_caption.html")

```example-page
>>> Expected:
>>> #align(center)[
>>>   #rect(inset: 1em)[Example \ Image]
>>>
>>>   图 1 #h(0.5em) 标题 \
>>>   Figure 1 #h(0.5em) Caption
>>> ]
```

== #bbl(en: [What else?], zh: [其它])

#prompt(from-w3c: "https://www.w3.org/TR/clreq-gap/#other")[
  There are many other modules and specifications which may need review for script-specific requirements. What else is likely to cause problems for worldwide usage of typst, and what requirements need to be addressed to make typst function well locally?
]

=== #bbl(en: [Ignore linebreaks between CJK characters in source code], zh: [忽略源码中CJK字符间的换行])

#level.advanced
#issue("typst#792")
#workaround("https://typst-doc-cn.github.io/guide/FAQ/chinese-remove-space.html")
#workaround("https://typst.app/universe/package/cjk-unbreak")

```example
>>> Current: \
测试一下，
效果怎么样。

>>> Expected: \
>>> 测试一下，效果怎么样。
```

#babel(
  en: [This issue is marked as advanced, because not all people want this behaviour.],
  zh: [这一问题算作 Advanced，因为并非所有人都想要这种行为。],
)

=== #bbl(en: [Internationalize warning and error messages], zh: [国际化警告和错误信息])

#level.advanced
#issue("typst#6460")

#babel(
  en: [At present, there are no relevant methods, no matter the messages come from the core compiler or third-party packages.],
  zh: [尚无任何相关措施，无论报错发自核心编译器还是第三方包。],
)

=== #bbl(en: [A Chinese name for the Typst project], zh: [Typst 项目的中文名])

#level.advanced

#babel(
  en: [The Typst project does not have an official Chinese name, which prevents its mention in certain academic or teaching scenarios where mixing languages is discouraged. In addition, the Chinese language does not have consonants like -pst, so it is difficult to pronounce _Typst_. Therefore, some people suggested that there should be a Chinese name.],
  zh: [Typst 项目没有官方中文名，而特定学术或教学场合限制混合语言，导致无法提及。此外汉语没有 -pst 这样的辅音，导致“Typst”一词发音困难。因此，有人认为应该有个中文名。],
)

#babel(
  en: [However, there are more reasons not to localize the name _Typst_. #link("https://forum.typst.app/t/chinese-name-for-the-typst-project/6024/13")[A naive vote in September 2025] indicated that the vast majority of people believed that there is no need for localization at present: just use _Typst_.],
  zh: [然而还有更多理由不翻译“Typst”。#link("https://forum.typst.app/t/chinese-name-for-the-typst-project/6024/13")[2025年9月的简单投票]表明，绝大多数人认为目前没有必要翻译：直接称“Typst”即可。],
)

=== #bbl(en: [Web app issues], zh: [在线应用的问题])

#level.advanced
#workaround("https://typst-doc-cn.github.io/guide/FAQ/webapp-spellcheck.html")

#bbl(
  en: [There are a few issues for the official typst.app that related to the Chinese script.],
  zh: [官方 typst.app 有些问题与中文相关。],
)

#babel(
  en: [For example, the spell checker embedded in the web app does not support Chinese, marking all characters as misspelled, as shown in @fig-webapp-misspell.],
  zh: [例如在线应用内嵌的拼写检查器不支持中文，每个字都会被标为拼写错误，如 @fig-webapp-misspell。],
)

#figure(
  image(
    "/public/webapp-misspell.png",
    alt: "我要給阿Q做正傳，已經不止一兩年了。但一面要做，一面又往回想，這足見我不是一個“立言”的人，因為從來不朽之筆，須傳不朽之人，於是人以文傳，文以人傳——究竟誰靠誰傳，漸漸的不甚瞭然起來，而終於歸接到傳阿Q，仿佛思想裏有鬼似的。",
    width: 80%,
  ),
  caption: bbl(en: [94 spelling mistakes], zh: [94个拼写错误]),
) <fig-webapp-misspell>

#babel(
  en: [Considering that these issues cannot be reproduced robustly and automatically, we only list them below without further explanation.],
  zh: [考虑到这些问题难以稳定自动复现，在此仅列出问题而不加说明。],
)

- #issue("webapp-issues#48", closed: true)

  #bbl(en: [Add region option to template wizard, alongside language option], zh: [在模板向导的语言设置旁添加地区设置])

- #issue("webapp-issues#483")

  #bbl(
    en: [The interaction between IME (Input Methods Editor) and the collaboration feature is confusing],
    zh: [输入法和分享功能的相互作用很迷惑],
  )

- #issue("webapp-issues#675")

  #bbl(
    en: [Spell checker does not respect `text.lang` if the `*.typ` is not included in `main.typ`],
    zh: [若`*.typ`未被`main.typ`导入，则拼写检查器会忽略`text.lang`],
  )

- #issue("webapp-issues#733")

  #bbl(
    en: [Spell checker does not respect `text.lang` set by regex show rules],
    zh: [用 show regex 规则设置的`text.lang`会被拼写检查器忽略],
  )

- #issue("typst#5436")

  #bbl(
    en: [Support font name autocompletion for `set text(font: array)`],
    zh: [在`set text(font: array)`中支持自动补全字体名称],
  )

#set heading(numbering: none)

= #bbl(en: [Addendum], zh: [附录])

== #bbl(en: [List of sites], zh: [站点列表])

- #bbl(en: [Main site], zh: [主站]) \
  #link("https://typst-doc-cn.github.io/clreq/")[typst-doc-cn.github.io/clreq]
- #bbl(en: [Mirror site], zh: [镜像站]) \
  #link("https://gap.zhtyp.art")[gap.zhtyp.art]
- #bbl(en: [Test site], zh: [测试站]) \
  #link("https://clreq-gap-typst.netlify.app")[clreq-gap-typst.netlify.app]

== #bbl(en: [Environment of the examples], zh: [例子的环境信息])

- #bbl(en: [Update date], zh: [更新日期]) \
  #datetime.today().display()

- #bbl(en: [Compiler], zh: [编译器]) \
  typst v#sys.version

#if "git" in sys.inputs {
  let git = json(bytes(sys.inputs.git))
  [
    - #bbl(en: [Document version], zh: [文档版本]) \
      #link(git.commit_url)[commit #git.name] (#link(git.log_url)[log])

      #layout-git-log(summary: bbl(en: [Latest log], zh: [最新日志]), git.latest_log)
  ]
}

- #bbl(en: [Default fonts], zh: [默认字体]) \
  New Computer Modern, Noto Serif CJK SC

== #bbl(en: [References], zh: [参考资料])

- #bbl(en: [W3C documents], zh: [W3C 文档])

  - #link("https://www.w3.org/TR/clreq/")[Requirements for Chinese Text Layout - 中文排版需求]
  - #link("https://www.w3.org/TR/clreq-gap/")[Chinese Layout Gap Analysis]

- #bbl(en: [Web resources], zh: [网络资源])

  - #link("https://typst-doc-cn.github.io/guide/FAQ.html")[FAQ 常见问题 | Typst Doc CN 中文社区导航]
  - #link("https://www.thetype.com/kongque/")[孔雀计划：中文字体排印的思路 | The Type — 文字 / 设计 / 文化]
  - #link("https://wiki.wordsoftype.com")[Words of Type | Encyclopedia]

- #bbl(en: [Standards], zh: [标准])

  - #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A")[GB/T 7714—2015《信息与文献　参考文献著录规则》_Information and documentation—Rules for bibliographic references and citations to information resources_] (#link("https://lib.tsinghua.edu.cn/wj/GBT7714-2015.pdf")[PDF])
  - #link("https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D7FE25D3A7E05397BE0A0AB82A")[GB/T 15834—2011《标点符号用法》_General rules for punctuation_] (#link("http://www.moe.gov.cn/jyb_sjzl/ziliao/A19/201001/W020190128580990138234.pdf")[PDF])
  - #link("https://std.samr.gov.cn/hb/search/stdHBDetailed?id=8B1827F23645BB19E05397BE0A0AB44A")[CY/T 154—2017《中文出版物夹用英文的编辑规范》_Rules for editing Chinese publications interpolated with English_] (#link("https://www.nppa.gov.cn/xxgk/fdzdgknr/hybz/202210/P020221004608768453140.pdf")[PDF])

- #bbl(en: [Reference implementations], zh: [参考实现])

  - #link("https://ctan.org/pkg/biblatex-gb7714-2015")[`biblatex-gb7714-2015`], #bbl(zh: [符合 GB/T 7714—2015 标准的 biblatex 参考文献样式], en: [A BibLaTeX implementation of the GB/T 7714—2015 bibliography style for Chinese users]) (#link("https://texdoc.org/serve/biblatex-gb7714-2015/0")[TeXdoc PDF], #link("https://github.com/hushidong/biblatex-gb7714-2015")[GitHub])
  - #link("https://ctan.org/pkg/gbt7714")[`gbt7714`], GB/T 7714 BibTeX style (#link("https://texdoc.org/serve/gbt7714/0")[TeXdoc PDF], #link("https://github.com/zepinglee/gbt7714-bibtex-style")[GitHub])

== #bbl(en: [To be done], zh: [待办])

- Content

  - Include resolved issues (for historians)

- Live long

  - Improve #link(repo-blob + "/README.md")[the contributing guide]

== Umbrella/tracking issues

- Advanced East-Asian layout features #issue("typst#193")
- Better CJK support #issue("typst#276")
- Better out-of-the-box experience for non-Latin scripts #issue("webapp-issues#720")
