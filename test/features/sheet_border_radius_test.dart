import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

import '../common/test_app_harness.dart';

BorderRadiusGeometry _surfaceBorderRadius(WidgetTester tester) {
  final surface = tester.widget<PhysicalShape>(
    find.byKey(const Key('grabber_sheet_surface')),
  );
  final clipper = surface.clipper as ShapeBorderClipper;
  return (clipper.shape as RoundedRectangleBorder).borderRadius;
}

void main() {
  testWidgets('applies custom borderRadius when provided', (
    WidgetTester tester,
  ) async {
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
    expect(_surfaceBorderRadius(tester), customBorderRadius);
  });

  testWidgets('falls back to the Material 3 borderRadius when null', (
    WidgetTester tester,
  ) async {
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
    expect(
      _surfaceBorderRadius(tester),
      const BorderRadius.vertical(top: Radius.circular(28.0)),
    );
  });
}
