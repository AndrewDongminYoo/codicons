import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:vscode_codicons/vscode_codicons.dart';

/// Minimum layout width. On narrower screens (phones) the whole VS Code
/// chrome scrolls horizontally instead of overflowing.
const double _kMinWidth = 900;

void main() => runApp(const VSCodeApp());

/// VS Code color palette (Dark+ theme approximation).
class VSC {
  static const bg = Color(0xFF1E1E1E); // editor background
  static const sidebar = Color(0xFF252526); // side bar background
  static const activityBar = Color(0xFF333333); // activity bar
  static const statusBar = Color(0xFF007ACC); // status bar (focused)
  static const tabActive = Color(0xFF1E1E1E);
  static const tabInactive = Color(0xFF2D2D2D);
  static const fg = Color(0xFFCCCCCC); // default text
  static const fgDim = Color(0xFF858585); // muted text
  static const accent = Color(0xFF007ACC);
  static const gitModified = Color(0xFFE2C08D);
}

class VSCodeApp extends StatelessWidget {
  const VSCodeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'VS Code (Codicons demo)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        useMaterial3: true,
      ).copyWith(scaffoldBackgroundColor: VSC.bg),
      home: const VSCodeShell(),
    );
  }
}

/// The overall VS Code window: activity bar, side bar, editor, status bar.
class VSCodeShell extends StatelessWidget {
  const VSCodeShell({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          final width = math.max(constraints.maxWidth, _kMinWidth);
          return SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: width,
              height: constraints.maxHeight,
              child: const Column(
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        _ActivityBar(),
                        SizedBox(width: 300, child: _Explorer()),
                        Expanded(child: _EditorArea()),
                      ],
                    ),
                  ),
                  _StatusBar(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Left-most vertical strip of icons.
class _ActivityBar extends StatelessWidget {
  const _ActivityBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 48,
      color: VSC.activityBar,
      child: const Column(
        children: [
          _ActivityIcon(Codicons.files, active: true),
          _ActivityIcon(Codicons.search),
          _ActivityIcon(Codicons.sourceControl, badge: '3'),
          _ActivityIcon(Codicons.debugAlt),
          _ActivityIcon(Codicons.extensions),
          Spacer(),
          _ActivityIcon(Codicons.account),
          _ActivityIcon(Codicons.settingsGear),
        ],
      ),
    );
  }
}

class _ActivityIcon extends StatelessWidget {
  const _ActivityIcon(this.icon, {this.active = false, this.badge});

  final IconData icon;
  final bool active;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (active)
            const Align(
              alignment: Alignment.centerLeft,
              child: SizedBox(
                width: 2,
                height: 48,
                child: ColoredBox(color: Colors.white),
              ),
            ),
          Icon(icon, size: 24, color: active ? Colors.white : VSC.fgDim),
          if (badge != null)
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: const BoxDecoration(
                  color: VSC.accent,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                child: Text(
                  badge!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 9,
                    height: 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Explorer side bar with a file tree.
class _Explorer extends StatelessWidget {
  const _Explorer();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: VSC.sidebar,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Panel header row.
          const Padding(
            padding: EdgeInsets.fromLTRB(20, 12, 8, 8),
            child: Row(
              children: [
                Text(
                  'EXPLORER',
                  style: TextStyle(
                    color: VSC.fgDim,
                    fontSize: 11,
                    letterSpacing: 0.5,
                  ),
                ),
                Spacer(),
                Icon(Codicons.ellipsis, size: 16, color: VSC.fgDim),
              ],
            ),
          ),
          // Project root header with action icons.
          Container(
            color: const Color(0xFF37373D),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: const Row(
              children: [
                Icon(Codicons.chevronDown, size: 16, color: VSC.fg),
                SizedBox(width: 2),
                Flexible(
                  child: Text(
                    'VSCODE_CODICONS',
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: VSC.fg,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Spacer(),
                Icon(Codicons.newFile, size: 16, color: VSC.fgDim),
                SizedBox(width: 8),
                Icon(Codicons.newFolder, size: 16, color: VSC.fgDim),
                SizedBox(width: 8),
                Icon(Codicons.refresh, size: 16, color: VSC.fgDim),
                SizedBox(width: 8),
                Icon(Codicons.collapseAll, size: 16, color: VSC.fgDim),
              ],
            ),
          ),
          const Expanded(child: _FileTree()),
        ],
      ),
    );
  }
}

class _FileTree extends StatelessWidget {
  const _FileTree();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: const [
        _TreeRow(
          icon: Codicons.chevronDown,
          label: 'lib',
          depth: 1,
          folder: true,
        ),
        _TreeRow(
          icon: Codicons.symbolFile,
          label: 'vscode_codicons.dart',
          depth: 2,
        ),
        _TreeRow(
          icon: Codicons.chevronRight,
          label: 'test',
          depth: 1,
          folder: true,
        ),
        _TreeRow(
          icon: Codicons.chevronRight,
          label: 'tool',
          depth: 1,
          folder: true,
        ),
        _TreeRow(icon: Codicons.file, label: '.gitignore', depth: 1, git: 'M'),
        _TreeRow(icon: Codicons.markdown, label: 'CHANGELOG.md', depth: 1),
        _TreeRow(
          icon: Codicons.json,
          label: 'pubspec.yaml',
          depth: 1,
          git: 'M',
          selected: true,
        ),
        _TreeRow(icon: Codicons.markdown, label: 'README.md', depth: 1),
      ],
    );
  }
}

