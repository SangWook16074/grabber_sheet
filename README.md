[한국어 문서 보기 (View in Korean)](README.ko.md)

# grabber_sheet

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

**Tired of DraggableScrollableSheet gesture conflicts? `grabber_sheet` offers a customizable, smooth-snapping bottom sheet with a persistent grabber, solving common UI frustrations.**

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />

## ✨ Who Needs This?

*   **Frustrated by `DraggableScrollableSheet` gesture conflicts?** When your list scrolls, but the sheet tries to drag? `GrabberSheet` solves it.
*   **Struggling to keep your header/grabber visible?** `GrabberSheet` ensures your draggable area stays separate and accessible.
*   **Want smooth, predictable snapping without complex logic?** Define your snap points, and `GrabberSheet` handles the rest.
*   **Looking for a polished, app-like bottom sheet UI?** Inspired by popular apps, `GrabberSheet` delivers a premium experience.

## Why `GrabberSheet`?

I built this because `DraggableScrollableSheet` was too frustrating. The gesture conflicts and disappearing grabbers were deal-breakers for a polished app. `GrabberSheet` fixes these core issues instantly.

| Feature | DraggableScrollableSheet | GrabberSheet |
| :--- | :---: | :---: |
| **Fixed Header/Grabber** | ❌ (Must implement manually) | ✅ (Built-in) |
| **Gesture Conflicts** | ⚠️ (Scroll vs. Drag fights) | ✅ (Perfectly separated) |
| **Snap Animation** | ⚠️ (Complex logic required) | ✅ (Simple parameter) |
| **Ease of Use** | 🔥 Hard | 🍰 Easy |

## Table of Contents

