import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vscode_codicons_example/main.dart';

void main() {
  Future<void> pumpAt(WidgetTester tester, Size size) async {
    tester.view.physicalSize = size;
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    await tester.pumpWidget(const VSCodeApp());
  }

  testWidgets('renders on a desktop window without errors', (tester) async {
    await pumpAt(tester, const Size(1280, 800));

    expect(find.text('EXPLORER'), findsOneWidget);
    expect(find.text('VSCODE_CODICONS'), findsOneWidget);
    expect(find.text('pubspec.yaml'), findsWidgets); // tab + tree + breadcrumb
    expect(find.text('main'), findsOneWidget); // git branch in status bar
  });

  testWidgets('renders on a phone screen without overflow', (tester) async {
    // A narrow phone would overflow a fixed desktop layout; the shell must
    // fall back to horizontal scrolling instead. tester throws on overflow.
    await pumpAt(tester, const Size(360, 800));

    expect(find.text('EXPLORER'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
