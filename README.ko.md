# GrabberSheet (한국어)

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

[**English Documentation**](README.md)

A **Google Maps 스타일의 드래그 가능한 Flutter 바텀 시트**입니다.

`grabber_sheet`는 다음이 필요한 앱을 위해 만들어졌습니다.
- **눈에 보이는 그래버 핸들**
- 스크롤 콘텐츠 위에 고정되는 **sticky header 영역**
- 적은 API로 구현하는 **부드러운 크기 조절 + 스크롤 경험**

`DraggableScrollableSheet`를 사용한 뒤, 그래버/헤더/스타일/컨트롤러를 매번 직접 조합해야 했던 경험이 있다면 이 패키지가 그 반복 작업을 줄여줍니다.

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />


## 왜 GrabberSheet를 써야 하나요?

`grabber_sheet`는 단순히 스크롤되는 컨테이너가 아니라, 실제 제품 화면처럼 보이는 시트를 빠르게 만들고 싶을 때 적합합니다.

### 특히 잘 맞는 경우
- 지도 검색 결과 패널
- 장소/주소 검색 플로우
- 배달 / 차량 호출 추적 UI
- 여행 / 탐색형 앱
- 상품 빠른 미리보기 패널

### 기본 제공되는 것
- 내장 **그래버 핸들**
- `header`로 만드는 **sticky 상단 영역**
- 바로 연결되는 `ScrollController`
- 선택적 **snap points**
- `GrabberSheetController` 기반 프로그래밍 제어
- 선택적 **스크림 오버레이**
- 충분한 스타일 커스터마이징

---

## 설치 (Installation)

```bash
flutter pub add grabber_sheet
```

---

## 빠른 시작

스크롤 가능한 콘텐츠를 감싸고, 제공된 컨트롤러를 연결하면 됩니다.

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

이게 핵심 사용법입니다.

---

## 무엇이 다른가요?

| 필요 기능 | 기본 `DraggableScrollableSheet` | `grabber_sheet` |
| :--- | :--- | :--- |
| 눈에 보이는 그래버 핸들 | 직접 구현 | 기본 제공 |
| Sticky header 영역 | 직접 조합 | `header` |
| ScrollController 연결 | 직접 관리 | builder에서 바로 제공 |
| 프로그래밍 제어 | 기본 컨트롤러 | 더 친화적인 helper |
| 제품형 UI 구성 | 조립이 더 필요 | 더 빠르게 구현 가능 |

`grabber_sheet`는 Flutter의 모든 bottom sheet API를 대체하려는 패키지가 아닙니다.  
대신, 이 특정 UI 패턴을 더 빠르고 재사용 가능하게 만드는 데 집중합니다.

---

## 주요 기능

### 1. 내장 그래버

```dart
GrabberSheet(
  builder: (context, controller) {
    return ListView(controller: controller);
  },
)
```

<img width="250" src="https://github.com/user-attachments/assets/8d062fa4-cdda-4445-9d90-b34aa3fce1c5" />

`showGrabber: false`로 숨길 수도 있습니다.

---

### 2. Sticky header 영역

스크롤되지 않고 항상 보이는 제목/액션/필터가 필요하다면 `header`를 사용하세요.

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

### 3. 스냅

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

### 4. 프로그래밍 제어

`GrabberSheetController`로 시트를 열고, 줄이고, 특정 위치로 이동시킬 수 있습니다.

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

<img width="250" src="https://github.com/user-attachments/assets/b90799fa-5db5-4e6a-bb9b-3750198877d7" alt="FAB 제어 GrabberSheet 예시" />

---

### 5. 스크림 오버레이

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

모달처럼 시트에 집중시켜야 하는 UI에 특히 유용합니다.

---

### 6. 데스크톱 / 웹 동작

기본적으로 데스크톱/웹에서는 플랫폼 감각에 맞게 그래버가 숨겨집니다. 필요하면 강제로 보이게 할 수 있습니다.

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

## 주요 속성

| 속성 | 설명 | 기본값 |
| :--- | :--- | :--- |
| `builder` | **필수.** 제공된 `ScrollController`를 연결해 콘텐츠를 빌드합니다. | - |
| `initialChildSize` | 초기 높이 비율. | `0.5` |
| `minChildSize` | 최소 높이 비율. | `0.25` |
| `maxChildSize` | 최대 높이 비율. | `1.0` |
| `snap` | 드래그 후 스냅 활성화. | `false` |
| `snapSizes` | 추가 스냅 지점 목록. | `null` |
| `showGrabber` | 그래버 표시 여부. | `true` |
| `showGrabberOnNonMobile` | 데스크톱/웹에서도 그래버를 계속 표시할지 여부. | `false` |
| `grabberStyle` | 그래버 스타일 설정. | `Default Style` |
| `header` | 그래버 아래 고정되는 sticky 영역. | `null` |
| `headerAreaPadding` | sticky 영역의 패딩. | `null` |
| `backgroundColor` | 시트 배경색. | `Theme.colorScheme.surface` |
| `borderRadius` | 시트 모서리 둥글기. | 상단 16 |
| `controller` | 시트 위치를 코드로 제어. | `null` |
| `onSizeChanged` | 크기 변경 시 호출되는 콜백. | `null` |
| `onSnap` | 스냅 완료 시 호출되는 콜백. | `null` |
| `snapAnimationDuration` | 스냅 애니메이션 지속 시간. | `300ms` |
| `snapAnimationCurve` | 스냅 애니메이션 커브. | `Curves.easeOut` |
| `showScrim` | 배경 스크림 표시 여부. | `false` |
| `scrimColor` | 배경 스크림 색상. | `Colors.black54` |
| `dismissOnScrimTap` | 스크림 탭 시 최소 크기로 줄일지 여부. | `true` |

---

## 이런 경우에 잘 맞습니다

`grabber_sheet`는 다음이 필요할 때 잘 맞습니다.
- 재사용 가능한 **in-page draggable sheet**
- Maps/Search 스타일의 하단 결과 패널
- 기본 제공되는 그래버와 sticky 상단 영역
- 의존성이 매우 적은 패키지

반대로 다음이 필요하면 다른 접근이 더 맞을 수 있습니다.
- 전체 modal route 프레임워크
- 매우 커스텀한 page transition
- 모든 `showModalBottomSheet` 사용처의 완전한 대체

---

## 팁

- builder에서 받은 `ScrollController`를 반드시 스크롤 위젯에 연결하세요.
- 지도나 대시보드 같은 배경 위에 올릴 때는 `Stack` 안에서 사용하는 것이 좋습니다.
- 버튼/선택/지도 이벤트에 따라 시트를 움직여야 한다면 `GrabberSheetController`를 사용하세요.
- `bottom`, `bottomAreaPadding`은 2.0.0에서 제거되었습니다. `header`, `headerAreaPadding`을 사용하세요.

---

## 예시 사용처

- 장소 검색 결과
- 근처 장소 탐색 패널
- 배달 / 차량 호출 상태 시트
- 부동산/상품 미리보기 패널
- 재생목록 / 큐 패널

---

## 기여하기

버그나 기능 제안이 있다면 [GitHub repository](https://github.com/SangWook16074/grabber_sheet)에서 이슈를 열어주세요.
