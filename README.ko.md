# grabber_sheet (한국어)

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

구글 지도(Google Maps)와 같은 인기 앱의 모달 시트에서 영감을 받은, 커스터마이징 가능한 드래그형 하단 시트(bottom sheet)입니다.

Flutter에 내장된 `DraggableScrollableSheet`를 기반으로, 눈에 띄는 그래버를 추가하고 스크롤 컨트롤러 관리를 단순화하여 예측 가능한 동작을 보장합니다.

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />

## 주요 특징

*   커스터마이징 가능한 그래버(grabber) 핸들이 있는 드래그형 하단 시트
*   스크롤 컨트롤러 충돌 문제를 해결한 안정적이고 예측 가능한 동작
*   빌더(`builder`)를 통해 어떤 위젯이든 시트의 콘텐츠로 사용 가능
*   드래그 가능한 그래버 영역에 커스텀 위젯 삽입 가능
*   시트 크기(초기, 최소, 최대) 조절 가능
*   `snap` 및 `snapSizes`를 통한 스냅 동작 및 사용자 정의 스냅 지점 설정 가능
*   그래버 스타일(색상, 크기, 모양) 커스터마이징 가능
*   시트는 기본적으로 상단에 둥근 모서리를 가집니다.

## 시작하기

`pubspec.yaml` 파일에 아래 의존성을 추가하세요. 최신 버전은 [pub.dev](https://pub.dev/packages/grabber_sheet)에서 확인하실 수 있습니다.

```yaml
dependencies:
  grabber_sheet: ^1.1.0
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

### 스냅 동작 제어하기

`snap` 프로퍼티를 `true`로 설정하면, 사용자가 드래그를 놓았을 때 시트가 가장 가까운 스냅 지점으로 자동으로 부드럽게 이동합니다. 이는 사용자에게 깔끔하고 예측 가능한 움직임을 제공합니다.

스냅 로직은 드래그 제스처에 따라 다르게 동작합니다:

*   **느린 드래그 (Slow Drag):** 사용자가 시트를 천천히 드래그하다 놓으면, 가장 *가까운* 스냅 지점으로 이동합니다.
*   **플링 (Fling):** 사용자가 빠른 제스처로 시트를 "던지면", 던진 방향으로 가장 가까운 경계(`minChildSize` 또는 `maxChildSize`)까지 애니메이션으로 이동합니다.

스냅 지점은 `minChildSize`, `maxChildSize`, 그리고 중간 지점들을 위한 `snapSizes` 프로퍼티로 정의할 수 있습니다.

다음은 여러 개의 중간 스냅 지점을 포함한 예제입니다:

```dart
GrabberSheet(
  // 스냅 기능 활성화
  snap: true, 
  
  // 스냅 지점 정의: 0.2 (최소), 0.5, 0.8 (중간), 1.0 (최대)
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

## 속성 (Properties)

### GrabberSheet

| 프로퍼티            | 타입                                     | 설명                                                                                                                                            | 기본값                                       |
| ------------------- | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `builder`           | `Widget Function(BuildContext, ScrollController)` | **(필수)** 시트의 스크롤 가능한 콘텐츠를 빌드합니다. 콘텐츠에서 사용할 `ScrollController`를 제공합니다.                                     | -                                            |
| `initialChildSize`  | `double`                                 | 시트의 초기 크기 (비율).                                                                                                                        | `0.5`                                        |
| `minChildSize`      | `double`                                 | 시트의 최소 크기 (비율).                                                                                                                        | `0.25`                                       |
| `maxChildSize`      | `double`                                 | 시트의 최대 크기 (비율).                                                                                                                        | `1.0`                                        |
| `snap`              | `bool`                                   | `true`이면 드래그 후 가장 가까운 스냅 지점으로 이동합니다.                                                                                      | `false`                                      |
| `snapSizes`         | `List<double>?`                          | 중간 스냅 지점 목록 (비율).                                                                                                                     | `null`                                       |
| `showGrabber`       | `bool`                                   | 그래버 핸들을 표시할지 여부. `false`로 설정하면 모든 플랫폼에서 핸들이 숨겨집니다.                                                                    | `true`                                       |
| `showGrabberOnNonMobile` | `bool` | 데스크톱 및 웹과 같은 비모바일 플랫폼에서 그래버 핸들을 표시할지 여부. | `false` |
| `grabberStyle`      | `GrabberStyle`                           | 그래버 핸들의 시각적 스타일.                                                                                                                    | `const GrabberStyle()`                       |
| `bottom`            | `Widget?`                                | 그래버 아래, 메인 콘텐츠 위에 표시할 커스텀 위젯.                                                                                               | `null`                                       |
| `bottomAreaPadding` | `EdgeInsetsGeometry?`                    | `bottom` 위젯 영역의 패딩.                                                                                                                      | `null`                                       |
| `backgroundColor`   | `Color?`                                 | 시트 컨테이너의 배경색. `null`이면 테마의 `colorScheme.surface`를 사용합니다. 시트는 기본적으로 16.0의 상단 모서리 반경을 가집니다. | `Theme.of(context).colorScheme.surface`      |

### GrabberStyle

| 프로퍼티 | 타입                 | 설명                               | 기본값                                         |
| -------- | -------------------- | ---------------------------------- | ---------------------------------------------- |
| `color`    | `Color`              | 그래버 핸들의 배경색.              | `Colors.grey`                                  |
| `width`    | `double`             | 그래버 핸들의 너비.                | `48.0`                                         |
| `height`   | `double`             | 그래버 핸들의 높이.                | `5.0`                                          |
| `radius`   | `Radius`             | 그래버 핸들 모서리의 둥글기.       | `const Radius.circular(8.0)`                   |
| `margin`   | `EdgeInsetsGeometry` | 그래버 핸들 주변의 여백.           | `const EdgeInsets.symmetric(vertical: 10.0)` |


## 추가 정보

이슈 제기, 기능 요청, 또는 기여를 원하시면 [GitHub repository](https://github.com/SangWook16074/grabber_sheet)를 방문해주세요.
�� 원하시면 [GitHub repository](https://github.com/SangWook16074/grabber_sheet)를 방문해주세요.
