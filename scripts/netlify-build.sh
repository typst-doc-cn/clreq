#!/usr/bin/env bash
set -euxo pipefail

TYPST_VERSION=$(jq . scripts/typst-version.json --raw-output)

curl -L --proto '=https' --tlsv1.2 -sSf https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash
cargo-binstall "typst-cli@$TYPST_VERSION" ripgrep
# Remarks: `cargo-binstall` works, but `cargo binstall` does not.

curl -OL https://www.7-zip.org/a/7z2409-linux-x64.tar.xz
tar -xvf 7z2409-linux-x64.tar.xz 7zz && ln -s 7zz 7z
export PATH=$PATH:$(pwd)

bash scripts/download_fonts.sh

pnpm install
pnpm build

pnpm patch-htmldiff
