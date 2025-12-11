[한국어 문서 보기 (View in Korean)](README.ko.md)

# grabber_sheet

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

A reusable and customizable draggable bottom sheet with a grabber handle, inspired by the modal sheets in popular apps like Google Maps.

**Ideally suited for developers who need to build complex UIs within a bottom sheet while maintaining a separate, draggable grabber area and smooth snapping behavior.**

It solves the common frustrations with Flutter's built-in `DraggableScrollableSheet`:
1.  **Independent Grabber Area**: The grabber and header are separate from the scrollable content. Dragging the header moves the sheet; scrolling the content scrolls the list. No more gesture conflicts.
2.  **Predictable Snapping**: Easily snap to specific heights without complex controller logic.
3.  **Seamless Integration**: Works perfectly with `ListView`, `SingleChildScrollView`, and other scrollable widgets.

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />

## Why use GrabberSheet?

If you've ever struggled with:
*   The grabber disappearing when you scroll down.
*   The sheet not moving when you try to drag the header.
*   Janky snapping animations.

Then `GrabberSheet` is the solution you've been looking for. It provides a robust, production-ready implementation of the "modal bottom sheet" pattern found in top-tier mobile apps.

## Features

*   **Conflict-Free Dragging**: Dedicated drag zone for the sheet, independent of the inner scroll view.
*   **Customizable Grabber**: Style the handle to match your app's design.
*   **Smooth Snapping**: Built-in support for snapping to min, max, and custom intermediate sizes.
*   **Flexible Content**: Use any widget (ListView, Column, etc.) via a simple `builder`.
*   **Header Support**: Insert custom widgets (titles, buttons) into the non-scrollable drag area.
*   **Cross-Platform**: Works on Mobile, with optional desktop/web support for the grabber.

## Getting started

Add this to your package's `pubspec.yaml` file. Check the latest version on [pub.dev](https://pub.dev/packages/grabber_sheet).

```yaml
dependencies:
  grabber_sheet: ^1.1.2
```

Then, install it by running `flutter pub get` in your terminal.

## Compatibility

This package is compatible with the following SDK versions:
*   **Flutter**: `>=3.0.0`
*   **Dart**: `>=3.0.0 <4.0.0`

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

### Showing the Grabber on Desktop and Web

By default, the grabber handle is only visible on mobile platforms (iOS, Android). However, you can force it to always be visible on desktop (Windows, macOS, Linux) and web platforms by setting the `showGrabberOnNonMobile` property to `true`. This is useful when you want to provide a consistent UI across all platforms.

```dart
GrabberSheet(
  showGrabberOnNonMobile: true,
  builder: (context, scrollController) {
    // ... Your content
  },
),
```

![grabber_sheet_web](https://github.com/user-attachments/assets/631bc09f-b4a4-4736-8df4-a52501e6c192)

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
| `showGrabber`       | `bool`                                   | Whether to show the grabber handle. If `false`, the handle is hidden on all platforms.                                                      | `true`                                       |
| `showGrabberOnNonMobile` | `bool` | Whether to show the grabber handle on non-mobile platforms like desktop and web. | `false` |
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