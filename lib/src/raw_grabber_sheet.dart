import 'package:flutter/foundation.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import 'grabber_sheet_controller.dart';
import 'grabber_style.dart';

/// The default border radius of the sheet when none is provided.
const BorderRadius _defaultBorderRadius = BorderRadius.only(
  topLeft: Radius.circular(16.0),
  topRight: Radius.circular(16.0),
);

/// The tolerance used to decide whether the sheet rests on a snap point.
const double _snapTolerance = 1e-3;

/// The default grabber style used when [GrabberStyle] properties are null.
const GrabberStyle _defaultGrabberStyle = GrabberStyle(
  color: Color(0xFF9E9E9E),
  width: 32.0,
  height: 4.0,
  margin: EdgeInsets.symmetric(vertical: 22.0),
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

  /// Whether tapping the grabber toggles the sheet between [minChildSize]
  /// and [maxChildSize].
  ///
  /// Keyboard users can always use the arrow keys to step through snap
  /// points; when this is true, Enter and Space toggle the sheet as well.
  ///
  /// Defaults to false.
  final bool toggleOnGrabberTap;

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
  /// Defaults to a top-left and top-right radius of 16.0.
  final BorderRadiusGeometry borderRadius;

  /// The elevation of the sheet surface.
  ///
  /// Defaults to 0.
  final double elevation;

  /// The color of the shadow cast when [elevation] is greater than 0.
  ///
  /// Defaults to `Color(0xFF000000)`.
  final Color shadowColor;

  /// How the sheet content is clipped to the [borderRadius].
  ///
  /// Defaults to [Clip.none].
  final Clip clipBehavior;

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
    this.toggleOnGrabberTap = false,
    this.header,
    this.headerAreaPadding = EdgeInsets.zero,
    this.snap = false,
    this.snapSizes,
    this.showGrabberOnNonMobile = false,
    this.controller,
    this.onSizeChanged,
    this.onSnap,
    this.shouldCloseOnMinExtent = true,
    this.borderRadius = _defaultBorderRadius,
    this.elevation = 0.0,
    this.shadowColor = const Color(0xFF000000),
    this.clipBehavior = Clip.none,
    this.snapAnimationDuration = const Duration(milliseconds: 300),
    this.snapAnimationCurve = Curves.easeOut,
    this.showScrim = false,
    this.scrimColor = const Color(0x8A000000),
    this.dismissOnScrimTap = true,
  }) : assert(minChildSize >= 0.0),
       assert(maxChildSize <= 1.0),
       assert(minChildSize <= initialChildSize),
       assert(initialChildSize <= maxChildSize),
       assert(elevation >= 0.0);

  @override
  State<RawGrabberSheet> createState() => _RawGrabberSheetState();
}

/// The state object for the [RawGrabberSheet] widget.
class _RawGrabberSheetState extends State<RawGrabberSheet> {
  /// The controller for the underlying [DraggableScrollableSheet].
  late DraggableScrollableController _controller;

  /// The current size of the sheet, updated during dragging.
  late double _newSize = widget.initialChildSize;

  /// The number of pointers currently touching the sheet.
  int _activePointerCount = 0;

  /// Incremented on every size change, used to detect when the sheet settles.
  int _sizeChangeSequence = 0;

  /// The last snap point reported through [RawGrabberSheet.onSnap].
  double? _lastSnappedSize;

