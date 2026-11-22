import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';
import 'package:material_ui/material_ui.dart';

import '../common/test_app_harness.dart';

Widget _sheet({
  bool toggleOnGrabberTap = false,
  ValueChanged<double>? onSizeChanged,
}) {
  return TestAppHarness(
    child: GrabberSheet(
      initialChildSize: 0.5,
      minChildSize: 0.25,
      maxChildSize: 1.0,
      toggleOnGrabberTap: toggleOnGrabberTap,
      onSizeChanged: onSizeChanged,
      builder: (context, scrollController) {
        return ListView(
          controller: scrollController,
          children: const [Text('Content')],
        );
      },
    ),
  );
}

void main() {
  group('Grabber interaction', () {
    testWidgets('tapping the grabber toggles when enabled', (
      WidgetTester tester,
    ) async {
      double size = 0.5;
      await tester.pumpWidget(
        _sheet(
          toggleOnGrabberTap: true,
          onSizeChanged: (value) => size = value,
        ),
      );

      await tester.tap(find.byKey(const Key('grabber')));
      await tester.pumpAndSettle();
      expect(size, closeTo(1.0, 0.01));

      await tester.tap(find.byKey(const Key('grabber')));
      await tester.pumpAndSettle();
      expect(size, closeTo(0.25, 0.01));
    });

    testWidgets('tapping the grabber does nothing by default', (
      WidgetTester tester,
    ) async {
      double size = 0.5;
      await tester.pumpWidget(_sheet(onSizeChanged: (value) => size = value));

      await tester.tap(find.byKey(const Key('grabber')));
      await tester.pumpAndSettle();
      expect(size, 0.5);
    });

    testWidgets('arrow keys resize the focused grabber', (
      WidgetTester tester,
    ) async {
      double size = 0.5;
      await tester.pumpWidget(_sheet(onSizeChanged: (value) => size = value));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.pumpAndSettle();
      expect(size, closeTo(1.0, 0.01));

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pumpAndSettle();
      expect(size, closeTo(0.25, 0.01));
    });

    testWidgets('Enter and Space toggle the focused grabber when enabled', (
      WidgetTester tester,
    ) async {
      double size = 0.5;
      await tester.pumpWidget(
        _sheet(
          toggleOnGrabberTap: true,
          onSizeChanged: (value) => size = value,
        ),
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(size, closeTo(1.0, 0.01));

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(size, closeTo(0.25, 0.01));
    });

    testWidgets('arrow keys stay within the min and max sizes', (
      WidgetTester tester,
    ) async {
      double size = 0.5;
      await tester.pumpWidget(_sheet(onSizeChanged: (value) => size = value));

      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pump();
      for (var i = 0; i < 2; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
        await tester.pumpAndSettle();
      }
      expect(size, closeTo(1.0, 0.01));

      for (var i = 0; i < 3; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
        await tester.pumpAndSettle();
      }
      expect(size, closeTo(0.25, 0.01));
    });

    testWidgets('the grabber area is at least 48 logical pixels tall', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(_sheet(toggleOnGrabberTap: true));

      final Finder grabberArea = find.ancestor(
        of: find.byKey(const Key('grabber')),
        matching: find.byType(GestureDetector),
      );
      expect(tester.getSize(grabberArea.first).height, 48.0);
    });

    testWidgets('the grabber is not exposed to screen readers', (
      WidgetTester tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpWidget(_sheet(toggleOnGrabberTap: true));

      final data = tester
          .getSemantics(find.byKey(const Key('grabber')))
          .getSemanticsData();
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      expect(data.hasAction(SemanticsAction.increase), isFalse);
      expect(data.hasAction(SemanticsAction.decrease), isFalse);
      expect(find.bySemanticsLabel('Drag handle'), findsNothing);
      handle.dispose();
    });
  });
}
