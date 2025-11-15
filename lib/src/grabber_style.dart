import 'package:flutter/material.dart';

/// A class to define the styling of the grabber handle.
class GrabberStyle {
  /// The color of the grabber.
  final Color color;

  /// The width of the grabber.
  /// Defaults to 48.0.
  final double width;

  /// The height of the grabber.
  /// Defaults to 4.0.
  final double height;

  /// The border radius of the grabber.
  /// Defaults to `Radius.circular(8.0)`.
  final Radius radius;

  /// The vertical margin around the grabber.
  /// Defaults to `EdgeInsets.symmetric(vertical: 8.0)`.
  final EdgeInsetsGeometry margin;

  /// Creates a style object for the grabber.
  const GrabberStyle({
    this.color = Colors.grey,
    this.width = 48.0,
    this.height = 5.0,
    this.radius = const Radius.circular(8.0),
    this.margin = const EdgeInsets.symmetric(vertical: 10.0),
  });
}
