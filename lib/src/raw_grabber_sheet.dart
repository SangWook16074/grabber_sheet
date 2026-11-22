import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'grabber_sheet_controller.dart';
import 'grabber_style.dart';

/// The default border radius of the sheet when none is provided.
const BorderRadius _defaultBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(16.0),
  topRight: Radius.circular(16.0),
);

/// A design-system agnostic draggable bottom sheet with a grabber handle.
///
/// [RawGrabberSheet] only depends on `package:flutter/widgets.dart`, so it can
/// be used in apps that do not use Material or Cupertino. Every visual value
/// must be resolved by the caller; no theme lookups are performed.
///
/// Most apps should use [GrabberSheet] from
/// `package:grabber_sheet/grabber_sheet.dart`, which resolves its defaults
/// from the Material theme and then builds a [RawGrabberSheet].
class RawGrabberSheet extends StatefulWidget {
  /// A builder function that provides a [ScrollController] to the content.
  ///
  /// The content of the sheet, typically a scrollable widget like [ListView]
  /// or [GridView], should use this controller to ensure that scrolling within
  /// the sheet and dragging the sheet itself work together seamlessly.
  final Widget Function(BuildContext, ScrollController) builder;

  /// The initial fractional size of the sheet.
  ///
  /// Defaults to 0.5.
  final double initialChildSize;

  /// The minimum fractional size of the sheet.
  ///
  /// Defaults to 0.25.
  final double minChildSize;

  /// The maximum fractional size of the sheet.
  ///
  /// Defaults to 1.0.
  final double maxChildSize;

  /// Whether to show the grabber handle at the top of the sheet.
  ///
  /// Defaults to true.
  final bool showGrabber;

  /// The visual style of the grabber handle.
  final GrabberStyle grabberStyle;

  /// A sticky header widget to display below the grabber.
  final Widget? header;

  /// The padding for the sticky header widget.
  ///
  /// Defaults to [EdgeInsets.zero].
  final EdgeInsetsGeometry headerAreaPadding;

  /// The background color of the sheet.
  final Color backgroundColor;

  /// If true, the sheet will snap to the nearest snap point after dragging.
  ///
  /// Defaults to false.
  final bool snap;

  /// A list of intermediate fractional sizes to which the sheet can snap.
  final List<double>? snapSizes;

  /// Whether to show the grabber handle on non-mobile platforms (desktop and web).
  ///
  /// Defaults to false.
  final bool showGrabberOnNonMobile;

  /// A controller to programmatically control the sheet.
  final GrabberSheetController? controller;

  /// Called when the sheet's size changes.
  final ValueChanged<double>? onSizeChanged;

  /// Called when the sheet snaps to a specific size.
  final ValueChanged<double>? onSnap;

  /// The border radius of the sheet.
  ///
  /// Defaults to a top-left and top-right radius of 16.0.
  final BorderRadiusGeometry borderRadius;

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
  /// Defaults to `Color(0x8A000000)`.
  final Color scrimColor;

  /// Whether tapping the scrim should dismiss the sheet (animate to minChildSize).
  ///
  /// Defaults to true.
  final bool dismissOnScrimTap;

  /// Creates a new instance of [RawGrabberSheet].
  const RawGrabberSheet({
    super.key,
    required this.builder,
    required this.backgroundColor,
    this.initialChildSize = 0.5,
    this.minChildSize = 0.25,
    this.maxChildSize = 1.0,
    this.showGrabber = true,
    this.grabberStyle = const GrabberStyle(),
    this.header,
    this.headerAreaPadding = EdgeInsets.zero,
    this.snap = false,
    this.snapSizes,
    this.showGrabberOnNonMobile = false,
    this.controller,
    this.onSizeChanged,
    this.onSnap,
    this.borderRadius = _defaultBorderRadius,
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOut,
    this.showScrim = false,
    this.scrimColor = const Color(0x8A000000),
    this.dismissOnScrimTap = true,
  }) : assert(minChildSize >= 0.0),
       assert(maxChildSize <= 1.0),
       assert(minChildSize <= initialChildSize),
       assert(initialChildSize <= maxChildSize);

  @override
  State<RawGrabberSheet> createState() => _RawGrabberSheetState();
}

/// The state object for the [RawGrabberSheet] widget.
class _RawGrabberSheetState extends State<RawGrabberSheet> {
  /// The controller for the underlying [DraggableScrollableSheet].
  late DraggableScrollableController _controller;

  /// The current size of the sheet, updated during dragging.
  late double _newSize = widget.initialChildSize;

