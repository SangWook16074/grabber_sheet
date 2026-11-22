import 'package:material_ui/material_ui.dart';

import 'grabber_sheet_controller.dart';
import 'grabber_style.dart';
import 'raw_grabber_sheet.dart';

/// A customizable draggable bottom sheet that uses a builder pattern for its content.
///
/// This widget enhances the standard [DraggableScrollableSheet] by adding a
/// visible "grabber" handle. This handle not only provides a visual cue for
/// dragging but also allows the user to resize the sheet by dragging the handle itself.
///
/// It simplifies the management of scroll controllers by using a
/// [DraggableScrollableController] internally and providing a [ScrollController]
/// to the `builder`.
///
/// [GrabberSheet] resolves its visual defaults from the Material theme and
/// builds a [RawGrabberSheet]. Use [RawGrabberSheet] directly from
/// `package:grabber_sheet/raw_grabber_sheet.dart` for apps that do not use
/// Material.
class GrabberSheet extends StatelessWidget {
  /// A builder function that provides a [ScrollController] to the content.
  ///
  /// The content of the sheet, typically a scrollable widget like [ListView]
  /// or [GridView], should use this controller to ensure that scrolling within
  /// the sheet and dragging the sheet itself work together seamlessly.
  final Widget Function(BuildContext, ScrollController) builder;

  /// The initial fractional size of the sheet.
  ///
  /// The sheet will be displayed at this size when first built.
  /// Defaults to 0.5.
  final double initialChildSize;

  /// The minimum fractional size of the sheet.
  ///
  /// The sheet cannot be dragged smaller than this size.
  /// Defaults to 0.25.
  final double minChildSize;

  /// The maximum fractional size of the sheet.
  ///
  /// The sheet cannot be dragged larger than this size.
  /// Defaults to 1.0.
  final double maxChildSize;

  /// Whether to show the grabber handle at the top of the sheet.
  ///
  /// Defaults to true.
  final bool showGrabber;

  /// The visual style of the grabber handle, defined by a [GrabberStyle] object.
  ///
  /// Null properties are resolved from [BottomSheetThemeData.dragHandleColor]
  /// and [BottomSheetThemeData.dragHandleSize], then the Material drag handle
  /// defaults (a 32x4 handle colored `colorScheme.onSurfaceVariant` in
  /// Material 3).
  final GrabberStyle grabberStyle;

  /// Whether tapping the grabber toggles the sheet between [minChildSize]
  /// and [maxChildSize].
  ///
  /// Keyboard users can always use the arrow keys to step through snap
  /// points; when this is true, Enter and Space toggle the sheet as well.
  ///
  /// Defaults to false.
  final bool toggleOnGrabberTap;

  /// A sticky header widget to display below the grabber.
  ///
  /// This area remains visible above the scrollable content, making it useful
  /// for titles, actions, filters, and summary rows.
  final Widget? header;

  /// The padding for the sticky header widget.
  final EdgeInsetsGeometry? headerAreaPadding;

  /// The background color of the sheet.
  ///
  /// If null, defaults to [BottomSheetThemeData.backgroundColor], then
  /// `colorScheme.surfaceContainerLow` (Material 3) or `colorScheme.surface`
  /// (Material 2).
  final Color? backgroundColor;

  /// If true, the sheet will snap to the nearest snap point after dragging.
  ///
  /// The snapping animation provides a cleaner user experience.
  /// Defaults to false.
  final bool snap;

  /// A list of intermediate fractional sizes to which the sheet can snap.
  ///
  /// If [snap] is true and this list is provided, the sheet will snap to the
  /// nearest point in the combined list of [minChildSize], [maxChildSize],
  /// and the values in [snapSizes].
  final List<double>? snapSizes;

  /// Whether to show the grabber handle on non-mobile platforms (desktop and web).
  ///
  /// Defaults to false, meaning the grabber is hidden on desktop and web.
  final bool showGrabberOnNonMobile;

  /// A controller to programmatically control the sheet.
  final GrabberSheetController? controller;

  /// Called when the sheet's size changes.
  ///
  /// The callback receives the new fractional size of the sheet.
  final ValueChanged<double>? onSizeChanged;

  /// Called when the sheet settles on a snap point while [snap] is true.
  ///
  /// This is called regardless of whether the snap was triggered by dragging
  /// the grabber, dragging the content, or tapping the scrim. It is called
  /// once per snap point.
  final ValueChanged<double>? onSnap;

  /// Whether the sheet, when dragged (or flung) to its minimum size, should
  /// cause its parent sheet to close.
  ///
  /// See [DraggableScrollableSheet.shouldCloseOnMinExtent]. Defaults to true.
  final bool shouldCloseOnMinExtent;

