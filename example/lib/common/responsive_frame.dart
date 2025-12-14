import 'package:flutter/material.dart';

/// A widget that provides a responsive frame, centering its child with a
/// fixed width on wider screens, while allowing it to fill the screen on narrower
/// screens.
class ResponsiveFrame extends StatelessWidget {
  /// The child widget to be displayed within the frame.
  final Widget child;

  /// The breakpoint at which the layout switches from centered to full-width.
  final double breakpoint;

  /// The fixed width of the content in the centered (wide-screen) layout.
  final double contentWidth;

  /// Creates a [ResponsiveFrame].
  const ResponsiveFrame({
    super.key,
    required this.child,
    this.breakpoint = 600.0,
    this.contentWidth = 412.0,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // If the screen is wider than the breakpoint, center the content.
        if (constraints.maxWidth > breakpoint) {
          return Center(
            child: SizedBox(width: contentWidth, child: child),
          );
        } else {
          // On narrower screens, the child fills the available space.
          return child;
        }
      },
    );
  }
}
