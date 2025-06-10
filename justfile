PYTHON := "python"
export TYPST_FEATURES := "html"
export TYPST_FONT_PATHS := justfile_directory() + "/fonts"

# List available recipes
@default:
    just --list

# Setup directories, check dependencies, etc.
[private]
@setup:
    typst --version
    {{ PYTHON }} --version
    mkdir -p dist

# Compile the document into HTML
compile: setup
    {{ PYTHON }} examples/compile.py
    typst compile index.typ dist/index.html

alias c := compile

# Watches the document and recompiles on changes
watch: setup
    {{ PYTHON }} examples/compile.py
    typst watch index.typ dist/index.html

alias w := watch

# Watches examples and recompiles on changes (require https://watchexec.github.io)
watch-examples: setup
    watchexec {{ PYTHON }} examples/compile.py