class _TreeRow extends StatelessWidget {
  const _TreeRow({
    required this.icon,
    required this.label,
    required this.depth,
    this.folder = false,
    this.selected = false,
    this.git,
  });

  final IconData icon;
  final String label;
  final int depth;
  final bool folder;
  final bool selected;
  final String? git;

  @override
  Widget build(BuildContext context) {
    final labelColor = git != null ? VSC.gitModified : VSC.fg;
    return Container(
      color: selected ? const Color(0xFF094771) : null,
      padding: EdgeInsets.only(
        left: 8.0 + depth * 12,
        right: 8,
        top: 3,
        bottom: 3,
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: folder ? VSC.fg : VSC.fgDim),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              label,
              style: TextStyle(color: labelColor, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (git != null)
            Text(
              git!,
              style: const TextStyle(color: VSC.gitModified, fontSize: 12),
            ),
        ],
      ),
    );
  }
}

/// The editor: tab strip, breadcrumbs, and a code sample.
class _EditorArea extends StatelessWidget {
  const _EditorArea();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _TabStrip(),
        _Breadcrumbs(),
        Expanded(child: _CodeSample()),
      ],
    );
  }
}

class _TabStrip extends StatelessWidget {
  const _TabStrip();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 35,
      color: VSC.tabInactive,
      child: const Row(
        children: [
          _Tab(icon: Codicons.json, label: 'pubspec.yaml', active: true),
          _Tab(icon: Codicons.symbolFile, label: 'main.dart'),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  const _Tab({required this.icon, required this.label, this.active = false});

  final IconData icon;
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: active ? VSC.tabActive : VSC.tabInactive,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          Icon(icon, size: 16, color: VSC.fgDim),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(color: active ? VSC.fg : VSC.fgDim, fontSize: 13),
          ),
          const SizedBox(width: 8),
          Icon(
            active ? Codicons.close : Codicons.circleFilled,
            size: active ? 16 : 8,
            color: VSC.fgDim,
          ),
        ],
      ),
    );
  }
}

class _Breadcrumbs extends StatelessWidget {
  const _Breadcrumbs();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      alignment: Alignment.centerLeft,
      child: const Row(
        children: [
          Text(
            'vscode_codicons',
            style: TextStyle(color: VSC.fgDim, fontSize: 12),
          ),
          Icon(Codicons.chevronRight, size: 14, color: VSC.fgDim),
          Text(
            'pubspec.yaml',
            style: TextStyle(color: VSC.fgDim, fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _CodeSample extends StatelessWidget {
  const _CodeSample();

  static const _lines = <String>[
    'name: vscode_codicons',
    'description: The VS Code Codicons icon library.',
    'version: 0.0.45',
    '',
    'environment:',
    '  sdk: ">=3.8.0 <4.0.0"',
    '',
    'flutter:',
    '  fonts:',
    '    - family: Codicon',
    '      fonts:',
    '        - asset: assets/codicon.ttf',
  ];

  @override
  Widget build(BuildContext context) {
    // Code scrolls both ways, like the real editor: vertically for lines,
    // horizontally for lines wider than the editor pane.
    return ColoredBox(
      color: VSC.bg,
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (var i = 0; i < _lines.length; i++)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 48,
                      child: Text(
                        '${i + 1}',
                        textAlign: TextAlign.right,
                        style: const TextStyle(
                          color: VSC.fgDim,
                          fontSize: 13,
                          fontFamily: 'monospace',
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Text(
                      _lines[i],
                      style: const TextStyle(
                        color: VSC.fg,
                        fontSize: 13,
                        fontFamily: 'monospace',
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom status bar.
class _StatusBar extends StatelessWidget {
  const _StatusBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 22,
      color: VSC.statusBar,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: const Row(
        children: [
          _StatusItem(icon: Codicons.remote),
          _StatusItem(icon: Codicons.gitBranch, label: 'main'),
          _StatusItem(icon: Codicons.sync),
          _StatusItem(icon: Codicons.error, label: '0'),
          _StatusItem(icon: Codicons.warning, label: '0'),
          Spacer(),
          _StatusItem(label: 'Ln 3, Col 18'),
          _StatusItem(label: 'Spaces: 2'),
          _StatusItem(label: 'UTF-8'),
          _StatusItem(icon: Codicons.json, label: 'YAML'),
          _StatusItem(icon: Codicons.bell),
        ],
      ),
    );
  }
}

class _StatusItem extends StatelessWidget {
  const _StatusItem({this.icon, this.label});

  final IconData? icon;
  final String? label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        children: [
          if (icon != null) Icon(icon, size: 14, color: Colors.white),
          if (icon != null && label != null) const SizedBox(width: 4),
          if (label != null)
            Text(
              label!,
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
        ],
      ),
    );
  }
}
