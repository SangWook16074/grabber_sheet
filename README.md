# GrabberSheet

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

[**한국어 문서 (Korean Docs)**](README.ko.md)

A **Google Maps-style draggable bottom sheet for Flutter**.

`grabber_sheet` is built for apps that need a polished bottom surface with:
- a **visible drag handle**
- a **sticky header area** above the scrollable content
- **smooth resizing + scrolling** with a small, simple API

If you have ever used `DraggableScrollableSheet` and then had to manually wire the handle, header, styling, and controller behavior around it, this package is for you.

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />

## Why use GrabberSheet?

Use `grabber_sheet` when you want a sheet that feels like a real product surface, not just a scrollable container.

### Best for
- map result panels
- place or address search flows
- ride / delivery tracking UIs
- travel and discovery apps
- product quick-view panels

### You get out of the box
- built-in **grabber handle**
- **sticky top area** via `header`
- integrated `ScrollController` handoff
- optional **snap points**
- programmatic control with `GrabberSheetController`
- optional **scrim overlay**
- customizable styling

---

## Installation

```bash
flutter pub add grabber_sheet
```

---

## Quick start

Wrap your scrollable content and use the provided controller.

```dart
GrabberSheet(
  snap: true,
  builder: (context, controller) {
    return ListView.builder(
      controller: controller,
      itemCount: 30,
      itemBuilder: (context, index) {
        return ListTile(title: Text('Place $index'));
      },
    );
  },
)
```

That is the core setup.

---

## What makes it different?

| Need | Plain `DraggableScrollableSheet` | `grabber_sheet` |
| :--- | :--- | :--- |
| Visible drag handle | Build it yourself | Built in |
| Sticky header area | Compose manually | `header` |
| Scroll controller wiring | Manual care required | Builder gives it directly |
| Programmatic surface control | Basic controller | Friendly controller helpers |
| Product-style setup | More assembly | Faster to ship |

`grabber_sheet` does **not** try to replace every bottom-sheet API in Flutter.
It focuses on one thing: making this specific UI pattern easy and reusable.

---

## Feature highlights

### 1. Built-in grabber

```dart
GrabberSheet(
  grabberStyle: GrabberStyle(
    width: 60,
    height: 6,
    color: Colors.grey.shade300,
    radius: const Radius.circular(12),
  ),
  builder: (context, controller) {
    return ListView(controller: controller);
  },
)
```

<img width="250" src="https://github.com/user-attachments/assets/8d062fa4-cdda-4445-9d90-b34aa3fce1c5" />

You can also hide it with `showGrabber: false`.

---

### 2. Sticky header area

Use `header` for content that should stay visible above the scrollable list.

```dart
GrabberSheet(
  header: Row(
    children: const [
      Text('Locations'),
      Spacer(),
      CloseButton(),
    ],
  ),
  builder: (context, controller) {
    return ListView(controller: controller);
  },
)
```

<img width="250" src="https://github.com/user-attachments/assets/669f7506-2b92-408f-a239-240ac68ca621" />

---

### 3. Snapping

```dart
GrabberSheet(
  snap: true,
  minChildSize: 0.2,
  maxChildSize: 1.0,
  snapSizes: const [0.5, 0.8],
  builder: (context, controller) {
    return ListView(controller: controller);
  },
)
```

![snap gif](https://github.com/user-attachments/assets/3727d83a-456b-4fd9-a721-8ad3e2116005)

---

### 4. Programmatic control

```dart
final controller = GrabberSheetController();

GrabberSheet(
  controller: controller,
  builder: (context, scrollController) {
    return ListView(controller: scrollController);
  },
);

controller.maximize();
controller.minimize();
controller.animateTo(0.5);
```

<img width="250" src="https://github.com/user-attachments/assets/b90799fa-5db5-4e6a-bb9b-3750198877d7" alt="GrabberSheet controller example" />

---

### 5. Scrim overlay

```dart
GrabberSheet(
  showScrim: true,
  scrimColor: Colors.black54,
  dismissOnScrimTap: true,
  builder: (context, controller) {
    return ListView(controller: controller);
  },
)
```

Great for modal-feeling interfaces where the sheet should draw focus.

---

### 6. Desktop and web behavior

By default, the grabber is hidden on desktop and web for a more platform-appropriate feel.
If you want it visible anyway:

```dart
GrabberSheet(
  showGrabberOnNonMobile: true,
  builder: (context, controller) {
    return ListView(controller: controller);
  },
)
```

![grabber_sheet_web](https://github.com/user-attachments/assets/c151bdad-254b-455b-b82a-1308b8863784)

---

## Main properties

| Property | Description | Default |
| :--- | :--- | :--- |
| `builder` | **Required.** Build your scrollable content with the provided `ScrollController`. | - |
| `initialChildSize` | Initial height fraction. | `0.5` |
| `minChildSize` | Minimum height fraction. | `0.25` |
| `maxChildSize` | Maximum height fraction. | `1.0` |
| `snap` | Enable snapping after drag. | `false` |
| `snapSizes` | Additional snap points. | `null` |
| `showGrabber` | Show or hide the grabber. | `true` |
| `showGrabberOnNonMobile` | Force the grabber to remain visible on desktop/web. | `false` |
| `grabberStyle` | Customize the grabber appearance. | `Default Style` |
| `header` | Sticky area below the grabber. | `null` |
| `headerAreaPadding` | Padding for the sticky area. | `null` |
| `backgroundColor` | Sheet background color. | `Theme.colorScheme.surface` |
| `borderRadius` | Sheet border radius. | top corners 16 |
| `controller` | Programmatic sheet control. | `null` |
| `onSizeChanged` | Called whenever the size changes. | `null` |
| `onSnap` | Called when a snap animation completes. | `null` |
| `snapAnimationDuration` | Snap animation duration. | `300ms` |
| `snapAnimationCurve` | Snap animation curve. | `Curves.easeOut` |
| `showScrim` | Show a background scrim behind the sheet. | `false` |
| `scrimColor` | Scrim color. | `Colors.black54` |
| `dismissOnScrimTap` | Minimize the sheet when tapping the scrim. | `true` |

---

## When to use this package

Choose `grabber_sheet` if you want:
- a reusable **in-page** draggable sheet
- a Maps-like or Search-like bottom surface
- a built-in handle and sticky top area
- a package with very low dependency overhead

You may want another solution if you need:
- a full modal route framework
- highly custom page transitions
- a drop-in replacement for every `showModalBottomSheet` use case

---

## Tips

- Always connect the provided `ScrollController` to your scrollable child.
- Put `GrabberSheet` inside a `Stack` when layering over background content such as maps or dashboards.
- Use `GrabberSheetController` when the sheet must react to buttons, selections, or map events.
- `bottom` and `bottomAreaPadding` are still supported for backward compatibility, but `header` and `headerAreaPadding` are now the preferred names.

---

## Example use cases

- location search results
- nearby places panel
- courier or ride status sheet
- property listing preview
- media queue / playlist drawer

---

## Contributing

Found a bug or have a feature request?
Please open an issue on the [GitHub repository](https://github.com/SangWook16074/grabber_sheet).
