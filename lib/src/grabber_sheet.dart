import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'grabber_style.dart';

/// A customizable draggable bottom sheet that uses a builder pattern for its content.
///
/// This widget encapsulates a [DraggableScrollableSheet] and adds a draggable
/// "grabber" handle, allowing resizing by dragging the handle itself.
/// It fixes common issues with scroll controller conflicts by using a
/// [DraggableScrollableController] internally.
class GrabberSheet extends StatefulWidget {
  /// A builder function that provides a [ScrollController] to the content.
  /// The content of the sheet should use this controller for scrolling.
  final Widget Function(BuildContext, ScrollController) builder;

  /// The initial size of the sheet as a fraction of the viewport height.
  /// Defaults to 0.5.
  final double initialChildSize;

  /// The minimum size of the sheet as a fraction of the viewport height.
  /// Defaults to 0.25.
  final double minChildSize;

  /// The maximum size of the sheet as a fraction of the viewport height.
  /// Defaults to 1.0.
  final double maxChildSize;

  /// Whether to show the grabber handle. Defaults to true.
  final bool showGrabber;

  /// The style of the grabber handle.
  final GrabberStyle grabberStyle;

  /// The background color of the sheet.
  /// If null, it uses the theme's `colorScheme.surface`.
  final Color? backgroundColor;

  final bool snap;

  final List<double>? snapSizes;

  const GrabberSheet({
    super.key,
    required this.builder,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.showGrabber = true,
    this.grabberStyle = const GrabberStyle(),
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

class _GrabberSheetState extends State<GrabberSheet> {
  late final DraggableScrollableController _controller;
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
                  if (widget.showGrabber)
                    _Grabber(
                      onVerticalDragUpdate: (details) {
                        final newPixel = _controller.pixels - details.delta.dy;
                        _newSize = _controller
                            .pixelsToSize(newPixel)
                            .clamp(0.0, 1.0);

                        _controller.jumpTo(_newSize);
                      },
                      onVerticalDragEnd: (details) {
                        if (!widget.snap) return;

                        final double velocity = details.primaryVelocity ?? 0.0;
                        const double flingVelocity = 300.0;

                        // Combine min/max with custom snapSizes, remove duplicates, and sort.
                        final Set<double> allSnapPoints = {
                          widget.minChildSize,
                          widget.maxChildSize,
                        };
                        if (widget.snapSizes != null) {
                          allSnapPoints.addAll(widget.snapSizes!);
                        }
                        final List<double> sortedSnapPoints =
                            allSnapPoints.toList()..sort();

                        double targetSize;

                        if (velocity.abs() > flingVelocity) {
                          // On a fling, go to the absolute min or max.
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

                        _controller.animateTo(
                          targetSize,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOut,
                        );
                      },
                      style: widget.grabberStyle,
                    ),
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

/// A draggable handle widget that controls a DraggableScrollableController.
class _Grabber extends StatelessWidget {
  const _Grabber({
    required this.style,
    required this.onVerticalDragUpdate,
    required this.onVerticalDragEnd,
  });
  final ValueChanged<DragUpdateDetails> onVerticalDragUpdate;
  final ValueChanged<DragEndDetails> onVerticalDragEnd;

  final GrabberStyle style;

  @override
  Widget build(BuildContext context) {
    // As per the original logic, the grabber is not shown on desktop and web.
    if (_isOnDesktopAndWeb) {
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onVerticalDragUpdate: onVerticalDragUpdate,
      onVerticalDragEnd: onVerticalDragEnd,
      // Increase the touch target for the grabber area.
      child: Container(
        width: double.infinity,
        color: Colors.transparent,
        child: Align(
          alignment: Alignment.topCenter,
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
      ),
    );
  }

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
