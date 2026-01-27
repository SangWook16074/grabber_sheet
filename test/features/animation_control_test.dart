import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

import '../common/test_app_harness.dart';

void main() {
  group('Animation Control Tests', () {
    testWidgets('should accept snapAnimationDuration and snapAnimationCurve parameters', (WidgetTester tester) async {
      // This test is expected to fail compilation initially because parameters don't exist yet.
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            snap: true,
            // These parameters are new and should cause analysis errors until implemented
            snapAnimationDuration: const Duration(milliseconds: 500),
            snapAnimationCurve: Curves.bounceOut,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [Text('Content')],
              );
            },
          ),
        ),
      );
      
      // If code compiles and runs, we verify nothing crashes
      expect(find.byType(GrabberSheet), findsOneWidget);
    });
  });
}
