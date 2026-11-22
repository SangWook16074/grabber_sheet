import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/raw_grabber_sheet.dart';

/// Files that make up the widgets-only layer exposed by
/// `package:grabber_sheet/raw_grabber_sheet.dart`.
const _widgetsLayerFiles = [
  'lib/raw_grabber_sheet.dart',
  'lib/src/raw_grabber_sheet.dart',
  'lib/src/grabber_style.dart',
  'lib/src/grabber_sheet_controller.dart',
];

/// Design system libraries the widgets layer must not import.
const _designLibraries = [
  'package:flutter/material.dart',
  'package:flutter/cupertino.dart',
  'package:material_ui/',
  'package:cupertino_ui/',
];

Widget _widgetsOnlyApp(Widget child) {
  return WidgetsApp(
    color: const Color(0xFF000000),
    builder: (context, _) => child,
  );
}

void main() {
  group('Widgets layer', () {
    test('does not import Material or Cupertino', () {
      for (final path in _widgetsLayerFiles) {
        final source = File(path).readAsStringSync();
        for (final library in _designLibraries) {
          expect(
            source,
            isNot(contains(library)),
            reason: '$path must not depend on $library',
          );
        }
      }
    });

    testWidgets('RawGrabberSheet renders without MaterialApp', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        _widgetsOnlyApp(
          RawGrabberSheet(
            backgroundColor: const Color(0xFFFFFFFF),
            header: const Text('Header'),
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [Text('Content')],
              );
            },
          ),
        ),
      );

      expect(find.byKey(const Key('grabber')), findsOneWidget);
      expect(find.text('Header'), findsOneWidget);
      expect(find.text('Content'), findsOneWidget);
    });

    testWidgets('RawGrabberSheet can be resized by dragging the grabber', (
      WidgetTester tester,
    ) async {
      double? lastSize;
      await tester.pumpWidget(
        _widgetsOnlyApp(
          RawGrabberSheet(
            backgroundColor: const Color(0xFFFFFFFF),
            onSizeChanged: (size) => lastSize = size,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [Text('Content')],
              );
            },
          ),
        ),
      );

      await tester.drag(
        find.byKey(const Key('grabber')),
        const Offset(0, -100),
      );
      await tester.pump();

      expect(lastSize, greaterThan(0.5));
    });
  });
}
