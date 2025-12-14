import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

import '../common/test_app_harness.dart';

void main() {
  testWidgets('applies custom borderRadius when provided',
      (WidgetTester tester) async {
    // Given
    const customBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(30),
      topRight: Radius.circular(30),
    );

    await tester.pumpWidget(
      TestAppHarness(
        child: GrabberSheet(
          borderRadius: customBorderRadius,
          builder: (context, scrollController) {
            return Container();
          },
        ),
      ),
    );

    // Then
    final sheetContainerFinder = find.descendant(
      of: find.byType(DraggableScrollableSheet),
      matching: find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.borderRadius == customBorderRadius;
        }
        return false;
      }),
    );

    expect(sheetContainerFinder, findsOneWidget);
  });

  testWidgets('falls back to default borderRadius when null',
      (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(
      TestAppHarness(
        child: GrabberSheet(
          builder: (context, scrollController) {
            return Container();
          },
        ),
      ),
    );

    // Then
    const defaultBorderRadius = BorderRadius.only(
      topLeft: Radius.circular(16.0),
      topRight: Radius.circular(16.0),
    );

    final sheetContainerFinder = find.descendant(
      of: find.byType(DraggableScrollableSheet),
      matching: find.byWidgetPredicate((widget) {
        if (widget is Container && widget.decoration is BoxDecoration) {
          final decoration = widget.decoration as BoxDecoration;
          return decoration.borderRadius == defaultBorderRadius;
        }
        return false;
      }),
    );

    expect(sheetContainerFinder, findsOneWidget);
  });
}