  /// Notifier for the current size, used to update the scrim opacity.
  late final ValueNotifier<double> _currentSizeNotifier = ValueNotifier(
    widget.initialChildSize,
  );

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? DraggableScrollableController();
  }

  @override
  void didUpdateWidget(RawGrabberSheet oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller) {
      if (oldWidget.controller == null) {
        // We were using an internal controller, dispose it.
        _controller.dispose();
      }
      _controller = widget.controller ?? DraggableScrollableController();
    }
  }

  @override
  void dispose() {
    _currentSizeNotifier.dispose();
    // Only dispose if we created it internally.
    if (widget.controller == null) {
      _controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Update constraints in the controller if it's a GrabberSheetController.
    if (_controller is GrabberSheetController) {
      (_controller as GrabberSheetController).internalUpdateConstraints(
        widget.minChildSize,
        widget.maxChildSize,
      );
    }

    return Stack(
      children: [
        if (widget.showScrim) _buildScrim(),
        NotificationListener<DraggableScrollableNotification>(
          onNotification: (notification) {
            widget.onSizeChanged?.call(notification.extent);
            _currentSizeNotifier.value = notification.extent;
            return false;
          },
          child: DraggableScrollableSheet(
            controller: _controller,
            initialChildSize: widget.initialChildSize,
            minChildSize: widget.minChildSize,
            maxChildSize: widget.maxChildSize,
            snap: widget.snap,
            snapSizes: widget.snapSizes,
            builder: (BuildContext context, ScrollController scrollController) {
              return Container(
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  borderRadius: widget.borderRadius,
                ),
                child: Column(
                  children: <Widget>[
                    _buildDragArea(),
                    // The main content of the sheet.
                    Expanded(child: widget.builder(context, scrollController)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// Builds the scrim whose opacity follows the sheet's size.
  Widget _buildScrim() {
    return ValueListenableBuilder<double>(
      valueListenable: _currentSizeNotifier,
      builder: (context, currentSize, child) {
        double progress = 0.0;
        if (widget.maxChildSize > widget.minChildSize) {
          progress =
              (currentSize - widget.minChildSize) /
              (widget.maxChildSize - widget.minChildSize);
        }
        progress = progress.clamp(0.0, 1.0);

        if (progress <= 0) return const SizedBox.shrink();

        return GestureDetector(
          onTap: widget.dismissOnScrimTap
              ? () {
                  _controller.animateTo(
                    widget.minChildSize,
                    duration: widget.snapAnimationDuration,
                    curve: widget.snapAnimationCurve,
                  );
                }
              : null,
          child: Container(
            key: const Key('grabber_sheet_scrim'),
            color: widget.scrimColor.withValues(
              alpha: widget.scrimColor.a * progress,
            ),
          ),
        );
      },
    );
  }

  /// Builds the draggable area containing the grabber and the header.
  Widget _buildDragArea() {
    return GestureDetector(
      onVerticalDragStart: (details) {
        _newSize = _controller.size;
      },
      onVerticalDragUpdate: (details) {
        final newPixel = _controller.pixels - details.delta.dy;
        // Convert pixel value to fractional size and clamp it.
        _newSize = _controller.pixelsToSize(newPixel).clamp(0.0, 1.0);

        _controller.jumpTo(_newSize);
      },
      onVerticalDragEnd: _handleDragEnd,
      child: Container(
        color: const Color(0x00000000),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.showGrabber)
              _Grabber(
                style: widget.grabberStyle,
                showOnNonMobile: widget.showGrabberOnNonMobile,
              ),
            if (widget.header != null)
              Padding(padding: widget.headerAreaPadding, child: widget.header),
          ],
        ),
      ),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
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
    final List<double> sortedSnapPoints = allSnapPoints.toList()..sort();

    double targetSize;

    if (velocity.abs() > flingVelocity) {
      // On a fling, animate to the min or max extent.
      targetSize = velocity < 0
          ? sortedSnapPoints.last
          : sortedSnapPoints.first;
    } else {
      // On a slow drag, find the closest snap point.
      targetSize = sortedSnapPoints.reduce(
        (a, b) => (_newSize - a).abs() < (_newSize - b).abs() ? a : b,
      );
    }

    // Animate the sheet to the determined target size.
    _controller
        .animateTo(
          targetSize,
          duration: widget.snapAnimationDuration,
          curve: widget.snapAnimationCurve,
        )
        .then((_) {
          // Trigger onSnap callback after animation completes
          if (mounted && widget.onSnap != null) {
            widget.onSnap!(targetSize);
          }
        });
  }
}

/// A private widget representing the draggable handle area.
class _Grabber extends StatelessWidget {
  const _Grabber({required this.style, this.showOnNonMobile = false});

  /// The visual style of the grabber handle.
  final GrabberStyle style;

  /// Whether to show the grabber handle on non-mobile platforms.
  final bool showOnNonMobile;

  @override
  Widget build(BuildContext context) {
    // For a more native feel, the grabber is not shown on desktop and web platforms,
    // unless explicitly requested.
    if (_isOnDesktopAndWeb && !showOnNonMobile) {
      return const SizedBox.shrink();
    }

    return Container(
      width: double.infinity,
      color: const Color(0x00000000),
      child: Align(
        alignment: Alignment.topCenter,
        // This is the visible part of the grabber.
        child: Container(
          key: const Key('grabber'),
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
