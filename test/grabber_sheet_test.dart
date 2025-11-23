import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

void main() {
  testWidgets('renders bottom widget when provided', (
    WidgetTester tester,
  ) async {
    // Given
    const bottomWidget = Text('Bottom Widget');
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GrabberSheet(
            bottom: bottomWidget, // This parameter doesn't exist yet
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

    // Then
    expect(find.byWidget(bottomWidget), findsOneWidget);
    expect(find.text('Bottom Widget'), findsOneWidget);
  });
}
