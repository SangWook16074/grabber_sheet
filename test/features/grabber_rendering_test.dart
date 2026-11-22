import 'package:flutter/foundation.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

import '../common/test_app_harness.dart';

void main() {
  testWidgets('renders grabber handle correctly', (WidgetTester tester) async {
    // Given
    await tester.pumpWidget(
      TestAppHarness(
        child: GrabberSheet(
          grabberStyle: const GrabberStyle(
            color: Colors.red,
            height: 10,
            width: 100,
            margin: EdgeInsets.all(8),
            radius: Radius.circular(4),
          ),
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
    final grabber = find.byKey(const Key('grabber'));
    expect(grabber, findsOneWidget);

    final container = tester.widget<Container>(grabber);
    final decoration = container.decoration as BoxDecoration;
    expect(decoration.color, Colors.red);
    expect(container.constraints?.maxHeight, 10);
    expect(container.constraints?.maxWidth, 100);
    expect(container.margin, const EdgeInsets.all(8));
    expect(decoration.borderRadius, const BorderRadius.all(Radius.circular(4)));
  });

  group('Platform specific rendering', () {
    testWidgets('shows grabber on iOS by default', (WidgetTester tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpWidget(
        TestAppHarness(
          child: GrabberSheet(
            builder: (context, scrollController) {
              return ListView(
                controller: scrollController,
                children: const [Text('Content')],
              );
            },
          ),
        ),
      );

      expect(find.byKey(const Key('grabber')), findsOneWidget);
      debugDefaultTargetPlatformOverride = null;
    });

    testWidgets(
      'shows grabber on desktop when showGrabberOnNonMobile is true',
      (WidgetTester tester) async {
        // Given
        debugDefaultTargetPlatformOverride = TargetPlatform.windows;
        await tester.pumpWidget(
          TestAppHarness(
            child: GrabberSheet(
              showGrabberOnNonMobile: true,
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
        final grabber = find.byKey(const Key('grabber'));
        expect(grabber, findsOneWidget);

        debugDefaultTargetPlatformOverride = null;
      },
    );
  });
}