  /// The border radius of the sheet.
  ///
  /// If null, defaults to the radius of [BottomSheetThemeData.shape] when it is
  /// a [RoundedRectangleBorder], then a top radius of 28.0 (Material 3) or
  /// 16.0 (Material 2).
  final BorderRadiusGeometry? borderRadius;

  /// The elevation of the sheet surface.
  ///
  /// If null, defaults to [BottomSheetThemeData.elevation], then 0.
  final double? elevation;

  /// The color of the shadow cast when [elevation] is greater than 0.
  ///
  /// If null, defaults to [BottomSheetThemeData.shadowColor], then
  /// `colorScheme.shadow`.
  final Color? shadowColor;

  /// How the sheet content is clipped to the [borderRadius].
  ///
  /// If null, defaults to [BottomSheetThemeData.clipBehavior], then
  /// [Clip.none].
  final Clip? clipBehavior;

  /// The duration of the snap animation.
  ///
  /// Defaults to `const Duration(milliseconds: 300)`.
  final Duration snapAnimationDuration;

  /// The curve of the snap animation.
  ///
  /// Defaults to `Curves.easeOut`.
  final Curve snapAnimationCurve;

  /// Whether to show a scrim (overlay) behind the sheet.
  ///
  /// Defaults to false.
  final bool showScrim;

  /// The color of the scrim.
  ///
  /// Defaults to `Colors.black54`.
  final Color scrimColor;

  /// Whether tapping the scrim should dismiss the sheet (animate to minChildSize).
  ///
  /// Defaults to true.
  final bool dismissOnScrimTap;

  /// Creates a new instance of [GrabberSheet].
  const GrabberSheet({
    super.key,
    required this.builder,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.showGrabber = true,
    this.grabberStyle = const GrabberStyle(),
    this.toggleOnGrabberTap = false,
    this.header,
    this.headerAreaPadding,
    this.snap = false,
    this.snapSizes,
    this.backgroundColor,
    this.showGrabberOnNonMobile = false,
    this.controller,
    this.onSizeChanged,
    this.onSnap,
    this.shouldCloseOnMinExtent = true,
    this.borderRadius,
    this.elevation,
    this.shadowColor,
    this.clipBehavior,
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOut,
    this.showScrim = false,
    this.scrimColor = Colors.black54,
    this.dismissOnScrimTap = true,
  }) : assert(minChildSize >= 0.0),
       assert(maxChildSize <= 1.0),
       assert(minChildSize <= initialChildSize),
       assert(initialChildSize <= maxChildSize);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final bottomSheetTheme = theme.bottomSheetTheme;
    final bool useMaterial3 = theme.useMaterial3;
    final Size? themeHandleSize = bottomSheetTheme.dragHandleSize;
    final ShapeBorder? themeShape = bottomSheetTheme.shape;

    final GrabberStyle effectiveGrabberStyle = grabberStyle.merge(
      GrabberStyle(
        color:
            bottomSheetTheme.dragHandleColor ??
            (useMaterial3
                ? colorScheme.onSurfaceVariant
                : colorScheme.onSurface.withValues(alpha: 0.4)),
        width: themeHandleSize?.width,
        height: themeHandleSize?.height,
      ),
    );

    return RawGrabberSheet(
      builder: builder,
      backgroundColor:
          backgroundColor ??
          bottomSheetTheme.backgroundColor ??
          (useMaterial3
              ? colorScheme.surfaceContainerLow
              : colorScheme.surface),
      initialChildSize: initialChildSize,
      minChildSize: minChildSize,
      maxChildSize: maxChildSize,
      showGrabber: showGrabber,
      grabberStyle: effectiveGrabberStyle,
      toggleOnGrabberTap: toggleOnGrabberTap,
      header: header,
      headerAreaPadding: headerAreaPadding ?? EdgeInsets.zero,
      snap: snap,
      snapSizes: snapSizes,
      showGrabberOnNonMobile: showGrabberOnNonMobile,
      controller: controller,
      onSizeChanged: onSizeChanged,
      onSnap: onSnap,
      shouldCloseOnMinExtent: shouldCloseOnMinExtent,
      borderRadius:
          borderRadius ??
          (themeShape is RoundedRectangleBorder
              ? themeShape.borderRadius
              : null) ??
          BorderRadius.vertical(
            top: Radius.circular(useMaterial3 ? 28.0 : 16.0),
          ),
      elevation: elevation ?? bottomSheetTheme.elevation ?? 0.0,
      shadowColor:
          shadowColor ?? bottomSheetTheme.shadowColor ?? colorScheme.shadow,
      clipBehavior: clipBehavior ?? bottomSheetTheme.clipBehavior ?? Clip.none,
      snapAnimationDuration: snapAnimationDuration,
      snapAnimationCurve: snapAnimationCurve,
      showScrim: showScrim,
      scrimColor: scrimColor,
      dismissOnScrimTap: dismissOnScrimTap,
    );
  }
}
