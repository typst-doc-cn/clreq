# [clreq](https://www.w3.org/TR/clreq/)-[gap](https://www.w3.org/TR/clreq-gap/) for typst

Chinese Layout Gap Analysis for Typst.

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

Note that `#set page(width: …)` does not work here.
You could use `#show: block.with(width: …)` instead.

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
