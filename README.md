# grabber_sheet

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

A reusable and customizable draggable bottom sheet with a grabber handle, inspired by the modal sheets in popular apps like Google Maps.

This package provides a `GrabberSheet` widget that is easy to use and customize.

## Features

* Draggable bottom sheet with a customizable grabber handle.
* Stable and predictable behavior, fixing common scroll controller conflicts.
* Use any widget as the content of the sheet via a builder.
* Customize sheet sizes (initial, min, max).
* Optional snapping behavior with custom snap points via `snap` and `snapSizes`.
* Customize grabber style (color, size, shape).

## Getting started

Add this to your package's `pubspec.yaml` file. Check the latest version on [pub.dev](https://pub.dev/packages/grabber_sheet).

```yaml
dependencies:
  grabber_sheet: ^1.0.0 # Replace with the latest version from pub.dev
```

Then, install it by running `flutter pub get` in your terminal.

## Usage

Here's a simple example of how to use `GrabberSheet` with snapping enabled:

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
            snap: true,
            snapSizes: const [0.5], // Add an intermediate snap point
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

For a more detailed example, see the `/example` folder included in the package.

## Additional information

To file issues, request features, or contribute, please visit the [GitHub repository](https://github.com/SangWook16074/grabber_sheet).
