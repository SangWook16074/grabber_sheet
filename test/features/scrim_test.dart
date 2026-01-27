import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

import '../common/test_app_harness.dart';

void main() {
  group('Scrim (Background Overlay) Tests', () {
    testWidgets('should render scrim when showScrim is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            showScrim: true,
            scrimColor: Colors.black54,
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [Text('Content')],
              );
            },
          ),
        ),
      );

      // We expect a widget with this key to be present.
      // Implementation must add Key('grabber_sheet_scrim') to the scrim widget.
      expect(find.byKey(const Key('grabber_sheet_scrim')), findsOneWidget);
    });

    testWidgets('should not render scrim when showScrim is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            showScrim: false, // Default
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [Text('Content')],
              );
            },
          ),
        ),
      );

      expect(find.byKey(const Key('grabber_sheet_scrim')), findsNothing);
    });
  });
}