  /// Whether the grabber currently shows a keyboard focus highlight.
  bool _showGrabberFocusHighlight = false;

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
        Listener(
          onPointerDown: (_) => _activePointerCount++,
          onPointerUp: (_) => _handlePointerReleased(),
          onPointerCancel: (_) => _handlePointerReleased(),
          child: NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              widget.onSizeChanged?.call(notification.extent);
              _currentSizeNotifier.value = notification.extent;
              _handleSizeChanged(notification.extent);
              return false;
            },
            child: DraggableScrollableSheet(
              controller: _controller,
              initialChildSize: widget.initialChildSize,
              minChildSize: widget.minChildSize,
              maxChildSize: widget.maxChildSize,
              snap: widget.snap,
              snapSizes: widget.snapSizes,
              snapAnimationDuration: widget.snapAnimationDuration,
              shouldCloseOnMinExtent: widget.shouldCloseOnMinExtent,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                    return PhysicalShape(
                      key: const Key('grabber_sheet_surface'),
                      clipper: ShapeBorderClipper(
                        shape: RoundedRectangleBorder(
                          borderRadius: widget.borderRadius,
                        ),
                        textDirection: Directionality.maybeOf(context),
                      ),
                      color: widget.backgroundColor,
                      elevation: widget.elevation,
                      shadowColor: widget.shadowColor,
                      clipBehavior: widget.clipBehavior,
                      child: Column(
                        children: <Widget>[
                          _buildDragArea(),
                          // The main content of the sheet.
                          Expanded(
                            child: widget.builder(context, scrollController),
                          ),
                        ],
                      ),
                    );
                  },
            ),
          ),
        ),
      ],
    );
  }

  /// All snap points of the sheet, sorted in ascending order.
  List<double> get _sortedSnapPoints {
    return {
      widget.minChildSize,
      widget.maxChildSize,
      ...?widget.snapSizes,
    }.toList()..sort();
  }

  /// Returns the snap point at [size], or null if [size] is between points.
  double? _snapPointAt(double size) {
    for (final double point in _sortedSnapPoints) {
      if ((point - size).abs() <= _snapTolerance) return point;
    }
    return null;
  }

  void _handlePointerReleased() {
    if (_activePointerCount > 0) _activePointerCount--;
    _scheduleSettleCheck();
  }

  void _handleSizeChanged(double size) {
    _sizeChangeSequence++;
    final double? lastSnappedSize = _lastSnappedSize;
    if (lastSnappedSize != null &&
        (lastSnappedSize - size).abs() > _snapTolerance) {
      _lastSnappedSize = null;
    }
    _scheduleSettleCheck();
  }

  /// Checks, one frame later, whether the sheet has stopped on a snap point.
  ///
  /// Snap animations triggered by [DraggableScrollableSheet] itself do not
  /// report completion, so the sheet is considered settled when its size did
  /// not change for a full frame while no pointer is down.
  void _scheduleSettleCheck() {
    if (!widget.snap || widget.onSnap == null) return;
    final int sequence = _sizeChangeSequence;
    final SchedulerBinding binding = SchedulerBinding.instance;
    binding.addPostFrameCallback((_) {
      if (!mounted) return;
      binding.addPostFrameCallback((_) {
        if (!mounted ||
            sequence != _sizeChangeSequence ||
            _activePointerCount > 0) {
          return;
        }
        final double? point = _snapPointAt(_currentSizeNotifier.value);
        if (point != null) _reportSnap(point);
      });
      binding.scheduleFrame();
    });
    binding.scheduleFrame();
  }

  /// Reports [size] through [RawGrabberSheet.onSnap] once per snap point.
  void _reportSnap(double size) {
    if (_lastSnappedSize == size) return;
    _lastSnappedSize = size;
    widget.onSnap?.call(size);
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
            // For a more native feel, the grabber is not shown on desktop and
            // web platforms, unless explicitly requested.
            if (widget.showGrabber &&
                (widget.showGrabberOnNonMobile || !_isOnDesktopAndWeb))
              _buildAccessibleGrabber(),
            if (widget.header != null)
              Padding(padding: widget.headerAreaPadding, child: widget.header),
          ],
        ),
      ),
    );
  }

  /// Wraps the grabber with keyboard, tap, and mouse support.
  Widget _buildAccessibleGrabber() {
    final bool toggle = widget.toggleOnGrabberTap;
    // Screen reader semantics are intentionally left to apps, which can hide
    // the grabber and provide their own control through the header.
    return FocusableActionDetector(
      includeFocusSemantics: false,
      mouseCursor: SystemMouseCursors.grab,
      onShowFocusHighlight: (value) {
        setState(() => _showGrabberFocusHighlight = value);
      },
      shortcuts: <ShortcutActivator, Intent>{
        const SingleActivator(LogicalKeyboardKey.arrowUp):
            const _ExpandSheetIntent(),
        const SingleActivator(LogicalKeyboardKey.arrowDown):
            const _CollapseSheetIntent(),
        if (toggle) ...{
          const SingleActivator(LogicalKeyboardKey.enter):
              const ActivateIntent(),
          const SingleActivator(LogicalKeyboardKey.space):
              const ActivateIntent(),
        },
      },
      actions: <Type, Action<Intent>>{
        _ExpandSheetIntent: CallbackAction<_ExpandSheetIntent>(
          onInvoke: (_) => _expandOneStep(),
        ),
        _CollapseSheetIntent: CallbackAction<_CollapseSheetIntent>(
          onInvoke: (_) => _collapseOneStep(),
        ),
        if (toggle)
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) => _toggleSize(),
          ),
      },
      child: ExcludeSemantics(
        child: GestureDetector(
          onTap: toggle ? _toggleSize : null,
          child: _Grabber(
            style: widget.grabberStyle,
            showFocusHighlight: _showGrabberFocusHighlight,
          ),
        ),
      ),
    );
  }

  /// The closest snap point above [size], or [RawGrabberSheet.maxChildSize].
  double _nextSnapPointAbove(double size) {
    return _sortedSnapPoints.firstWhere(
      (point) => point > size + _snapTolerance,
      orElse: () => widget.maxChildSize,
    );
  }

  /// The closest snap point below [size], or [RawGrabberSheet.minChildSize].
  double _nextSnapPointBelow(double size) {
    return _sortedSnapPoints.lastWhere(
      (point) => point < size - _snapTolerance,
      orElse: () => widget.minChildSize,
    );
  }

  void _expandOneStep() {
    _animateToSize(_nextSnapPointAbove(_currentSizeNotifier.value));
  }

  void _collapseOneStep() {
    _animateToSize(_nextSnapPointBelow(_currentSizeNotifier.value));
  }

  /// Toggles between [RawGrabberSheet.minChildSize] and
  /// [RawGrabberSheet.maxChildSize].
  void _toggleSize() {
    final bool isExpanded =
        _currentSizeNotifier.value >= widget.maxChildSize - _snapTolerance;
    _animateToSize(isExpanded ? widget.minChildSize : widget.maxChildSize);
  }

  void _animateToSize(double size) {
    if (!_controller.isAttached) return;
    _controller.animateTo(
      size,
      duration: widget.snapAnimationDuration,
      curve: widget.snapAnimationCurve,
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    // If snapping is disabled, do nothing.
    if (!widget.snap) return;

    // The recognizer reports a zero velocity unless the gesture is a fling.
    final double velocity = details.primaryVelocity ?? 0.0;
    final List<double> sortedSnapPoints = _sortedSnapPoints;

    double targetSize;

    if (velocity < 0) {
      // On an upward fling, move to the next snap point above, like
      // DraggableScrollableSheet does for content flings.
      targetSize = sortedSnapPoints.firstWhere(
        (point) => point > _newSize + _snapTolerance,
        orElse: () => sortedSnapPoints.last,
      );
    } else if (velocity > 0) {
      // On a downward fling, move to the next snap point below.
      targetSize = sortedSnapPoints.lastWhere(
        (point) => point < _newSize - _snapTolerance,
        orElse: () => sortedSnapPoints.first,
      );
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
          if (mounted) _reportSnap(targetSize);
        });
  }
}

