# vscode_codicons

The [VS Code Codicons](https://github.com/microsoft/vscode-codicons) icon library as a Flutter icon font.
Provides 500+ product icons from Visual Studio Code as a single icon font, generated from the [@vscode/codicons](https://www.npmjs.com/package/@vscode/codicons) npm package.

The package version tracks the upstream `@vscode/codicons` release it was generated from.

## Usage

```dart
import 'package:vscode_codicons/vscode_codicons.dart';

Icon(Codicons.add);
Icon(Codicons.gitPullRequest, size: 32, color: Colors.teal);
```

Icon names are the upstream CSS class names (`codicon-git-pull-request`) converted to lowerCamelCase (`gitPullRequest`).
Upstream alias classes (e.g. `codicon-plus` for `codicon-add`) each get their own constant sharing the same codepoint.

## Updating icons

```bash
bash tool/update_icons.sh          # latest @vscode/codicons release
bash tool/update_icons.sh 0.0.45   # pin a specific version
```

A daily GitHub Actions workflow (`.github/workflows/update-icons.yml`) regenerates the icon set and opens a PR when a new upstream release is published.

## License

The bundled Codicon icons and font are © Microsoft Corporation, licensed under [CC-BY-4.0](LICENSE) (upstream `LICENSE`).
Upstream code is MIT-licensed (upstream `LICENSE-CODE`).
