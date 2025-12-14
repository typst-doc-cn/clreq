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

# Noto Color Emoji, the CBDT/CBLC version
# See https://github.com/typst/typst/issues/6611 for reasons.
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

# MOESongUN
if ! typst fonts --font-path . | rg --quiet '^MOESongUN$'; then
  curl --location --remote-name https://language.moe.gov.tw/001/Upload/Files/site_content/M0001/eduSong_Unicode.zip
  7z x eduSong_Unicode.zip -ofonts
  rm eduSong_Unicode.zip
  # The original filename in the zip has (2024年12月) encoded in Big5, resulting in garbage characters.
  mv fonts/eduSong_Unicode*.ttf 'fonts/eduSong_Unicode(2024年12月).ttf'
fi

# Check
typst fonts --font-path . --ignore-system-fonts

cd -
