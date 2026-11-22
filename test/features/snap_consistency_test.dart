import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

import '../common/test_app_harness.dart';

Widget _list(BuildContext context, ScrollController scrollController) {
  return ListView(
    controller: scrollController,
    children: List.generate(50, (index) => Text('Item $index')),
  );
}

void main() {
  group('Snap consistency', () {
    testWidgets('forwards snap configuration to DraggableScrollableSheet', (
      WidgetTester tester,
    ) async {
      const duration = Duration(milliseconds: 450);
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            snap: true,
            snapAnimationDuration: duration,
            shouldCloseOnMinExtent: false,
            builder: _list,
          ),
        ),
      );

      final sheet = tester.widget<DraggableScrollableSheet>(
        find.byType(DraggableScrollableSheet),
      );
      expect(sheet.snapAnimationDuration, duration);
      expect(sheet.shouldCloseOnMinExtent, isFalse);
    });

    testWidgets('onSnap fires when the content drag snaps the sheet', (
      WidgetTester tester,
    ) async {
      final snapped = <double>[];
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [0.5],
            onSnap: snapped.add,
            builder: _list,
          ),
        ),
      );

      // Drag the content (not the grabber) close to 0.5, then hold still
      // before releasing so it is not treated as a fling.
      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Item 1')),
      );
      for (var i = 0; i < 10; i++) {
        await gesture.moveBy(const Offset(0, -15));
        await tester.pump(const Duration(milliseconds: 16));
      }
      await tester.pump(const Duration(milliseconds: 500));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(snapped, [closeTo(0.5, 0.01)]);
    });

    testWidgets('grabber fling moves to the adjacent snap point', (
      WidgetTester tester,
    ) async {
      final snapped = <double>[];
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            snap: true,
            snapSizes: const [0.5],
            onSnap: snapped.add,
            builder: _list,
          ),
        ),
      );

      await tester.fling(
        find.byKey(const Key('grabber')),
        const Offset(0, -60),
        1500,
      );
      await tester.pumpAndSettle();

      expect(snapped, [closeTo(0.5, 0.01)]);
    });

    testWidgets('onSnap is not repeated for the same snap point', (
      WidgetTester tester,
    ) async {
      final snapped = <double>[];
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            snap: true,
            onSnap: snapped.add,
            builder: _list,
          ),
        ),
      );

      await tester.drag(
        find.byKey(const Key('grabber')),
        const Offset(0, -300),
      );
      await tester.pumpAndSettle();

      expect(snapped, [closeTo(0.9, 0.01)]);
    });
  });
}
