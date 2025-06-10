"""Compile external examples in `main.typ` to `main.cached.typ`.

# Example usage

Create `examples/thesis.bib`, and add the following to `main.typ`.

```typst
#include "examples/thesis.bib.example.typ" // @as-example
```

Then `just compile`.

# Known issues

`#include` must be put at the line start. Indentation is not supported.
"""

import re
from collections.abc import Generator
from dataclasses import dataclass
from functools import cache
from pathlib import Path
from subprocess import CalledProcessError, run
from typing import Literal, Self

PREAMBLE = (
    """
// Some browsers hide the border. Therefore, the margin is necessary.
#set page(width: auto, height: auto, margin: 0.5em, fill: none)
// Make it reproducible.
#set text(font: ((name: "New Computer Modern", covers: "latin-in-cjk"), "Noto Serif CJK SC"), fallback: false)
""".strip()
    + "\n"
)
# This preamble is different from that of ../typ/util.typ, due to different mechanisms of compilation,


def compile_example(entry_point: Path) -> Path:
    """Compile an example to SVG."""
    example = Example.from_file(entry_point)
    preview = typst_compile(example.executed)

    result_file = entry_point.with_name(entry_point.name + ".example.typ")
    result_file.write_text(
        layout_example(example.displayed, example.lang, preview), encoding="utf-8"
    )

    return result_file


def compile_examples_in_document(doc: Path) -> Generator[Path, None, None]:
    """Compile all examples in a document."""
    root = doc.parent
    doc_content = doc.read_text(encoding="utf-8")

    pattern = re.compile(
        r'^#include\s+"([^"]+)\.example\.typ"\s*//\s*@as-example$', flags=re.MULTILINE
    )

    for match in pattern.findall(doc_content):
        entry_point = root / match
        yield compile_example(entry_point)


@dataclass
class Example:
    displayed: str
    executed: str
    lang: Literal["typ"] | Literal["bib"]

    @classmethod
    def from_file(cls, file: Path) -> Self:
        """Parse an example from file."""
        assert file.exists() and file.is_file()

        lang = file.suffix.removeprefix(".")
        src = file.read_text(encoding="utf-8")

        match lang:
            case "typ":
                return cls.from_typ(src)
            case "bib":
                return cls.from_bib(src)
            case _:
                raise ValueError(f"Unsupported file type: {lang}.")

    @classmethod
    def from_typ(cls, src: str) -> Self:
        """Parse a typst example.

        `<<<` and `>>>` will be treated according to `tidy.show-example.show-example`.
        """
        rows = src.splitlines()
        return cls(
            lang="typ",
            displayed="\n".join(
                r.removeprefix("<<<") for r in rows if not r.startswith(">>>")
            ),
            executed="\n".join(
                r.removeprefix(">>>") for r in rows if not r.startswith("<<<")
            ),
        )

    @classmethod
    def from_bib(cls, src: str) -> Self:
        """Parse a BibTeX example.

        All comments will be treated as the expected output.
        """
        rows = src.splitlines()
        displayed = "\n".join(r for r in rows if not r.startswith("%"))
        expected = "\n".join(
            "+ " + r.removeprefix("%").strip() for r in rows if r.startswith("%")
        )
        return cls(
            lang="bib",
            displayed=displayed,
            executed=f"""
                #set page(width: 30em)
                
                Current:

                #bibliography(
                  bytes(```{displayed}```.text),
                  style: "gb-7714-2015-numeric",
                  title: none,
                  full: true,
                )

                Expected:

                #set enum(numbering: "[1]")
                {expected}
                """,
        )


def as_image(svg: bytes) -> str:
    """Make an SVG embeddable into typst code."""
    return f"image(bytes(`{svg.decode()}`.text))"


def layout_example(code: str, lang: str, preview: bytes) -> str:
    """Layout an example."""
    return f"""
#import "../typ/util.typ": layout-example

#layout-example(
  ```{lang}
  {code}
  ```,
  {as_image(preview)},
)
""".strip()


@cache
def typst_compile(
    typ: str,
    *,
    preamble=PREAMBLE,
    format="svg",
    cwd: Path | None = None,
) -> bytes:
    """Compile a Typst document."""
    try:
        return run(
            ["typst", "compile", "-", "-", "--format", format],
            input=(preamble + typ).encode(),
            check=True,
            capture_output=True,
            cwd=cwd,
        ).stdout
    except CalledProcessError as err:
        raise RuntimeError(
            f"""
Failed to compile a typst document:

```typst
{typ}
```

{err.stderr.decode()}
""".strip()
        )


if __name__ == "__main__":
    root_dir = Path(__file__).parent.parent
    main_typ = root_dir / "main.typ"
    for entry_point in compile_examples_in_document(main_typ):
        print(f"✅ {entry_point.relative_to(root_dir).as_posix()}")