/// Expands the sheet to the next snap point.
class _ExpandSheetIntent extends Intent {
  const _ExpandSheetIntent();
}

/// Collapses the sheet to the previous snap point.
class _CollapseSheetIntent extends Intent {
  const _CollapseSheetIntent();
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

/// A private widget representing the draggable handle area.
class _Grabber extends StatelessWidget {
  const _Grabber({required this.style, this.showFocusHighlight = false});

  /// The visual style of the grabber handle.
  final GrabberStyle style;

  /// Whether to outline the handle to indicate keyboard focus.
  final bool showFocusHighlight;

  @override
  Widget build(BuildContext context) {
    final GrabberStyle resolved = style.merge(_defaultGrabberStyle);
    final double height = resolved.height!;
    final BorderRadius borderRadius = BorderRadius.all(
      resolved.radius ?? Radius.circular(height / 2),
    );

    return Container(
      width: double.infinity,
      color: const Color(0x00000000),
      child: Align(
        alignment: Alignment.topCenter,
        // This is the visible part of the grabber.
        child: Container(
          key: const Key('grabber'),
          margin: resolved.margin,
          width: resolved.width,
          height: height,
          decoration: BoxDecoration(
            color: resolved.color,
            borderRadius: borderRadius,
          ),
          foregroundDecoration: showFocusHighlight
              ? BoxDecoration(
                  borderRadius: borderRadius,
                  border: Border.all(
                    color: resolved.color!,
                    width: 2,
                    strokeAlign: BorderSide.strokeAlignOutside,
                  ),
                )
              : null,
        ),
      ),
    );
  }
}