- [Installation](#installation)
- [Usage (Just 3 lines)](#usage-just-3-lines)
- [Advanced Customization](#advanced-customization)
  - [Controlling Snap Behavior](#controlling-snap-behavior)
  - [Customizing the Grabber](#customizing-the-grabber)
  - [Adding a Custom Widget to the Grabber Area](#adding-a-custom-widget-to-the-grabber-area)
  - [Programmatic Control & State Listeners](#programmatic-control--state-listeners)
  - [Showing the Grabber on Desktop and Web](#showing-the-grabber-on-desktop-and-web)
- [Properties](#properties)
  - [GrabberSheet](#grabbersheet-1)
  - [GrabberStyle](#grabberstyle-1)
- [Additional information](#additional-information)

---

## Installation

```bash
flutter pub add grabber_sheet
```

## Compatibility

This package is compatible with the following SDK versions:
*   **Flutter**: `>=3.0.0`
*   **Dart**: `>=3.0.0 <4.0.0`

## Usage (Just 3 lines)

Simply wrap your list with `GrabberSheet` and pass the `ScrollController`. That's it.

```dart
GrabberSheet(
  snap: true, // Auto-snap enabled!
  builder: (context, controller) {
    return ListView.builder(
      controller: controller, // <--- Just connect this!
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    );
  },
)
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

### Programmatic Control & State Listeners

You can use `GrabberSheetController` to control the sheet's position programmatically and listen for state changes to update the UI.

**Key Methods:**
*   `maximize()`: Smoothly animates the sheet to its `maxChildSize`.
*   `minimize()`: Smoothly animates the sheet to its `minChildSize`.
*   `animateTo(double size)`: Animates the sheet to a specific `size` (fraction).

**State Callbacks:**
*   `onSizeChanged`: Triggered whenever the sheet's size changes (during dragging or animation). Useful for responsive UI updates based on drag progress.
*   `onSnap`: Triggered when the sheet settles at a specific snap point.

The complete implementation can be found in `example/lib/main.dart`.

```dart
class _ExampleHomePageState extends State<ExampleHomePage> {
  final GrabberSheetController _grabberSheetController = GrabberSheetController();
  String _currentSheetStatus = 'Idle';
  double _currentSize = 0.5;

  @override
  void initState() {
    super.initState();
    // 2. Listen to state changes (optional, for controller-based updates)
    _grabberSheetController.addListener(() {
      if (_grabberSheetController.isAttached && mounted) {
        setState(() {
          _currentSize = _grabberSheetController.size;
        });
      }
    });
  }
  ...

  @override
  Widget build(BuildContext context) {
    ...
    return Scaffold(
      ...
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.small(
            heroTag: 'maximize',
            // Control: Maximize the sheet
            onPressed: () => _grabberSheetController.maximize(),
            tooltip: 'Maximize',
            child: const Icon(Icons.keyboard_arrow_up),
          ),
          ...
          FloatingActionButton.small(
            heroTag: 'minimize',
            // Control: Minimize the sheet
            onPressed: () => _grabberSheetController.minimize(),
            tooltip: 'Minimize',
            child: const Icon(Icons.keyboard_arrow_down),
          ),
          ...
          FloatingActionButton.small(
            heroTag: 'animate',
            // Control: Animate to a specific size (0.7)
            onPressed: () => _grabberSheetController.animateTo(
              0.7,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            ),
            tooltip: 'Animate to 0.7',
            child: const Icon(Icons.height),
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Background Content',
                  style: theme.textTheme.headlineMedium,
                ),
                const SizedBox(height: 20),
                Text('Sheet Size: ${_currentSize.toStringAsFixed(2)}'),
                Text('Sheet Status: $_currentSheetStatus'),
              ],
            ),
          ),
          GrabberSheet(
            controller: _grabberSheetController, // Attach the controller
            initialChildSize: 0.5,
            minChildSize: 0.2,
            maxChildSize: 0.8
            ...
            onSizeChanged: (size) {
              if (mounted) {
                setState(() {
                  _currentSheetStatus = 'Dragging/Resizing';
                  _currentSize = size;
                });
              }
            },
            // Callback: Triggered when snapped
            onSnap: (size) {
              if (mounted) {
                setState(() {
                  _currentSheetStatus = 'Snapped to ${size.toStringAsFixed(2)}';
                  _currentSize = size;
                });
              }
            },
            builder: (BuildContext context, ScrollController scrollController) {
              return ListView.builder(
                controller: scrollController,
                itemCount: 30,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    title: Text(
                      'Item $index',
                      style: TextStyle(color: theme.colorScheme.onSurface),
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
<img width="250" src="https://github.com/user-attachments/assets/b90799fa-5db5-4e6a-bb9b-3750198877d7" alt="Example of GrabberSheet with FAB control" />

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

## Properties

### GrabberSheet

| Property            | Type                                     | Description                                                                                                                                                                                                                           | Default Value                                |
| ------------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `builder`           | `Widget Function(BuildContext, ScrollController)` | **Required.** Builds the scrollable content of the sheet. Provides a `ScrollController` to be used by the content.                                                                                                    | -                                            |
| `initialChildSize`  | `double`                                 | The initial fractional size of the sheet.                                                                                                                                                                                             | `0.5`                                        |
| `minChildSize`      | `double`                                 | The minimum fractional size of the sheet.                                                                                                                                                                                             | `0.25`                                       |
| `maxChildSize`      | `double`                                 | The maximum fractional size of the sheet.                                                                                                                                                                                             | `1.0`                                        |
| `snap`              | `bool`                                   | If true, the sheet will snap to the nearest snap point after dragging.                                                                                                                                                                | `false`                                      |
| `snapSizes`         | `List<double>?`                          | A list of intermediate fractional sizes to snap to.                                                                                                                                                                                   | `null`                                       |
| `showGrabber`       | `bool`                                   | Whether to show the grabber handle. It is automatically hidden on desktop and web platforms regardless of this value.                                                                                                                 | `true`                                       |
| `grabberStyle`      | `GrabberStyle`                           | The visual style of the grabber handle.                                                                                                                                                                                               | `const GrabberStyle()`                       |
| `bottom`            | `Widget?`                                | A custom widget to display below the grabber and above the main content.                                                                                                                                                              | `null`                                       |
| `bottomAreaPadding` | `EdgeInsetsGeometry?`                    | The padding for the `bottom` widget area.                                                                                                                                                                                             | `null`                                       |
| `backgroundColor`   | `Color?`                                 | The background color of the sheet container. If null, it uses the theme's `colorScheme.surface`.                                                                                   | `Theme.of(context).colorScheme.surface`      |
| `borderRadius`      | `BorderRadiusGeometry?`                  | The border radius of the sheet. If null, defaults to a top-left and top-right radius of 16.0.                                                                                                                                         | `const BorderRadius.vertical(top: Radius.circular(16.0))` |
| `controller`        | `GrabberSheetController?`                | An optional controller to programmatically control the sheet's size and state. Provides `maximize()`, `minimize()`, and all `DraggableScrollableController` methods.                                                                | `null`                                       |
| `onSizeChanged`     | `ValueChanged<double>?`                  | Callback that is called whenever the sheet's fractional size changes (during dragging or animation).                                                                                                                                  | `null`                                       |
| `onSnap`            | `ValueChanged<double>?`                  | Callback that is called when the sheet completes a snap animation and settles at a specific fractional size.                                                                                                                          | `null`                                       |

### GrabberStyle

| Property | Type                 | Description                                       | Default Value                                |
| -------- | -------------------- | ------------------------------------------------- | -------------------------------------------- |
| `color`    | `Color`              | The background color of the grabber handle.       | `Colors.grey`                                |
| `width`    | `double`             | The width of the grabber handle.                  | `48.0`                                       |
| `height`   | `double`             | The height of the grabber handle.                 | `5.0`                                        |
| `radius`   | `Radius`             | The border radius of the grabber handle's corners. | `const Radius.circular(8.0)`                   |
| `margin`   | `EdgeInsetsGeometry` | The margin surrounding the grabber handle.        | `const EdgeInsets.symmetric(vertical: 10.0)` |


## Additional information

To file issues, request features, or contribute, please visit the [GitHub repository](https://github.com/SangWook16074/grabber_sheet).