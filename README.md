# [clreq](https://www.w3.org/TR/clreq/)-[gap](https://www.w3.org/TR/clreq-gap/) for typst

Chinese Layout Gap Analysis for Typst.

[![Check](https://github.com/typst-doc-cn/clreq/actions/workflows/check.yml/badge.svg)](https://github.com/typst-doc-cn/clreq/actions/workflows/check.yml)
[![clreq::gh_pages](https://github.com/typst-doc-cn/clreq/actions/workflows/gh-pages.yml/badge.svg)](https://github.com/typst-doc-cn/clreq/actions/workflows/gh-pages.yml)

## Build

```shell
# Compile
pnpm build # ⇒ dist/index.html

# Recompile on changes
pnpm dev # ⇒ http://localhost:3000
```

Prerequisites:

- [pnpm](https://pnpm.io), the package manager

- _Noto Serif CJK SC_, the typeface

  Download [`09_NotoSerifCJKsc.zip`](https://mirrors.cernet.edu.cn/github-release/googlefonts/noto-cjk/LatestRelease/09_NotoSerifCJKsc.zip) from [校园网联合镜像站 · Google Fonts](https://mirrors.cernet.edu.cn/font/GoogleFonts), or [Language Specific OTFs Simplified Chinese (简体中文)](https://github.com/notofonts/noto-cjk/releases/latest/download/09_NotoSerifCJKsc.zip) from [GitHub Releases · notofonts/noto-cjk](https://github.com/notofonts/noto-cjk/releases).

  Then install the fonts to system, or put them under `./fonts/`.

## How to add an example

You can add an example to [`main.typ`](./main.typ) by writing a fenced code block with one of the following languages.

### Simple examples (`example`)

A simple typst example.

````typst
```example
>>> Current: \
#underline[中文和English]

>>> Expected: \
>>> #set underline(offset: .15em, stroke: .05em)
>>> #underline[中文和English]
```
````

- Regular lines:

  👀 shown as the source, and 🚀 executed in preview.

- Lines starting with `>>>`:

  🙈 hidden from the source, but still 🚀 executed in preview.

- Lines starting with `<<<`:

  👀 shown as the source, but 🛑 not executed in the preview.

#### Limitations

Simple examples are evaluated in a container and their states are shared across the entire document.

As a result:

- Any page configuration is not allowed. 

  If you just want to `#set page(width: …)`, then use `#show: block.with(width: …)` instead.

- Updating counters will affect the following examples.

- Citations and bibliographies will conflict with other examples.

- …

If you need advanced features, please write a page example instead.

### Page examples (`example-page`)

A standalone typst example compiled in a page.

`````typst
````example-page
>>> Current: \
孔乙己@key

>>> Expected: \
>>> 孔乙己@key
>>> #show bibliography: none
#let bib = ```bib
@misc{key,
  title = {Title},
}
```.text
#bibliography(bytes(bib), style: "gb-7714-2015-numeric")
````
`````

The meanings of `<<<` and `>>>` are the same as those in simple examples.

### Bibliography examples (`example-bib`)

````typst
```example-bib
@book{key,
  title = {标题},
  author = {作者},
  year = {2025}
}
% 作者. 标题. 2025.
```
````

- Regular lines: BibTeX entries.

- Lines starting with `%`: Expected output.

## License

The code are licensed under Apache 2.0. All rights of rest content are reserved.
