import 'package:flutter/widgets.dart';

/// Defines the visual appearance of the grabber handle.
///
/// An object of this class can be passed to `GrabberSheet.grabberStyle`
/// to customize the look and feel of the draggable handle.
///
/// Any property left null is resolved by the sheet. `GrabberSheet` resolves
/// it from `BottomSheetThemeData` and the Material 3 drag handle defaults,
/// while `RawGrabberSheet` falls back to the defaults documented below.
class GrabberStyle {
  /// The background color of the grabber handle.
  ///
  /// Defaults to `Color(0xFF9E9E9E)` in `RawGrabberSheet`.
  final Color? color;

  /// The width of the grabber handle.
  ///
  /// Defaults to 32.0.
  final double? width;

  /// The height of the grabber handle.
  ///
  /// Defaults to 4.0.
  final double? height;

  /// The border radius of the grabber handle's corners.
  ///
  /// Defaults to a fully rounded (pill) shape.
  final Radius? radius;

  /// The margin surrounding the grabber handle.
  ///
  /// This is useful for creating vertical space between the handle
  /// and the content of the sheet.
  ///
  /// Defaults to `const EdgeInsets.symmetric(vertical: 22.0)`, which makes
  /// the grabber area 48 logical pixels tall with the default height.
  final EdgeInsetsGeometry? margin;

  /// Creates a style object that defines the grabber's appearance.
  const GrabberStyle({
    this.color,
    this.width,
    this.height,
    this.radius,
    this.margin,
  });

  /// Creates a copy of this style where null properties are taken from
  /// [other].
  GrabberStyle merge(GrabberStyle? other) {
    if (other == null) return this;
    return GrabberStyle(
      color: color ?? other.color,
      width: width ?? other.width,
      height: height ?? other.height,
      radius: radius ?? other.radius,
      margin: margin ?? other.margin,
    );
  }
}
