# [clreq](https://www.w3.org/TR/clreq/)-[gap](https://www.w3.org/TR/clreq-gap/) for [typst](https://typst.app/home)

Chinese Layout Gap Analysis for Typst.
分析 Typst 与中文排版的差距。

[![Check](https://github.com/typst-doc-cn/clreq/actions/workflows/check.yml/badge.svg)](https://github.com/typst-doc-cn/clreq/actions/workflows/check.yml)
[![Website](https://img.shields.io/website?url=https%3A%2F%2Ftypst-doc-cn.github.io%2Fclreq%2F&label=Website)](https://typst-doc-cn.github.io/clreq/)

**语言版本：[English](./README.en.md)** | **[中文（当前文件）](./README.md)**

<!-- <included #intro by="main.typ"> -->
Typst 是一款基于标记的排版软件，这份文档描述了它在中文支持方面的差距，特别是[排版](https://www.w3.org/TR/clreq/)和[参考文献著录](https://std.samr.gov.cn/gb/search/gbDetailed?id=71F772D8055ED3A7E05397BE0A0AB82A)。本文会检查 typst 编译器是否支持所需功能，并介绍可能的临时解决方案。
<!-- </included> -->

[文档正文位于网站](https://typst-doc-cn.github.io/clreq/)，以下是参与指南。

## 参与指南

### 反馈

如果您发现缺漏错误，或有疑问建议，请在 [GitHub Issues](https://github.com/typst-doc-cn/clreq/issues/) 提出。

- 语言：这里使用中英文均可。待时机成熟后，会用英文反馈给 [Typst 官方](https://github.com/typst/typst/)，同时在此文档补全双语翻译。

- 若是初次使用，可参考 [W3C 的 GitHub Issue 指南（附图，中文）](https://www.w3.org/International/i18n-activity/guidelines/issues.zh-hans.html)。如果有困难，也可加入 [QQ 中文聊天群](https://typst-doc-cn.github.io/guide/#用户社区)直接反馈。

### 编辑文档

文档正文使用 Typst 生成。日常编辑方法如下：

1. [在 GitHub 上打开`main.typ`](https://github.com/typst-doc-cn/clreq/blob/main/main.typ)
2. 单击右上角的编辑按钮`✏️`，按提示进行准备工作（登录、创建 fork 等）。
3. 编辑`main.typ`。
4. 单击右上角 _Commit changes…_，按提示完成编辑（简要介绍修改，发起 pull request 等）。
5. 稍等片刻，机器人会将新版文档渲染成网页，评论到 pull request 下。可视情况继续编辑。

<details>
<summary>也可在本地预览</summary>

```shell
# 编译
pnpm build # ⇒ dist/index.html

# 跟踪更改自动重新编译
pnpm dev --open # ⇒ http://localhost:3000
```

需要预先安装：

- [pnpm](https://pnpm.io)，包管理器

- _Noto Serif CJK SC_，字体

  1. 从[校园网联合镜像站 · Google Fonts](https://mirrors.cernet.edu.cn/font/GoogleFonts)
  下载[`09_NotoSerifCJKsc.zip`](https://mirrors.cernet.edu.cn/github-release/googlefonts/noto-cjk/LatestRelease/09_NotoSerifCJKsc.zip)，或者从
  [GitHub Releases · notofonts/noto-cjk](https://github.com/notofonts/noto-cjk/releases)
  下载 [Language Specific OTFs Simplified Chinese (简体中文)](https://github.com/notofonts/noto-cjk/releases/latest/download/09_NotoSerifCJKsc.zip)。

  2. 把字体安装到系统中，或者把字体文件放到`./fonts/`。

  对于大多数贡献者，只安装 _Noto Serif CJK SC_ 就够了。如需严格复现所有例子，请参考[`download_fonts.sh`](./scripts/download_fonts.sh)。

</details>

## `main.typ`编写参考

### 内容范围

对于每个问题，请尽量：

- 简要描述问题

- 提供能一眼看懂问题的简洁例子

- 补充不懂中文者可能不清楚的背景

  例如，写中文需要输入法。可链接 [Unicode 中文日文 FAQ](https://unicode.org/faq/han_cjk.html)。

不过一般：

- 无需直接提供解决方案

  只要`#workaround("https://…")`这样链接即可。

- 无需全面描述问题，也不建议过多讨论改进方案

  这些内容可初步在 [GitHub Issues](https://github.com/typst-doc-cn/clreq/issues/) 提出，最终应反馈给 Typst 官方。

### 多语言内容（`babel`/`bbl`）

- `en`、`zh`两字段分别在 English、中文模式显示。

- `babel`用于段落`par`，会生成块级元素（`<p>`）；`bbl`用于段落内的短语短句，会生成行内元素（`<span>`）。

示例：

```typst
=== #bbl(en: [Vertical Writing Mode], zh: [直排])

#babel(
  en: [There are *two* writing modes in Chinese composition…],
  zh: [中文有*两种*行文模式……],
)
```

提示：

- 打 pull request 草稿时，不必一开始就写全双语翻译；可先只写一种，敲定内容后再补另一种。

- 不是所有内容都要翻译。某些术语无法翻译，或者只看单一语言会有歧义，这种就没必要套`bbl`，直接写即可。

- 不用刻意关注换行与缩进，按 tinymist (VS Code) / typstyle 默认即可。为方便对比版本，已设置 pull request 机器人自动统一格式。

### 添加代码例子

代码例子会在渲染网站时编译。

编写代码例子时：

- 应保证与显示语言无关，不支持也不能使用`babel`

- 占位内容优先用汉字，只有必要时才加上标点和拉丁字母

- 尽量避免在代码内包含说明性文字；若实在无法避免，优先用英文短语或 emoji

添加例子的具体方法是插入代码块，并标注代码语言为以下某一项。以下分类介绍。

#### Simple examples (`example`)

简单 Typst 例子。

````typst
```example
>>> Current: \
#underline[中文和English]

>>> Expected: \
>>> #set underline(offset: .15em, stroke: .05em)
>>> #underline[中文和English]
```
````

- 普通行：

  👀 显示到源代码，并 🚀 执行成预览结果。

- `>>>`打头的行：

  🙈 在源代码中隐藏，但仍然 🚀 执行成预览结果。

- `<<<`打头的行：

  👀 显示到源代码，但 🛑 不会执行成预览结果。

##### 缺点与限制

simple example 执行于容器中，且会在整篇文档中共享状态。

因此：

- 不支持页面设置。

  若只需`#set page(width: …)`，可换用`#show: block.with(width: …)`。

- 更新计数器会影响后续例子。

- 引用与参考文献会与其它例子冲突。

- 设置的默认值会按`raw`，可能与普通文档不同。

  例如，`text.cjk-latin-spacing`一般默认为`auto`，但这里是`none`。

- ……

如需高级功能或 100% 准确，请换用 page example。

#### Page examples (`example-page`)

编译成单独页面的 Typst 例子。

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

`<<<`与`>>>`的意义与 simple example 相同。

#### Bibliography examples (`example-bib`)

参考文献著录例子。

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

- 普通行：BibTeX 项目。

- `%`打头的行：预期输出。

## 许可

除非另有说明，代码按 Apache 2.0 许可。其它内容暂时保留权利。
