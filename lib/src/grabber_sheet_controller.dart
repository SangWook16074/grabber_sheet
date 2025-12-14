import 'package:flutter/widgets.dart';

/// A controller for [GrabberSheet].
///
/// Allows external control of the sheet's size, specifically providing methods
/// to maximize and minimize the sheet based on its configured constraints.
class GrabberSheetController extends DraggableScrollableController {
  double _minSize = 0.0;
  double _maxSize = 1.0;

  /// Updates the size constraints of the sheet.
  ///
  /// This is intended to be called internally by [GrabberSheet].
  void internalUpdateConstraints(double min, double max) {
    _minSize = min;
    _maxSize = max;
  }

  /// Animates the sheet to its maximum allowed size ([maxChildSize]).
  void maximize({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (!isAttached) return;
    animateTo(
      _maxSize,
      duration: duration,
      curve: curve,
    );
  }

  /// Animates the sheet to its minimum allowed size ([minChildSize]).
  void minimize({
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeOut,
  }) {
    if (!isAttached) return;
    animateTo(
      _minSize,
      duration: duration,
      curve: curve,
    );
  }
}
