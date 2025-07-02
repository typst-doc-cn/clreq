#!/usr/bin/env bash
set -euxo pipefail

# Patch htmldiff
#
# https://services.w3.org/htmldiff is running `htmldiff` (the python script),
# and it will execute `htmldiff.pl` in CLI (rather than CGI) mode.
#
# The commit version might be the following:
# https://github.com/w3c/htmldiff-ui/blob/5eac9b073c66b24422df613a537da2ec2f97f457/htmldiff.pl

# Set base.
# Otherwise, CSS & JS will go to services.w3.org.
#
# This CGI-mode feature is missing in CLI mode.
# https://github.com/w3c/htmldiff-ui/blob/5eac9b073c66b24422df613a537da2ec2f97f457/htmldiff.pl#L560-L563
if [[ "${NETLIFY:-false}" == "true" ]]; then
  sd --fixed-strings "<head>" "<head><base href='$DEPLOY_URL/'>" dist/index.html
fi

# Ensure at least one newline before every `</pre>`.
#
# This is a bug.
# When `<pre>` and `</pre>` is on the same line, `splitit` should set `$preformatted` to true, but not.
# https://github.com/w3c/htmldiff-ui/blob/main/htmldiff.pl#L406-L412
sd --fixed-strings "</pre>" $'\n</pre>' dist/index.html
