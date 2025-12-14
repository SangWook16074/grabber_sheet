import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';
import '../common/test_app_harness.dart';

void main() {
  group('State Callbacks', () {
    testWidgets('onSizeChanged is called when sheet is dragged',
        (WidgetTester tester) async {
      double? lastSize;
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            onSizeChanged: (size) {
              lastSize = size;
            },
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [
                  SizedBox(height: 2000, child: Text('Content'))
                ],
              );
            },
          ),
        ),
      );

      // Drag up
      await tester.drag(
          find.byKey(const Key('grabber')), const Offset(0, -100));
      await tester.pump();

      expect(lastSize, isNotNull);
      expect(lastSize, greaterThan(0.5));
    });

    testWidgets('onSnap is called when sheet snaps',
        (WidgetTester tester) async {
      double? snappedSize;
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            snap: true,
            onSnap: (size) {
              snappedSize = size;
            },
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [
                  SizedBox(height: 2000, child: Text('Content'))
                ],
              );
            },
          ),
        ),
      );

      // Drag quickly to trigger snap to max
      // Use a large enough offset to ensure we pass the threshold
      await tester.drag(
          find.byKey(const Key('grabber')), const Offset(0, -300));
      await tester.pump(); // Trigger drag end

      // Wait for animation (300ms) and the delayed callback
      await tester.pump(const Duration(milliseconds: 400));

      expect(snappedSize, isNotNull);
      expect(snappedSize, closeTo(0.9, 0.01));
    });
  });
}
