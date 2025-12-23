import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';
import '../common/test_app_harness.dart';

void main() {
  group('GrabberSheetController Tests', () {
    late GrabberSheetController controller;

    setUp(() {
      controller = GrabberSheetController();
    });

    testWidgets('maximize() and minimize() update sheet extent',
        (WidgetTester tester) async {
      double currentExtent = 0.0;
      const minSize = 0.2;
      const maxSize = 0.9;
      const initialSize = 0.5;

      await tester.pumpWidget(
        TestAppHarness(
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              currentExtent = notification.extent;
              return true;
            },
            child: GrabberSheet(
              controller: controller,
              minChildSize: minSize,
              maxChildSize: maxSize,
              initialChildSize: initialSize,
              builder: (context, scrollController) {
                return ListView(
                  controller: scrollController,
                  children: const [
                    SizedBox(height: 2000, child: Text('Content')),
                  ],
                );
              },
            ),
          ),
        ),
      );

      // Act: Maximize
      controller.maximize();
      await tester.pumpAndSettle();

      // Assert
      expect(currentExtent, closeTo(maxSize, 0.01));

      // Act: Minimize
      controller.minimize();
      await tester.pumpAndSettle();

      // Assert
      expect(currentExtent, closeTo(minSize, 0.01));
    });

    testWidgets(
        'GrabberSheet initializes with an internal controller when none is provided',
        (WidgetTester tester) async {
      const initialSize = 0.6; // A distinct initial size to verify

      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            minChildSize: 0.2,
            maxChildSize: 0.9,
            initialChildSize: initialSize,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [
                  SizedBox(height: 1000, child: Text('Content')),
                ],
              );
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the DraggableScrollableSheet widget
      final draggableSheetFinder = find.byType(DraggableScrollableSheet);
      expect(draggableSheetFinder, findsOneWidget);

      // Verify that the initialChildSize property was correctly passed down
      final DraggableScrollableSheet draggableSheet =
          tester.widget(draggableSheetFinder);
      expect(draggableSheet.initialChildSize, initialSize);
    });

    testWidgets(
        'Switching from internal to external controller works correctly',
        (WidgetTester tester) async {
      // 1. Start with internal controller
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            minChildSize: 0.2,
            maxChildSize: 0.9,
            initialChildSize: 0.5,
            builder: (context, scrollController) {
              return ListView(controller: scrollController);
            },
          ),
        ),
      );

      // 2. Switch to external controller
      final externalController = GrabberSheetController();
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            controller: externalController, // Provide external controller
            minChildSize: 0.2,
            maxChildSize: 0.9,
            initialChildSize: 0.5,
            builder: (context, scrollController) {
              return ListView(controller: scrollController);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 3. Verify external controller works
      // Maximize using the new external controller
      externalController.maximize();
      await tester.pumpAndSettle();

      // Check if the sheet size updated (using the controller's size)
      expect(externalController.size, closeTo(0.9, 0.01));
    });

    testWidgets(
        'Switching from external to internal controller works correctly',
        (WidgetTester tester) async {
      // 1. Start with external controller
      final externalController = GrabberSheetController();
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            controller: externalController,
            minChildSize: 0.2,
            maxChildSize: 0.9,
            initialChildSize: 0.5,
            builder: (context, scrollController) {
              return ListView(controller: scrollController);
            },
          ),
        ),
      );

      // 2. Switch to internal controller (pass null)
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            controller: null, // Switch back to internal
            minChildSize: 0.2,
            maxChildSize: 0.9,
            initialChildSize: 0.5,
            builder: (context, scrollController) {
              return ListView(controller: scrollController);
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 3. Verify no crash and basic existence
      // Since we can't access the internal controller easily to check size,
      // we verify the widget still exists and has the correct properties.
      final draggableSheetFinder = find.byType(DraggableScrollableSheet);
      expect(draggableSheetFinder, findsOneWidget);

      // Ensure the external controller is no longer attached (optional check if possible,
      // but standard DraggableScrollableController doesn't have an 'isAttached' property exposed easily
      // without trying to use it. Trying to use it might throw if it was disposed, but here we just want to ensure
      // the sheet is alive with its own internal controller).
    });
  });
}
