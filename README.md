# orca-cfml

CFML (ColdFusion) syntax highlighting for [Orca](https://onorca.dev), the Orca
counterpart of [zed-cfml](https://github.com/cfmleditor/zed-cfml).

| Language | Files | Grammar scope |
|---|---|---|
| CFML | `.cfm`, `.cfml`, `.cfc` | `embedding.cfml` |
| CFScript | `.cfs` | `embedding.cfml.cfs` |

Tag templates, script and tag components, `#...#` interpolation, and the CSS,
JavaScript and SQL embedded in them are highlighted.

## What this does not do (yet)

zed-cfml also starts the [clif](https://github.com/cfmleditor/clif) language
server and highlights with the tree-sitter-cfml grammar. Orca's plugin API (manifest
v2, Orca 1.4.256) has neither: a plugin may contribute TextMate `syntaxes`, themes,
icons, panels, custom editors, commands and hooks, but no language server and no
tree-sitter grammar. So this plugin is highlighting only, with the TextMate grammars
from [cfmleditor](https://github.com/cfmleditor/cfmleditor). When Orca adds a
language-server contribution point, clif can be wired in here the way zed-cfml does it.

## Install

From a checkout:

```sh
orca plugin install .
```

Once the repository is public with the GitHub topic `orca-plugin`, it is listed in
the [community catalog](https://github.com/stablyai/orca-community-plugins) and can
be installed from Settings → Plugins.

## Develop

```sh
orca plugin validate .
orca plugin dev watch .   # load into Orca, stream logs and reloads; Ctrl-C unloads
```

`samples/` holds files to open while checking the highlighting.

### Updating the grammars

The grammars are copied from cfmleditor, never edited here:

```sh
scripts/sync-grammars.sh [path-to-cfmleditor]   # defaults to ../cfmleditor
```

The commit they came from is recorded in `syntaxes/CFMLEDITOR_REVISION`. The script
makes two mechanical changes Orca's stricter loader needs, which VS Code does not:
`autoClosingPairs` and `surroundingPairs` become `{open, close}` objects, and the one
non-numbered key in a `captures` map (a `comment`) is dropped. Run
`orca plugin validate .` afterwards.

## License

[MIT](LICENSE). The grammars and language configuration are from cfmleditor, MIT,
Copyright (c) 2017 KamasamaK; that notice is in [LICENSE](LICENSE).
