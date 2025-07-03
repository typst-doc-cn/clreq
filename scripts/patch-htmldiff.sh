#!/usr/bin/env bash
set -euxo pipefail

# Patch htmldiff
#
# https://services.w3.org/htmldiff is running `htmldiff` (the python script),
# and it will execute `htmldiff.pl` in CLI (rather than CGI) mode.
#
# The commit version might be the following:
# https://github.com/w3c/htmldiff-ui/blob/5eac9b073c66b24422df613a537da2ec2f97f457/htmldiff.pl


# Improve readability for `<pre>`.
#
# This is a bug of htmldiff.
#
# When `<pre>` and `</pre>` is on the same line, `splitit` should set `$preformatted` to true, but not.
# https://github.com/w3c/htmldiff-ui/blob/main/htmldiff.pl#L406-L412
#
# Additionally, `markit` will drop all characters after `<` for deleted (or replaced) lines.
# As a result, htmldiff does not work as expected even if `$preformatted` has been set to true`.
# https://github.com/w3c/htmldiff-ui/blob/5eac9b073c66b24422df613a537da2ec2f97f457/htmldiff.pl#L167-L168
#
# Therefore, let us ignore it…
sd --fixed-strings "</head>" '<script>
  if (
    window.location.origin + window.location.pathname ===
      "https://services.w3.org/htmldiff"
  ) {
    const style = document.createElement("style")
    style.textContent = `
      pre {
        white-space: normal;
      }
    `
    document.head.appendChild(style)
  }
</script>
</head>' dist/index.html
