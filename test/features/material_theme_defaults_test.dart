import 'package:material_ui/material_ui.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

Widget _app({required ThemeData theme, required Widget child}) {
  return MaterialApp(
    theme: theme,
    home: Scaffold(body: child),
  );
}

GrabberSheet _sheet({
  GrabberStyle grabberStyle = const GrabberStyle(),
  Color? backgroundColor,
  BorderRadiusGeometry? borderRadius,
  double? elevation,
  Color? shadowColor,
  Clip? clipBehavior,
}) {
  return GrabberSheet(
    grabberStyle: grabberStyle,
    backgroundColor: backgroundColor,
    borderRadius: borderRadius,
    elevation: elevation,
    shadowColor: shadowColor,
    clipBehavior: clipBehavior,
    builder: (context, scrollController) {
      return ListView(
        controller: scrollController,
        children: const [Text('Content')],
      );
    },
  );
}

BoxDecoration _grabberDecoration(WidgetTester tester) {
  final container = tester.widget<Container>(find.byKey(const Key('grabber')));
  return container.decoration! as BoxDecoration;
}

Size _grabberSize(WidgetTester tester) {
  final container = tester.widget<Container>(find.byKey(const Key('grabber')));
  return Size(
    container.constraints!.maxWidth,
    container.constraints!.maxHeight,
  );
}

PhysicalShape _surface(WidgetTester tester) {
  return tester.widget<PhysicalShape>(
    find.byKey(const Key('grabber_sheet_surface')),
  );
}

BorderRadiusGeometry _surfaceBorderRadius(WidgetTester tester) {
  final clipper = _surface(tester).clipper as ShapeBorderClipper;
  return (clipper.shape as RoundedRectangleBorder).borderRadius;
}

void main() {
  group('Material 3 defaults', () {
    final theme = ThemeData(useMaterial3: true, colorSchemeSeed: Colors.teal);

    testWidgets('grabber follows the M3 drag handle spec', (tester) async {
      await tester.pumpWidget(_app(theme: theme, child: _sheet()));

      expect(
        _grabberDecoration(tester).color,
        theme.colorScheme.onSurfaceVariant,
      );
      expect(_grabberSize(tester), const Size(32, 4));
    });

    testWidgets('sheet uses surfaceContainerLow and a 28 radius', (
      tester,
    ) async {
      await tester.pumpWidget(_app(theme: theme, child: _sheet()));

      expect(_surface(tester).color, theme.colorScheme.surfaceContainerLow);
      expect(
        _surfaceBorderRadius(tester),
        const BorderRadius.vertical(top: Radius.circular(28.0)),
      );
      expect(_surface(tester).elevation, 0);
      expect(_surface(tester).clipBehavior, Clip.none);
    });
  });

  group('Material 2 defaults', () {
    final theme = ThemeData(useMaterial3: false);

    testWidgets('keeps the 1.x look', (tester) async {
      await tester.pumpWidget(_app(theme: theme, child: _sheet()));

      expect(
        _grabberDecoration(tester).color,
        theme.colorScheme.onSurface.withValues(alpha: 0.4),
      );
      expect(_surface(tester).color, theme.colorScheme.surface);
      expect(
        _surfaceBorderRadius(tester),
        const BorderRadius.vertical(top: Radius.circular(16.0)),
      );
    });
  });

  group('BottomSheetThemeData', () {
    testWidgets('is used when values are not provided', (tester) async {
      final theme = ThemeData(
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.amber,
          dragHandleColor: Colors.pink,
          dragHandleSize: Size(40, 6),
          elevation: 3,
          shadowColor: Colors.indigo,
          clipBehavior: Clip.antiAlias,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
          ),
        ),
      );
      await tester.pumpWidget(_app(theme: theme, child: _sheet()));

      expect(_grabberDecoration(tester).color, Colors.pink);
      expect(_grabberSize(tester), const Size(40, 6));
      expect(_surface(tester).color, Colors.amber);
      expect(_surface(tester).elevation, 3);
      expect(_surface(tester).shadowColor, Colors.indigo);
      expect(_surface(tester).clipBehavior, Clip.antiAlias);
      expect(
        _surfaceBorderRadius(tester),
        const BorderRadius.vertical(top: Radius.circular(8)),
      );
    });

    testWidgets('explicit values take precedence over the theme', (
      tester,
    ) async {
      final theme = ThemeData(
        useMaterial3: true,
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Colors.amber,
          dragHandleColor: Colors.pink,
          elevation: 3,
        ),
      );
      await tester.pumpWidget(
        _app(
          theme: theme,
          child: _sheet(
            grabberStyle: const GrabberStyle(color: Colors.red, width: 60),
            backgroundColor: Colors.green,
            elevation: 6,
            shadowColor: Colors.black,
            clipBehavior: Clip.hardEdge,
            borderRadius: BorderRadius.zero,
          ),
        ),
      );

      expect(_grabberDecoration(tester).color, Colors.red);
      expect(_grabberSize(tester).width, 60);
      expect(_surface(tester).color, Colors.green);
      expect(_surface(tester).elevation, 6);
      expect(_surface(tester).shadowColor, Colors.black);
      expect(_surface(tester).clipBehavior, Clip.hardEdge);
      expect(_surfaceBorderRadius(tester), BorderRadius.zero);
    });
  });
}
