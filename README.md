# GrabberSheet

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

[**한국어 문서 (Korean Docs)**](README.ko.md)

A reusable and customizable draggable bottom sheet for Flutter, inspired by the modal sheet in the Google Maps app.

When building UIs with bottom sheets, developers often face the repetitive task of manually implementing drag handling and scroll physics. `grabber_sheet` solves this by providing a pre-built, robust drag mechanism that works seamlessly with your content, while offering extensive customization options to fit any design.

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />


## 🚀 Installation

```bash
flutter pub add grabber_sheet
```

## ⚡ Simple Usage

Wrap your list, connect the controller. **Done.**

```dart
GrabberSheet(
  snap: true,
  builder: (context, controller) {
    return ListView.builder(
      controller: controller, // <--- Key Step: Connect this!
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    );
  },
)
```

---

## 💡 Why GrabberSheet?

| Pain Point | DraggableScrollableSheet | GrabberSheet |
| :--- | :---: | :---: |
| **Gesture Conflicts** | ⚠️ Scrolls when you want to Drag | ✅ **Zero Conflict** (Perfectly separated) |
| **Header / Grabber** | ❌ Build it yourself (Hard) | ✅ **Built-in & Persistent** |
| **Snapping** | ⚠️ Complex math required | ✅ **One Parameter** (`snap: true`) |
| **Dev Experience** | 🔥 Frustrating | 🍰 **Plug & Play** |

---

## 🎨 Advanced Customization

### 1. Smart Snapping
Enable `snap: true` for a polished feel. It handles both **slow drags** (closest point) and **fast flings** (momentum) automatically.

```dart
GrabberSheet(
  snap: true,
  minChildSize: 0.2,
  maxChildSize: 1.0,
  snapSizes: const [0.5], // Add intermediate snap points
  // ...
)
```

![snap gif](https://github.com/user-attachments/assets/3727d83a-456b-4fd9-a721-8ad3e2116005)

### 2. Custom Grabber Styling
Match your app's design system effortlessly.

```dart
GrabberSheet(
  grabberStyle: GrabberStyle(
    width: 60,
    height: 6,
    color: Colors.grey.shade300,
    radius: const Radius.circular(12),
  ),
  // ...
)
```

<img width="250" src="https://github.com/user-attachments/assets/8d062fa4-cdda-4445-9d90-b34aa3fce1c5" />

You can also hide the grabber completely (`showGrabber: false`).

<img width="250" src="https://github.com/user-attachments/assets/20d589b5-54c3-4da3-b420-0c1b10f3e9ef" />

### 3. Fixed Header (Non-Scrollable Area)
Need a title or close button that **always** stays visible? Use the `bottom` property.

```dart
GrabberSheet(
  bottom: Row(
    children: [
      Text('Locations', style: TextStyle(fontSize: 18)),
      Spacer(),
      CloseButton(),
    ],
  ),
  // ...
)
```

<img width="250" src="https://github.com/user-attachments/assets/669f7506-2b92-408f-a239-240ac68ca621" />

### 4. Programmatic Control
Open, close, or snap to specific sizes using `GrabberSheetController`.

```dart
final controller = GrabberSheetController();

// ...
controller.maximize(); // Go to maxChildSize
controller.minimize(); // Go to minChildSize
controller.animateTo(0.5); // Go to 50%
```

<img width="250" src="https://github.com/user-attachments/assets/b90799fa-5db5-4e6a-bb9b-3750198877d7" alt="Example of GrabberSheet with FAB control" />

### 5. Desktop & Web Support
By default, the grabber is hidden on desktop/web (standard UI pattern). Force it visible if needed:

```dart
GrabberSheet(
  showGrabberOnNonMobile: true,
  // ...
)
```

![grabber_sheet_web](https://github.com/user-attachments/assets/631bc09f-b4a4-4736-8df4-a52501e6c192)

---

## 📘 Properties

| Property | Description | Default |
| :--- | :--- | :--- |
| `builder` | **(Required)** Builds content. Must use the provided `ScrollController`. | - |
| `snap` | Enable auto-snapping behavior. | `false` |
| `initialChildSize` | Starting height fraction (0.0 - 1.0). | `0.5` |
| `minChildSize` | Minimum collapsed height. | `0.25` |
| `maxChildSize` | Maximum expanded height. | `1.0` |
| `snapSizes` | List of intermediate snap points (e.g. `[0.5, 0.8]`). | `null` |
| `showGrabber` | Toggle the grabber handle visibility. | `true` |
| `grabberStyle` | Customize width, height, color, radius, margin. | `Default Style` |
| `bottom` | Widget to display below grabber (Title, Buttons, etc.). | `null` |
| `controller` | Control sheet position programmatically. | `null` |
| `onSizeChanged` | Callback for size changes during drag/animation. | `null` |
| `onSnap` | Callback when snapping completes. | `null` |

---

## 🤝 Contribution

Found a bug or have a feature request? Please visit the [GitHub repository](https://github.com/SangWook16074/grabber_sheet).