# GrabberSheet (한국어)

**제스처 충돌과 싸우지 마세요. 완벽하게 동작하는 그래버가 포함된 상용 수준의 바텀 시트입니다.**

<img width="250" src="https://github.com/user-attachments/assets/cc2a3eaf-c872-46f1-8b45-bbf83b781104" />

[![pub.dev](https://img.shields.io/pub/v/grabber_sheet.svg)](https://pub.dev/packages/grabber_sheet)
[![Test](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml/badge.svg)](https://github.com/SangWook16074/grabber_sheet/actions/workflows/ci.yml)
[![codecov](https://codecov.io/gh/SangWook16074/grabber_sheet/branch/main/graph/badge.svg)](https://codecov.io/gh/SangWook16074/grabber_sheet)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/SangWook16074/grabber_sheet/blob/main/LICENSE)

[**English Documentation**](README.md)

---

## 🚀 설치 (Installation)

```bash
flutter pub add grabber_sheet
```

## ⚡ 3줄로 끝내는 사용법

리스트를 감싸고, 컨트롤러만 연결하면 **끝입니다.**

```dart
GrabberSheet(
  snap: true,
  builder: (context, controller) {
    return ListView.builder(
      controller: controller, // <--- 핵심: 이 컨트롤러를 연결하세요!
      itemBuilder: (context, index) => ListTile(title: Text('Item $index')),
    );
  },
)
```

---

## 💡 왜 GrabberSheet 인가요?

`DraggableScrollableSheet`를 쓰면서 **스크롤과 드래그가 싸우는 경험**, 다들 겪어보셨을 겁니다.
리스트를 내리고 싶은데 시트가 내려가고, 헤더는 겹치고, 애니메이션은 부자연스럽죠.

`GrabberSheet`는 이 개발자의 고통을 즉시 해결합니다.

| Pain Point (문제점) | DraggableScrollableSheet | GrabberSheet |
| :--- | :---: | :---: |
| **제스처 충돌** | ⚠️ 스크롤 vs 드래그 싸움 | ✅ **충돌 없음** (완벽한 제스처 분리) |
| **헤더 / 그래버** | ❌ 직접 구현해야 함 (어려움) | ✅ **기본 내장 & 고정됨** |
| **스냅(Snap) 동작** | ⚠️ 복잡한 수학 계산 필요 | ✅ **속성 하나로 끝** (`snap: true`) |
| **개발 경험** | 🔥 스트레스 유발 | 🍰 **Plug & Play (즉시 사용)** |

---

## 🎨 고급 커스터마이징

### 1. 스마트 스냅 (Smart Snapping)
`snap: true`만 켜면, **천천히 놓을 때(가까운 위치)**와 **빠르게 던질 때(관성)**를 자동으로 구분하여 자연스럽게 붙습니다.

```dart
GrabberSheet(
  snap: true,
  minChildSize: 0.2,
  maxChildSize: 1.0,
  snapSizes: const [0.5], // 중간 스냅 지점 추가
  // ...
)
```

![snap gif](https://github.com/user-attachments/assets/3727d83a-456b-4fd9-a721-8ad3e2116005)

### 2. 그래버 스타일링
앱의 디자인 시스템에 맞춰 그래버의 크기, 색상, 모양을 자유롭게 변경하세요.

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

그래버를 완전히 숨길 수도 있습니다 (`showGrabber: false`).

<img width="250" src="https://github.com/user-attachments/assets/20d589b5-54c3-4da3-b420-0c1b10f3e9ef" />

### 3. 고정 헤더 (제목/버튼 영역)
스크롤되지 않고 **항상 보이는** 제목이나 닫기 버튼이 필요하신가요? `bottom` 속성을 사용하세요.

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

### 4. 프로그래밍 제어 (Controller)
코드로 시트를 열거나 닫고, 특정 위치로 이동시킬 수 있습니다.

```dart
final controller = GrabberSheetController();

// ...
controller.maximize(); // 최대 크기로
controller.minimize(); // 최소 크기로
controller.animateTo(0.5); // 50% 지점으로 이동
```

<img width="250" src="https://github.com/user-attachments/assets/b90799fa-5db5-4e6a-bb9b-3750198877d7" alt="FAB 제어 GrabberSheet 예시" />

### 5. 데스크톱 & 웹 지원
기본적으로 데스크톱/웹에서는 그래버가 숨겨집니다(플랫폼 표준). 필요하다면 강제로 표시할 수 있습니다.

```dart
GrabberSheet(
  showGrabberOnNonMobile: true,
  // ...
)
```

![grabber_sheet_web](https://github.com/user-attachments/assets/c151bdad-254b-455b-b82a-1308b8863784)

---

## 📘 속성 (Properties)

| 속성 | 설명 | 기본값 |
| :--- | :--- | :--- |
| `builder` | **(필수)** 콘텐츠 빌더. 제공된 `ScrollController`를 반드시 사용해야 합니다. | - |
| `snap` | 자동 스냅 기능 활성화. | `false` |
| `initialChildSize` | 초기 높이 비율 (0.0 - 1.0). | `0.5` |
| `minChildSize` | 최소 높이 비율. | `0.25` |
| `maxChildSize` | 최대 높이 비율. | `1.0` |
| `snapSizes` | 중간 스냅 지점 목록 (예: `[0.5, 0.8]`). | `null` |
| `showGrabber` | 그래버 핸들 표시 여부. | `true` |
| `grabberStyle` | 그래버의 너비, 높이, 색상, 둥글기, 마진 설정. | `Default Style` |
| `bottom` | 그래버 아래 고정될 위젯 (제목, 버튼 등). | `null` |
| `controller` | 시트 위치를 코드로 제어. | `null` |
| `onSizeChanged` | 크기 변경 시 호출되는 콜백. | `null` |
| `onSnap` | 스냅 완료 시 호출되는 콜백. | `null` |

---

## 🤝 기여하기

버그를 발견하셨거나 기능 제안이 있으시다면 [GitHub repository](https://github.com/SangWook16074/grabber_sheet)를 방문해주세요.