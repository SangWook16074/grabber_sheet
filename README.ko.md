# grabber_sheet (한국어)

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

구글 지도(Google Maps)와 같은 인기 앱의 모달 시트에서 영감을 받은, 커스터마이징 가능한 드래그형 하단 시트(bottom sheet)입니다.

Flutter에 내장된 `DraggableScrollableSheet`를 기반으로, 눈에 띄는 그래버를 추가하고 스크롤 컨트롤러 관리를 단순화하여 예측 가능한 동작을 보장합니다.

![GrabberSheet Demo](https://github.com/user-attachments/assets/dcf2b6bf-1d5f-4826-9c8c-0fe3ca13e472)

## 주요 특징

*   커스터마이징 가능한 그래버(grabber) 핸들이 있는 드래그형 하단 시트
*   스크롤 컨트롤러 충돌 문제를 해결한 안정적이고 예측 가능한 동작
*   빌더(`builder`)를 통해 어떤 위젯이든 시트의 콘텐츠로 사용 가능
*   시트 크기(초기, 최소, 최대) 조절 가능
*   `snap` 및 `snapSizes`를 통한 스냅 동작 및 사용자 정의 스냅 지점 설정 가능
*   그래버 스타일(색상, 크기, 모양) 커스터마이징 가능
*   네이티브한 느낌을 위해 데스크톱 및 웹 플랫폼에서는 그래버가 자동으로 숨겨집니다.
*   시트는 기본적으로 상단에 둥근 모서리를 가집니다.

## 시작하기

`pubspec.yaml` 파일에 아래 의존성을 추가하세요. 최신 버전은 [pub.dev](https://pub.dev/packages/grabber_sheet)에서 확인하실 수 있습니다.

```yaml
dependencies:
  grabber_sheet: ^latest # pub.dev의 최신 버전으로 교체하세요
```

그 다음, 터미널에서 `flutter pub get`을 실행하여 패키지를 설치합니다.

## 기본 사용법

`GrabberSheet`의 간단한 사용 예제입니다.

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

## 고급 커스터마이징

### 스냅 동작 제어하기

`snap` 프로퍼티를 `true`로 설정하면, 사용자가 드래그를 놓았을 때 시트가 가장 가까운 스냅 지점으로 자동으로 부드럽게 이동합니다. 이 "스냅 애니메이션"은 깔끔한 사용자 경험을 제공합니다.

스냅 지점은 `minChildSize`, `maxChildSize`, `initialChildSize`와, 중간 지점을 위한 `snapSizes` 프로퍼티로 정의할 수 있습니다.

```dart
GrabberSheet(
  snap: true, // 스냅 기능 활성화
  // 스냅 지점 정의: 0.2 (최소), 0.6 (중간), 0.9 (최대)
  minChildSize: 0.2,
  maxChildSize: 0.9,
  snapSizes: const [0.6],
  builder: (context, scrollController) {
    // ... Your content
  },
),
```

![Controlling Snap Behavior](https://github.com/user-attachments/assets/fade4285-24e1-4d76-8fce-db80a32ffbe3)


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

<img width="250" alt="Simulator Screenshot - iPhone 16 Pro - 2025-11-16 at 22 10 52" src="https://github.com/user-attachments/assets/a0d21d18-f7e8-47b6-b30e-8f36a067de7f" />


`showGrabber: false`로 설정하여 그래버를 완전히 숨길 수도 있습니다.

<img width="250" alt="Simulator Screenshot - iPhone 16 Pro - 2025-11-16 at 22 11 57" src="https://github.com/user-attachments/assets/2b9a299b-81e5-4170-91c1-3b3308d5fe9d" />

## 속성 (Properties)

### GrabberSheet

| 프로퍼티         | 타입                                     | 설명                                                                                                                                            | 기본값                                       |
| ------------------ | ---------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------- | -------------------------------------------- |
| `builder`          | `Widget Function(BuildContext, ScrollController)` | **(필수)** 시트의 스크롤 가능한 콘텐츠를 빌드합니다. 콘텐츠에서 사용할 `ScrollController`를 제공합니다.                                     | -                                            |
| `initialChildSize` | `double`                                 | 시트의 초기 크기 (비율).                                                                                                                        | `0.5`                                        |
| `minChildSize`     | `double`                                 | 시트의 최소 크기 (비율).                                                                                                                        | `0.25`                                       |
| `maxChildSize`     | `double`                                 | 시트의 최대 크기 (비율).                                                                                                                        | `1.0`                                        |
| `snap`             | `bool`                                   | `true`이면 드래그 후 가장 가까운 스냅 지점으로 이동합니다.                                                                                      | `false`                                      |
| `snapSizes`        | `List<double>?`                          | 중간 스냅 지점 목록 (비율).                                                                                                                     | `null`                                       |
| `showGrabber`      | `bool`                                   | 그래버 핸들을 표시할지 여부. 이 값과 관계없이 데스크톱 및 웹에서는 자동으로 숨겨집니다.                                                          | `true`                                       |
| `grabberStyle`     | `GrabberStyle`                           | 그래버 핸들의 시각적 스타일.                                                                                                                    | `const GrabberStyle()`                       |
| `backgroundColor`  | `Color?`                                 | 시트 컨테이너의 배경색. `null`이면 테마의 `colorScheme.surface`를 사용합니다. 시트는 기본적으로 16.0의 상단 모서리 반경을 가집니다. | `Theme.of(context).colorScheme.surface`      |

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
