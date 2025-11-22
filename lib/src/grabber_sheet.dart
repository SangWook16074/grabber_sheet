import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'grabber_style.dart';

/// A customizable draggable bottom sheet that uses a builder pattern for its content.
///
/// This widget enhances the standard [DraggableScrollableSheet] by adding a
/// visible "grabber" handle. This handle not only provides a visual cue for
/// dragging but also allows the user to resize the sheet by dragging the handle itself.
///
/// It simplifies the management of scroll controllers by using a
/// [DraggableScrollableController] internally and providing a [ScrollController]
/// to the `builder`.
class GrabberSheet extends StatefulWidget {
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
  final GrabberStyle grabberStyle;

  /// A custom widget to be displayed below the grabber.
  final Widget? bottom;

  /// The padding for the bottom widget.
  final EdgeInsetsGeometry? bottomAreaPadding;

  /// The background color of the sheet.
  ///
  /// If null, it defaults to the theme's `colorScheme.surface`.
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

  /// Creates a new instance of [GrabberSheet].
  const GrabberSheet({
    super.key,
    required this.builder,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.showGrabber = true,
    this.grabberStyle = const GrabberStyle(),
    this.bottom,
    this.bottomAreaPadding,
    this.snap = false,
    this.snapSizes,
    this.backgroundColor,
  }) : assert(minChildSize >= 0.0),
       assert(maxChildSize <= 1.0),
       assert(minChildSize <= initialChildSize),
       assert(initialChildSize <= maxChildSize);

  @override
  State<GrabberSheet> createState() => _GrabberSheetState();
}

/// The state object for the [GrabberSheet] widget.
class _GrabberSheetState extends State<GrabberSheet> {
  /// The controller for the underlying [DraggableScrollableSheet].
  late final DraggableScrollableController _controller;

  /// The current size of the sheet, updated during dragging.
  late double _newSize = widget.initialChildSize;

  @override
  void initState() {
    super.initState();
    _controller = DraggableScrollableController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color sheetColor =
        widget.backgroundColor ?? theme.colorScheme.surface;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return DraggableScrollableSheet(
          controller: _controller,
          initialChildSize: widget.initialChildSize,
          minChildSize: widget.minChildSize,
          maxChildSize: widget.maxChildSize,
          snap: widget.snap,
          snapSizes: widget.snapSizes,
          builder: (BuildContext context, ScrollController scrollController) {
            return Container(
              decoration: BoxDecoration(
                color: sheetColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16.0),
                  topRight: Radius.circular(16.0),
                ),
              ),
              child: Column(
                children: <Widget>[
                  GestureDetector(
                    onVerticalDragUpdate: (details) {
                      final newPixel = _controller.pixels - details.delta.dy;
                      // Convert pixel value to fractional size and clamp it.
                      _newSize = _controller
                          .pixelsToSize(newPixel)
                          .clamp(0.0, 1.0);

                      _controller.jumpTo(_newSize);
                    },
                    onVerticalDragEnd: (details) {
                      // If snapping is disabled, do nothing.
                      if (!widget.snap) return;

                      final double velocity = details.primaryVelocity ?? 0.0;
                      // A velocity threshold to determine if it's a fling.
                      const double flingVelocity = 300.0;

                      // Combine min/max with custom snapSizes, remove duplicates, and sort.
                      final Set<double> allSnapPoints = {
                        widget.minChildSize,
                        widget.maxChildSize,
                        ...?widget.snapSizes,
                      };
                      final List<double> sortedSnapPoints =
                          allSnapPoints.toList()..sort();

                      double targetSize;

                      if (velocity.abs() > flingVelocity) {
                        // On a fling, animate to the min or max extent.
                        targetSize = velocity < 0
                            ? sortedSnapPoints.last
                            : sortedSnapPoints.first;
                      } else {
                        // On a slow drag, find the closest snap point.
                        targetSize = sortedSnapPoints.reduce(
                          (a, b) =>
                              (_newSize - a).abs() < (_newSize - b).abs()
                                  ? a
                                  : b,
                        );
                      }

                      // Animate the sheet to the determined target size.
                      _controller.animateTo(
                        targetSize,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                    child: Container(
                      color: Colors.transparent,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (widget.showGrabber)
                            _Grabber(
                              style: widget.grabberStyle,
                            ),
                          if (widget.bottom != null)
                            Padding(
                              padding:
                                  widget.bottomAreaPadding ?? EdgeInsets.zero,
                              child: widget.bottom,
                            ),
                        ],
                      ),
                    ),
                  ),
                  // The main content of the sheet.
                  Expanded(child: widget.builder(context, scrollController)),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

/// A private widget representing the draggable handle area.
class _Grabber extends StatelessWidget {
  const _Grabber({
    required this.style,
  });

  /// The visual style of the grabber handle.
  final GrabberStyle style;

  @override
  Widget build(BuildContext context) {
    // For a more native feel, the grabber is not shown on desktop and web platforms.
    if (_isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: Colors.transparent,
      child: Align(
        alignment: Alignment.topCenter,
        // This is the visible part of the grabber.
        child: Container(
          margin: style.margin,
          width: style.width,
          height: style.height,
          decoration: BoxDecoration(
            color: style.color,
            borderRadius: BorderRadius.all(style.radius),
          ),
        ),
      ),
    );
  }

  /// Checks if the current platform is a desktop or web environment.
  bool get _isOnDesktopAndWeb {
    return kIsWeb ||
        switch (defaultTargetPlatform) {
          TargetPlatform.macOS ||
          TargetPlatform.linux ||
          TargetPlatform.windows => true,
          TargetPlatform.android ||
          TargetPlatform.iOS ||
          TargetPlatform.fuchsia => false,
        };
  }
}