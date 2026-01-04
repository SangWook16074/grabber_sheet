## 1.2.2

* **Docs**: Refined `README.md` and `README.ko.md` for better clarity and engagement.
  - **Introduction**: Updated to emphasize solving gesture conflicts and the Google Maps inspiration.
  - **Conciseness**: Simplified the "Why GrabberSheet?" section by removing redundant text and focusing on the comparison table.

## 1.2.1

* **Docs**: Comprehensive refactor of `README.md` and `README.ko.md` for high impact and clarity.
  - **Hero Section**: Redesigned to immediately highlight solved pain points (gesture conflicts).
  - **Structure**: Moved "Usage" section to the top for quicker onboarding.
  - **Comparison**: Added a detailed comparison table with `DraggableScrollableSheet`.
  - **Visuals**: Restored and improved screenshots and GIFs for better feature demonstration.

## 1.2.0

* **Feat**: Added `GrabberSheetController` for programmatic control (`maximize`, `minimize`, `animateTo`).
* **Feat**: Added `onSizeChanged` and `onSnap` callbacks for monitoring sheet state.
* **Feat**: Added `borderRadius` property to `GrabberSheet` for customizing sheet corners.
* **Docs**: Reorganized documentation sections for better readability.
* **Docs**: Updated Korean documentation (`README.ko.md`).

## 1.1.3

* **Docs**: Optimized `pubspec.yaml` description for better search visibility on pub.dev.
* **Docs**: Simplified `README.md` and `README.ko.md` introductions for improved readability.

## 1.1.2

* **Docs**: Updated `CHANGELOG.md` to include missing version history.
* **Meta**: Improved package scoring by addressing maintenance issues.

## 1.1.1

* **Docs**: Enhanced discoverability and clarity of package documentation.
* **Meta**: Updated `pubspec.yaml` with clearer description and topics.

## 1.1.0

* **Feature**: Added `showGrabberOnNonMobile` option to allow displaying the grabber handle on desktop and web platforms.

## 1.0.2

* **Fix**: Corrected the CI badge link in the README files to point to the correct workflow.

## 1.0.1

* **Patch**: Optimized the minimum supported versions for Dart and Flutter SDKs.
  - Dart SDK: `>=3.0.0 <4.0.0`
  - Flutter SDK: `>=3.0.0`
* **Fix**: Resolved a syntax error that occurred with the updated SDK versions.
* **Test**: Added comprehensive widget tests for grabber rendering and snap animations, improving test coverage.
* **Refactor**: Redesigned test architecture for better maintainability and scalability.

## 1.0.0

* **New Feature**: Added a `bottom` property to allow adding widgets to the bottom area of the sheet.
* **Docs**: Improved descriptions in `README.md` and `README.ko.md`, and updated example images and sample code.
* **Build**: Added ignored paths to `.gitignore`.

## 0.0.2

* Improved `README.md` with detailed customization instructions and examples.
* Added a Korean version of the README (`README.ko.md`).

## 0.0.1

* Initial release of the `grabber_sheet` package.
* Provides a `GrabberSheet` widget for a customizable draggable bottom sheet.
* Includes a `GrabberStyle` class for customizing the handle.
