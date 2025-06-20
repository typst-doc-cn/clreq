#!/usr/bin/env bash
set -euxo pipefail

mkdir -p fonts
cd fonts

# Noto Serif CJK SC
if ! typst fonts --font-path . | rg --quiet '^Noto Serif CJK SC$'; then
  curl --location --remote-name https://github.com/notofonts/noto-cjk/releases/download/Serif2.003/09_NotoSerifCJKsc.zip
  7z x 09_NotoSerifCJKsc.zip
  rm 09_NotoSerifCJKsc.zip
fi

if ! typst fonts --font-path . | rg --quiet '^Noto Color Emoji$'; then
  curl --location --remote-name https://github.com/googlefonts/noto-emoji/raw/main/fonts/NotoColorEmoji.ttf
fi

# Source Han Serif SC VF
if ! typst fonts --font-path . | rg --quiet '^Source Han Serif SC VF$'; then
  curl --location --remote-name https://mirrors.cernet.edu.cn/adobe-fonts/source-han-serif/Variable/OTF/SourceHanSerifSC-VF.otf
fi

# A specific version of SimSun
if ! typst fonts --font-path . | rg --quiet '^SimSun$'; then
  curl --location --remote-name https://github.com/typst-doc-cn/guide/releases/download/files/fonts.7z
  7z x fonts.7z -ofonts
  rm fonts.7z
fi

# Check
typst fonts --font-path . --ignore-system-fonts

cd -
