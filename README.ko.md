# grabber_sheet (한국어)

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

Google 지도와 같은 인기 앱의 모달 시트에서 영감을 받은 재사용 가능하고 사용자 정의 가능한 그래버 핸들이 있는 드래그 가능한 하단 시트입니다.

Flutter의 내장 `DraggableScrollableSheet`의 일반적인 문제점들을 해결합니다:
1.  **독립된 그래버 영역**: 그래버와 헤더가 스크롤 가능한 콘텐츠와 분리되어 있습니다. 헤더를 드래그하면 시트가 움직이고, 콘텐츠를 스크롤하면 리스트가 움직입니다. 더 이상 제스처 충돌로 고생하지 마세요.
2.  **예측 가능한 스냅(Snapping)**: 복잡한 컨트롤러 로직 없이도 원하는 높이에 정확히 멈추게 할 수 있습니다.
3.  **완벽한 연동**: `ListView`, `SingleChildScrollView` 등 모든 스크롤 위젯과 자연스럽게 동작합니다.

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-4b45-bbf83b781104" />

## 왜 GrabberSheet를 사용해야 하나요?

다음과 같은 문제로 고민해 본 적이 있다면 `GrabberSheet`가 정답입니다.
*   스크롤을 내릴 때 그래버가 함께 사라져 버리는 문제
*   헤더를 잡고 끌었는데 시트가 움직이지 않는 문제
*   스냅 애니메이션이 버벅거리거나 부자연스러운 문제

`GrabberSheet`는 인기 있는 모바일 앱들이 사용하는 "모달 바텀 시트" 패턴을 프로덕션 레벨의 품질로 제공합니다.

## 목차

