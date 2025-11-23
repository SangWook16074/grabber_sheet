[한국어 문서 보기 (View in Korean)](README.ko.md)

# grabber_sheet

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

A reusable and customizable draggable bottom sheet with a grabber handle, inspired by the modal sheets in popular apps like Google Maps.

It enhances Flutter's built-in `DraggableScrollableSheet` by providing a visible grabber, simplifying scroll controller management, and ensuring predictable behavior.

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />

## Features

*   Draggable bottom sheet with a customizable grabber handle.
*   Stable and predictable behavior, fixing common scroll controller conflicts.
*   Use any widget as the content of the sheet via a `builder`.
*   Insert a custom widget into the draggable grabber area.
*   Customize sheet sizes (initial, min, max).
*   Optional snapping behavior with custom snap points via `snap` and `snapSizes`.
*   Customize grabber style (color, size, shape).
*   Grabber is automatically hidden on desktop and web platforms for a native feel.
*   Sheet has rounded top corners by default.

## Getting started

Add this to your package's `pubspec.yaml` file. Check the latest version on [pub.dev](https://pub.dev/packages/grabber_sheet).

```yaml
dependencies:
  grabber_sheet: ^latest # Replace with the latest version from pub.dev
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
    final theme = Theme.of(context);
    final sheetColor = Colors.blue.shade100;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('GrabberSheet Example'),
        backgroundColor: sheetColor,
      ),
      body: Stack(
        children: [
          Center(
            child: Text(
              'Background Content',
              style: theme.textTheme.headlineMedium,
            ),
          ),
          GrabberSheet(
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.8,
            snap: true,
            snapSizes: const [.5],
            backgroundColor: sheetColor,
            grabberStyle: GrabberStyle(color: Colors.grey.shade400),
            bottom: Row(
              children: [
                const Text('sheet title'),
                const Spacer(),
                IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
              ],
            ),
            bottomAreaPadding: const EdgeInsets.symmetric(horizontal: 16),
            builder: (BuildContext context, ScrollController scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Item $index',
                      style: TextStyle(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
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

By setting `snap` to `true`, the sheet will automatically animate to the nearest defined snap point when a drag gesture ends. This creates a clean, predictable motion for the user.

The snapping logic behaves differently based on the drag gesture:

*   **Slow Drag:** If the user slowly drags the sheet and releases, it will snap to the *closest* snap point.
*   **Fling:** If the user "flings" the sheet with a quick gesture, it will animate to the nearest boundary (either `minChildSize` or `maxChildSize`) in the direction of the fling.

You can define the snap points using `minChildSize`, `maxChildSize`, and the optional `snapSizes` for any intermediate points.

Here is an example with multiple intermediate snap points:

```dart
GrabberSheet(
  // Enable snapping
  snap: true, 
  
  // Define snap points: 0.2 (min), 0.5, 0.8 (intermediate), and 1.0 (max)
  minChildSize: 0.2,
  maxChildSize: 1.0,
  initialChildSize: 0.5,
  snapSizes: const [0.5, 0.8],
  
  builder: (context, scrollController) {
    // ... your content
  },
),
```

![snap gif](https://github.com/user-attachments/assets/3727d83a-456b-4fd9-a721-8ad3e2116005)


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

<img width="250" src="https://github.com/user-attachments/assets/8d062fa4-cdda-4445-9d90-b34aa3fce1c5" />

You can also hide the grabber completely by setting `showGrabber: false`.

<img width="250" src="https://github.com/user-attachments/assets/20d589b5-54c3-4da3-b420-0c1b10f3e9ef" />

### Adding a Custom Widget to the Grabber Area

You can insert a custom widget into the draggable area below the grabber handle using the `bottom` property. This entire area (handle and custom widget) is draggable. This is useful for adding a title, action buttons, or any other information that should remain visible and separate from the scrollable content.

The `bottomAreaPadding` property can be used to add padding around this custom widget.

```dart
GrabberSheet(
  bottom: Row(
    children: [
      const Text('sheet title'),
      const Spacer(),
      IconButton(onPressed: () {}, icon: const Icon(Icons.close)),
    ],
  ),
  bottomAreaPadding: const EdgeInsets.symmetric(horizontal: 16),
  builder: (context, scrollController) {
    // ... your list of locations
  },
),
```

<img width="250" src="https://github.com/user-attachments/assets/669f7506-2b92-408f-a239-240ac68ca621" />

## Properties

### GrabberSheet

| Property            | Type                                     | Description                                                                                                                                 | Default Value                                |
| ------------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `builder`           | `Widget Function(BuildContext, ScrollController)` | **Required.** Builds the scrollable content of the sheet. Provides a `ScrollController` to be used by the content.                      | -                                            |
| `initialChildSize`  | `double`                                 | The initial fractional size of the sheet.                                                                                                   | `0.5`                                        |
| `minChildSize`      | `double`                                 | The minimum fractional size of the sheet.                                                                                                   | `0.25`                                       |
| `maxChildSize`      | `double`                                 | The maximum fractional size of the sheet.                                                                                                   | `1.0`                                        |
| `snap`              | `bool`                                   | If true, the sheet will snap to the nearest snap point after dragging.                                                                      | `false`                                      |
| `snapSizes`         | `List<double>?`                          | A list of intermediate fractional sizes to snap to.                                                                                         | `null`                                       |
| `showGrabber`       | `bool`                                   | Whether to show the grabber handle. It is automatically hidden on desktop and web platforms regardless of this value.                       | `true`                                       |
| `grabberStyle`      | `GrabberStyle`                           | The visual style of the grabber handle.                                                                                                     | `const GrabberStyle()`                       |
| `bottom`            | `Widget?`                                | A custom widget to display below the grabber and above the main content.                                                                    | `null`                                       |
| `bottomAreaPadding` | `EdgeInsetsGeometry?`                    | The padding for the `bottom` widget area.                                                                                                   | `null`                                       |
| `backgroundColor`   | `Color?`                                 | The background color of the sheet container. If null, it uses the theme's `colorScheme.surface`. The sheet has a default top border radius of 16.0. | `Theme.of(context).colorScheme.surface`      |

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
