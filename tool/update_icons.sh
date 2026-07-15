#!/usr/bin/env bash
#
# Upgrade the @vscode/codicons dependency and regenerate the Flutter icon set.
#
# Shared by the `merry update-icons` developer script and the
# `.github/workflows/update-icons.yml` automation so the regeneration steps
# live in exactly one place.
#
# Usage:
#   tool/update_icons.sh            # upgrade to the latest @vscode/codicons release
#   tool/update_icons.sh 0.0.45     # pin a specific @vscode/codicons version
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT}"

version_spec="${1:-latest}"

# 1. Upgrade the @vscode/codicons npm dependency.
pnpm add "@vscode/codicons@${version_spec}"

# 2. Copy the generated font assets out of node_modules.
cp 'node_modules/@vscode/codicons/dist/codicon.css' assets/codicon.css
cp 'node_modules/@vscode/codicons/dist/codicon.ttf' assets/codicon.ttf

# 3. Regenerate lib/codicons.dart with inline SVG dartdoc previews.
#    Per-icon SVGs ship in src/icons; alias selectors (e.g. .codicon-plus for
#    add) have no SVG file of their own, so their previews fall back to the
#    GitHub raw URL and may fail — the constants still work (same codepoint).
dart run tool/generate_fonts.dart assets/codicon.css \
	--inline-svg \
	--npm-package=@vscode/codicons \
	--font-family=Codicon \
	--font-package=codicons \
	--class-name=Codicons \
	--css-prefix=codicon- \
	--docs-url='https://github.com/microsoft/vscode-codicons/search?q=' \
	--output=./lib/codicons.dart \
	--svg-dir=node_modules/@vscode/codicons/src/icons \
	--svg-fallback-url=https://raw.githubusercontent.com/microsoft/vscode-codicons/main/src/icons

# 4. Format so the committed file honours analysis_options.yaml page_width (80).
#    The generator emits unwrapped lines; without this the diff is noisy and
#    long-line lints trip. Keeps merry and CI regeneration byte-identical.
dart format lib/codicons.dart