- [주요 특징](#주요-특징)
- [시작하기](#시작하기)
- [호환성](#호환성)
- [기본 사용법](#기본-사용법)
- [고급 커스터마이징](#고급-커스터마이징)
  - [스냅 동작 제어하기](#스냅-동작-제어하기)
  - [그래버 핸들 꾸미기](#그래버-핸들-꾸미기)
  - [그래버 영역에 커스텀 위젯 추가하기](#그래버-영역에-커스텀-위젯-추가하기)
  - [프로그래밍 방식 제어 및 상태 리스닝](#프로그래밍-방식-제어-및-상태-리스닝)
- [속성 (Properties)](#속성-properties)
  - [GrabberSheet](#grabbersheet-1)
  - [GrabberStyle](#grabberstyle-1)
- [추가 정보](#추가-정보)

---

## 주요 특징

*   커스터마이징 가능한 그래버(grabber) 핸들이 있는 드래그형 하단 시트
*   스크롤 컨트롤러 충돌 문제를 해결한 안정적이고 예측 가능한 동작
*   빌더(`builder`)를 통해 어떤 위젯이든 시트의 콘텐츠로 사용 가능
*   드래그 가능한 그래버 영역에 커스텀 위젯 삽입 가능
*   시트 크기(초기, 최소, 최대) 조절 가능
*   `snap` 및 `snapSizes`를 통한 스냅 동작 및 사용자 정의 스냅 지점 설정 가능
*   그래버 스타일(색상, 크기, 모양) 커스터마이징 가능
*   네이티브한 느낌을 위해 데스크톱 및 웹 플랫폼에서는 그래버가 자동으로 숨겨집니다.
*   시트는 기본적으로 상단에 둥근 모서리를 가집니다.
*   **프로그래밍 방식 제어**: `GrabberSheetController`를 사용하여 시트를 `maximize()`, `minimize()`하거나 특정 크기로 `animateTo()`할 수 있습니다.
*   **상태 콜백**: 드래그/리사이징 중 `onSizeChanged` 알림을 받고, 시트가 스냅 지점에 멈췄을 때 `onSnap` 알림을 받을 수 있습니다.

## 시작하기

`pubspec.yaml` 파일에 아래 의존성을 추가하세요. 최신 버전은 [pub.dev](https://pub.dev/packages/grabber_sheet)에서 확인하실 수 있습니다.

```yaml
dependencies:
  grabber_sheet: ^1.1.3
```

그 다음, 터미널에서 `flutter pub get`을 실행하여 패키지를 설치합니다.

## 호환성

이 패키지는 다음 SDK 버전과 호환됩니다:
*   **Flutter**: `>=3.0.0`
*   **Dart**: `>=3.0.0 <4.0.0`

## 기본 사용법

`GrabberSheet`의 간단한 사용 예제입니다.

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

## 고급 커스터마이징

### 그래버 영역에 커스텀 위젯 추가하기

`bottom` 프로퍼티를 사용하면 드래그 가능한 그래버 핸들 아래에 커스텀 위젯을 삽입할 수 있습니다. 핸들과 커스텀 위젯을 포함한 이 전체 영역을 드래그하여 시트를 조작할 수 있습니다. 이 기능은 제목, 액션 버튼 등 스크롤 영역과 분리되어 항상 보여야 하는 정보를 추가할 때 유용합니다.

`bottomAreaPadding` 프로퍼티를 사용하여 이 커스텀 위젯 주변에 패딩을 추가할 수 있습니다.

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

### 그래버 핸들 꾸미기

그래버 핸들의 모양은 `grabberStyle` 프로퍼티를 통해 자유롭게 변경할 수 있습니다.

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
    // ... Your content
  },
),
```

<img width="250" src="https://github.com/user-attachments/assets/8d062fa4-cdda-4445-9d90-b34aa3fce1c5" />


`showGrabber: false`로 설정하여 그래버를 완전히 숨길 수도 있습니다.

<img width="250" src="https://github.com/user-attachments/assets/20d589b5-54c3-4da3-b420-0c1b10f3e9ef" />

### 데스크톱 및 웹에서 그래버 표시하기

기본적으로 그래버 핸들은 모바일 플랫폼(iOS, Android)에서만 표시됩니다. 하지만 `showGrabberOnNonMobile` 속성을 `true`로 설정하면 데스크톱(Windows, macOS, Linux) 및 웹 플랫폼에서도 그래버를 항상 표시하도록 강제할 수 있습니다. 이는 모든 플랫폼에서 일관된 UI를 제공하고자 할 때 유용합니다.

```dart
GrabberSheet(
  showGrabberOnNonMobile: true,
  builder: (context, scrollController) {
    // ... Your content
  },
),
```

![grabber_sheet_web](https://github.com/user-attachments/assets/c151bdad-254b-455b-b82a-1308b8863784)

### 스냅 동작 제어하기

`snap` 프로퍼티를 `true`로 설정하면, 사용자가 드래그를 놓았을 때 시트가 가장 가까운 스냅 지점으로 자동으로 부드럽게 이동합니다. 이는 사용자에게 깔끔하고 예측 가능한 움직임을 제공합니다.

스냅 로직은 드래그 제스처에 따라 다르게 동작합니다:

*   **느린 드래그 (Slow Drag):** 사용자가 시트를 천천히 드래그하다 놓으면, 가장 *가까운* 스냅 지점으로 이동합니다.
*   **플링 (Fling):** 사용자가 빠른 제스처로 시트를 "던지면", 던진 방향으로 가장 가까운 경계(`minChildSize` 또는 `maxChildSize`)까지 애니메이션으로 이동합니다.

스냅 지점은 `minChildSize`, `maxChildSize`, 그리고 중간 지점들을 위한 `snapSizes` 프로퍼티로 정의할 수 있습니다.

다음은 여러 개의 중간 스냅 지점을 포함한 예제입니다:

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

### 그래버 핸들 꾸미기

그래버 핸들의 모양은 `grabberStyle` 프로퍼티를 통해 자유롭게 변경할 수 있습니다.

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
    // ... Your content
  },
),
```

<img width="250" src="https://github.com/user-attachments/assets/8d062fa4-cdda-4445-9d90-b34aa3fce1c5" />


`showGrabber: false`로 설정하여 그래버를 완전히 숨길 수도 있습니다.

<img width="250" src="https://github.com/user-attachments/assets/20d589b5-54c3-4da3-b420-0c1b10f3e9ef" />

### 그래버 영역에 커스텀 위젯 추가하기

`bottom` 프로퍼티를 사용하면 드래그 가능한 그래버 핸들 아래에 커스텀 위젯을 삽입할 수 있습니다. 핸들과 커스텀 위젯을 포함한 이 전체 영역을 드래그하여 시트를 조작할 수 있습니다. 이 기능은 제목, 액션 버튼 등 스크롤 영역과 분리되어 항상 보여야 하는 정보를 추가할 때 유용합니다.

`bottomAreaPadding` 프로퍼티를 사용하여 이 커스텀 위젯 주변에 패딩을 추가할 수 있습니다.

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

### 프로그래밍 방식 제어 및 상태 리스닝

`GrabberSheetController`를 사용하여 시트의 위치를 코드로 제어하고, 상태 변화 콜백을 통해 UI를 업데이트할 수 있습니다.

**주요 메서드:**
*   `maximize()`: 시트를 `maxChildSize`(최대 크기)로 부드럽게 이동시킵니다.
*   `minimize()`: 시트를 `minChildSize`(최소 크기)로 부드럽게 이동시킵니다.
*   `animateTo(double size)`: 시트를 지정된 `size`(비율)로 이동시킵니다.

**상태 콜백:**
*   `onSizeChanged`: 시트의 크기가 변경될 때마다(드래그 또는 애니메이션 중) 호출됩니다. 드래그 진행 상황에 따라 UI를 반응형으로 업데이트할 때 유용합니다.
*   `onSnap`: 시트가 특정 스냅 지점에 멈췄을 때 호출됩니다.

전체 구현 코드는 `example/lib/main.dart`에서 확인할 수 있습니다.

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
<img width="250" src="https://github.com/user-attachments/assets/b90799fa-5db5-4e6a-bb9b-3750198877d7" alt="FAB 제어 GrabberSheet 예시" />

## 속성 (Properties)

### GrabberSheet

| 프로퍼티            | 타입                                     | 설명                                                                                                                                                                                                                           | 기본값                                       |
| ------------------- | ---------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `builder`           | `Widget Function(BuildContext, ScrollController)` | **(필수)** 시트의 스크롤 가능한 콘텐츠를 빌드합니다. 콘텐츠에서 사용할 `ScrollController`를 제공합니다.                                                                                                    | -                                            |
| `initialChildSize`  | `double`                                 | 시트의 초기 크기 (비율).                                                                                                                                                                                                                            | `0.5`                                        |
| `minChildSize`      | `double`                                 | 시트의 최소 크기 (비율).                                                                                                                                                                                                                            | `0.25`                                       |
| `maxChildSize`      | `double`                                 | 시트의 최대 크기 (비율).                                                                                                                                                                                                                            | `1.0`                                        |
| `snap`              | `bool`                                   | `true`이면 드래그 후 가장 가까운 스냅 지점으로 이동합니다.                                                                                                                                                                | `false`                                      |
| `snapSizes`         | `List<double>?`                          | 중간 스냅 지점 목록 (비율).                                                                                                                                                                                                                  | `null`                                       |
| `showGrabber`       | `bool`                                   | 그래버 핸들을 표시할지 여부. 이 값과 관계없이 데스크톱 및 웹에서는 자동으로 숨겨집니다.                                                                                                                                                                | `true`                                       |
| `grabberStyle`      | `GrabberStyle`                           | 그래버 핸들의 시각적 스타일.                                                                                                                                                                                                                              | `const GrabberStyle()`                       |
| `bottom`            | `Widget?`                                | 그래버 아래, 메인 콘텐츠 위에 표시할 커스텀 위젯.                                                                                                                                                                                                                            | `null`                                       |
| `bottomAreaPadding` | `EdgeInsetsGeometry?`                    | `bottom` 위젯 영역의 패딩.                                                                                                                                                                                                                            | `null`                                       |
| `backgroundColor`   | `Color?`                                 | 시트 컨테이너의 배경색. `null`이면 테마의 `colorScheme.surface`를 사용합니다. 시트는 기본적으로 16.0의 상단 모서리 반경을 가집니다.                                                                                                                  | `Theme.of(context).colorScheme.surface`      |
| `controller`        | `GrabberSheetController?`                | 시트의 크기와 상태를 프로그래밍 방식으로 제어하기 위한 선택적 컨트롤러입니다. `maximize()`, `minimize()` 및 모든 `DraggableScrollableController` 메서드를 제공합니다.                                                                | `null`                                       |
| `onSizeChanged`     | `ValueChanged<double>?`                  | 시트의 비율 크기가 변경될 때마다(드래그 또는 애니메이션 중) 호출되는 콜백입니다.                                                                                                                                                                 | `null`                                       |
| `onSnap`            | `ValueChanged<double>?`                  | 시트가 스냅 애니메이션을 완료하고 특정 비율 크기에 안착했을 때 호출되는 콜백입니다.                                                                                                                                                         | `null`                                       |

### GrabberStyle

| 프로퍼티 | 타입                 | 설명                               | 기본값                                       |
| -------- | -------------------- | ---------------------------------- | -------------------------------------------- |
| `color`    | `Color`              | 그래버 핸들의 배경색.              | `Colors.grey`                                |
| `width`    | `double`             | 그래버 핸들의 너비.                | `48.0`                                       |
| `height`   | `double`             | 그래버 핸들의 높이.                | `5.0`                                        |
| `radius`   | `Radius`             | 그래버 핸들 모서리의 둥글기.       | `const Radius.circular(8.0)`                   |
| `margin`   | `EdgeInsetsGeometry` | 그래버 핸들 주변의 여백.           | `const EdgeInsets.symmetric(vertical: 10.0)` |


## 추가 정보

이슈 제기, 기능 요청, 또는 기여를 원하시면 [GitHub repository](https://github.com/SangWook16074/grabber_sheet)를 방문해주세요.
