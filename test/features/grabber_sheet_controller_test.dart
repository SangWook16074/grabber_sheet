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
  });
}
