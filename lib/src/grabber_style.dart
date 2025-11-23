import 'package:flutter/material.dart';

/// Defines the visual appearance of the grabber handle.
///
/// An object of this class can be passed to `GrabberSheet.grabberStyle`
/// to customize the look and feel of the draggable handle.
class GrabberStyle {
  /// The background color of the grabber handle.
  final Color color;

  /// The width of the grabber handle.
  ///
  /// Defaults to 48.0.
  final double width;

  /// The height of the grabber handle.
  ///
  /// Defaults to 5.0.
  final double height;

  /// The border radius of the grabber handle's corners.
  ///
  /// Defaults to `const Radius.circular(8.0)`.
  final Radius radius;

  /// The margin surrounding the grabber handle.
  ///
  /// This is useful for creating vertical space between the handle
  /// and the content of the sheet.
  ///
  /// Defaults to `const EdgeInsets.symmetric(vertical: 10.0)`.
  final EdgeInsetsGeometry margin;

  /// Creates a style object that defines the grabber's appearance.
  const GrabberStyle({
    this.color = Colors.grey,
    this.width = 48.0,
    this.height = 5.0,
    this.radius = const Radius.circular(8.0),
    this.margin = const EdgeInsets.symmetric(vertical: 10.0),
  });
}
