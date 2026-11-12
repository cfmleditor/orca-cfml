#!/bin/sh
# Copy the CFML TextMate grammars and language configuration from cfmleditor
# (https://github.com/cfmleditor/cfmleditor, MIT) and record the commit they came from.
#
#   scripts/sync-grammars.sh [path-to-cfmleditor-checkout]
#
# Defaults to a cfmleditor checkout beside this repository.
set -eu
here=$(cd "$(dirname "$0")/.." && pwd)
src=${1:-"$here/../cfmleditor"}
[ -f "$src/syntaxes/cfml.tmLanguage.json" ] || { echo "no cfmleditor checkout at $src" >&2; exit 1; }
# Orca's grammar check allows only numbered keys in a captures map; cfmleditor's
# grammars carry a stray "comment" key in one, which VS Code ignores.
for f in cfml.tmLanguage.json cfml-cfs.tmLanguage.json; do
  # Orca also refuses an include of a repository entry that does not exist, where
  # VS Code matches nothing; cfmleditor's embedded CSS/JS sections name 25 of them.
  jq '(.repository | keys) as $defined
      | walk(if type == "object" then
          with_entries(if (.key | test("^(begin|end|while)?[cC]aptures$")) and (.value | type == "object")
                       then .value |= with_entries(select(.key | test("^[0-9]+$"))) else . end)
          | if (.patterns | type) == "array" then
              .patterns |= map(select((.include? // "") as $i
                | ($i | startswith("#") | not) or ($defined | index($i | ltrimstr("#")))))
            else . end
        else . end)' \
    "$src/syntaxes/$f" > "$here/syntaxes/$f.tmp"
  mv "$here/syntaxes/$f.tmp" "$here/syntaxes/$f"
done
# Orca takes auto-closing and surrounding pairs only as {open, close} objects;
# VS Code also accepts the [open, close] arrays cfmleditor uses.
jq '(.autoClosingPairs, .surroundingPairs) |= map(if type == "array" then {open: .[0], close: .[1]} else . end)' \
  "$src/syntaxes/language-configuration.json" > "$here/syntaxes/language-configuration.json"
rev=$(git -C "$src" rev-parse HEAD)
printf '%s\n' "$rev" > "$here/syntaxes/CFMLEDITOR_REVISION"
echo "synced grammars from cfmleditor $rev"
