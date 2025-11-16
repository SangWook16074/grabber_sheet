[한국어 문서 보기 (View in Korean)](README.ko.md)

# grabber_sheet

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

A reusable and customizable draggable bottom sheet with a grabber handle, inspired by the modal sheets in popular apps like Google Maps.

It enhances Flutter's built-in `DraggableScrollableSheet` by providing a visible grabber, simplifying scroll controller management, and ensuring predictable behavior.

![GrabberSheet Demo](https://raw.githubusercontent.com/SangWook16074/grabber_sheet/main/art/demo.gif)
*(It's highly recommended to add a demo GIF at this path.)*

## Features

*   Draggable bottom sheet with a customizable grabber handle.
*   Stable and predictable behavior, fixing common scroll controller conflicts.
*   Use any widget as the content of the sheet via a `builder`.
*   Customize sheet sizes (initial, min, max).
*   Optional snapping behavior with custom snap points via `snap` and `snapSizes`.
*   Customize grabber style (color, size, shape).
*   Grabber is automatically hidden on desktop and web platforms for a native feel.
*   Sheet has rounded top corners by default.

## Getting started

Add this to your package's `pubspec.yaml` file. Check the latest version on [pub.dev](https://pub.dev/packages/grabber_sheet).

```yaml
dependencies:
  grabber_sheet: ^1.0.0 # Replace with the latest version from pub.dev
```

Then, install it by running `flutter pub get` in your terminal.

## Basic Usage

Here's a simple example of how to use `GrabberSheet`:

```dart
import 'package:flutter/material.dart';
import 'package:grabber_sheet/grabber_sheet.dart';

class ExampleHomePage extends StatelessWidget {
  const ExampleHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GrabberSheet Example'),
      ),
      body: Stack(
        children: [
          const Center(
            child: Text('Background Content'),
          ),
          GrabberSheet(
            builder: (context, scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: 30,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('Item $index'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
```

## Advanced Customization

### Controlling Snap Behavior

By setting `snap` to `true`, the sheet will automatically animate to the nearest defined snap point when a drag gesture ends. This creates a clean, "snapping" motion.

You can define these points using `minChildSize`, `maxChildSize`, `initialChildSize`, and the optional `snapSizes` for intermediate points.

```dart
GrabberSheet(
  snap: true, // Enable snapping
  // Define snap points: 0.2 (min), 0.6 (intermediate), and 0.9 (max)
  minChildSize: 0.2,
  maxChildSize: 0.9,
  snapSizes: const [0.6],
  builder: (context, scrollController) {
    // ... your content
  },
),
```

### Customizing the Grabber

The appearance of the grabber handle can be fully customized using the `grabberStyle` property.

```dart
GrabberSheet(
  grabberStyle: GrabberStyle(
    width: 60,
    height: 6,
    margin: const EdgeInsets.symmetric(vertical: 10),
    color: Colors.grey.shade300,
    radius: const Radius.circular(12),
  ),
  builder: (context, scrollController) {
    // ... your content
  },
),
```

You can also hide the grabber completely by setting `showGrabber: false`.

## Properties

### GrabberSheet

| Property           | Type                                     | Description                                                                                                                                 | Default Value                                |
| ------------------ | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `builder`          | `Widget Function(BuildContext, ScrollController)` | **Required.** Builds the scrollable content of the sheet. Provides a `ScrollController` to be used by the content.                      | -                                            |
| `initialChildSize` | `double`                                 | The initial fractional size of the sheet.                                                                                                   | `0.5`                                        |
| `minChildSize`     | `double`                                 | The minimum fractional size of the sheet.                                                                                                   | `0.25`                                       |
| `maxChildSize`     | `double`                                 | The maximum fractional size of the sheet.                                                                                                   | `1.0`                                        |
| `snap`             | `bool`                                   | If true, the sheet will snap to the nearest snap point after dragging.                                                                      | `false`                                      |
| `snapSizes`        | `List<double>?`                          | A list of intermediate fractional sizes to snap to.                                                                                         | `null`                                       |
| `showGrabber`      | `bool`                                   | Whether to show the grabber handle. It is automatically hidden on desktop and web platforms regardless of this value.                       | `true`                                       |
| `grabberStyle`     | `GrabberStyle`                           | The visual style of the grabber handle.                                                                                                     | `const GrabberStyle()`                       |
| `backgroundColor`  | `Color?`                                 | The background color of the sheet container. If null, it uses the theme's `colorScheme.surface`. The sheet has a default top border radius of 16.0. | `Theme.of(context).colorScheme.surface`      |

### GrabberStyle

| Property | Type                 | Description                                       | Default Value                                  |
| -------- | -------------------- | ------------------------------------------------- | ---------------------------------------------- |
| `color`    | `Color`              | The background color of the grabber handle.       | `Colors.grey`                                  |
| `width`    | `double`             | The width of the grabber handle.                  | `48.0`                                         |
| `height`   | `double`             | The height of the grabber handle.                 | `5.0`                                          |
| `radius`   | `Radius`             | The border radius of the grabber handle's corners. | `const Radius.circular(8.0)`                   |
| `margin`   | `EdgeInsetsGeometry` | The margin surrounding the grabber handle.        | `const EdgeInsets.symmetric(vertical: 10.0)` |


## Additional information

To file issues, request features, or contribute, please visit the [GitHub repository](https://github.com/SangWook16074/grabber_sheet).
