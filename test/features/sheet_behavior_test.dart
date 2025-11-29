import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

import '../common/test_app_harness.dart';

void main() {
  testWidgets('renders bottom widget when provided', (
    WidgetTester tester,
  ) async {
    // Given
    const bottomWidget = Text('Bottom Widget');
    await tester.pumpWidget(
      TestAppHarness(
        child: GrabberSheet(
          bottom: bottomWidget,
          builder: (context, scrollController) {
            return ListView(
              controller: scrollController,
              children: const [Text('Content')],
            );
          },
        ),
      ),
    );

    // Then
    expect(find.byWidget(bottomWidget), findsOneWidget);
    expect(find.text('Bottom Widget'), findsOneWidget);
  });

  group('Snap animation tests', () {
    testWidgets(
        'sheet should snap to maxChildSize when dragged upwards and snap is true',
        (WidgetTester tester) async {
      // Given
      double currentSize = 0.0;
      const minSize = 0.3;
      const maxSize = 0.9;

      await tester.pumpWidget(
        TestAppHarness(
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              currentSize = notification.extent;
              return true;
            },
            child: GrabberSheet(
              minChildSize: minSize,
              maxChildSize: maxSize,
              initialChildSize: minSize,
              snap: true,
              builder: (context, scrollController) {
                return ListView(
                  controller: scrollController,
                  children: const [Text('Content')],
                );
              },
            ),
          ),
        ),
      );

      // When
      await tester.drag(
          find.byKey(const Key('grabber')), const Offset(0, -200));
      await tester.pumpAndSettle(); // Wait for snap animation to finish

      // Then
      expect(currentSize, closeTo(maxSize, 0.01));
    });

    testWidgets(
        'sheet should snap to minChildSize when dragged downwards and snap is true',
        (WidgetTester tester) async {
      // Given
      double currentSize = 0.0;
      const minSize = 0.3;
      const maxSize = 0.9;

      await tester.pumpWidget(
        TestAppHarness(
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              currentSize = notification.extent;
              return true;
            },
            child: GrabberSheet(
              minChildSize: minSize,
              maxChildSize: maxSize,
              initialChildSize: maxSize, // Start from max size
              snap: true,
              builder: (context, scrollController) {
                return ListView(
                  controller: scrollController,
                  children: const [Text('Content')],
                );
              },
            ),
          ),
        ),
      );

      // When
      await tester.drag(find.byKey(const Key('grabber')), const Offset(0, 200));
      await tester.pumpAndSettle(); // Wait for snap animation to finish

      // Then
      expect(currentSize, closeTo(minSize, 0.01));
    });
  });
}
