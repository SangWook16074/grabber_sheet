# grabber_sheet Growth Strategy

## Positioning Thesis

`grabber_sheet` should not compete as a generic “bottom sheet package”.
It should own a narrower, higher-intent category:

> **The easiest Google Maps-style bottom sheet for Flutter**

That means the package should be known for three things:

1. **Persistent drag handle**
2. **Sticky header area above scrollable content**
3. **Polished scroll + resize experience with minimal setup**

This category is easier to explain, easier to demo, and easier to distribute than a broad “custom sheet” message.

---

## Current Strengths

- Small API surface and low cognitive load
- Clean implementation with passing tests and CI
- Good visual documentation in the main README
- Useful feature set for real apps:
  - custom grabber styling
  - fixed header (`bottom`)
  - controller-based sheet control
  - scrim support
  - snap animation customization
- Very low dependency risk

---

## Current Risks

### 1. Positioning is too broad
Competing on “draggable bottom sheet” alone makes the package look interchangeable with Flutter built-ins and established packages.

### 2. Differentiation is under-explained
The real value is not “sheet support”.
The real value is a **ready-made app pattern** for map/search/result surfaces.

### 3. Distribution is weaker than implementation
The package appears better engineered than its current adoption suggests.
The bottleneck is likely packaging, examples, and audience targeting.

### 4. Desktop/web story is serviceable but not compelling
The current message says support exists, but the product is still primarily mobile-first.

---

## Ideal Users

### Primary
- Flutter developers building:
  - maps
  - place search
  - ride hailing
  - delivery tracking
  - travel discovery
  - real-estate browsing

### Secondary
- Developers who want `DraggableScrollableSheet` behavior without wiring the header, handle, and interactions manually

### Not the primary target
- Teams needing a full modal route framework
- Teams optimizing for highly custom navigation transitions
- Teams needing a route-level replacement for all bottom sheet APIs

---

## Positioning Message

### Recommended tagline
**A Google Maps-style draggable bottom sheet for Flutter.**

### Supporting message
Use `grabber_sheet` when you want a polished sheet with a built-in handle, sticky header area, scrollable content, and programmatic control — without rebuilding the same UI shell every time.

### Messaging pillars
1. **Maps-style UX, not generic plumbing**
2. **Fast setup, small API**
3. **Built on Flutter’s native draggable sheet model**
4. **Production-friendly customization**

---

## Product Roadmap

## Phase 1 — Conversion and trust
Goal: make more visitors install and try the package.

### Actions
- Rewrite README around use cases, not just features
- Add “Best for” and “When not to use” sections
- Replace generic examples with productized demos:
  - Google Maps-style result sheet
  - search results sheet
  - ride / delivery tracker sheet
  - product quick-view sheet
- Replace `example/README.md` boilerplate with package-specific guidance
- Verify publisher identity on pub.dev if possible
- Add issue templates and feature request templates

### Success metrics
- Higher pub.dev conversion from page view to install
- More GitHub stars/issues from relevant use cases
- More “how do I build X?” inbound questions that map to the target category

---

## Phase 2 — Product expansion
Goal: widen adoption without diluting positioning.

### Recommended features
1. **Modal / route wrapper**
   - `showGrabberSheet(...)`
   - `GrabberSheetRoute`
2. **Opinionated presets**
   - `maps`
   - `search`
   - `modal`
3. **More decoration control**
   - optional full `decoration` API
4. **Accessibility improvements**
   - semantics around the grabber and sheet state
5. **Desktop/web refinement**
   - stronger non-mobile interaction guidance

### Guardrails
- Keep the core widget lightweight
- Avoid becoming a kitchen-sink sheet framework
- Prefer composable, opt-in APIs

---

## Phase 3 — Distribution moat
Goal: become the default recommendation in this use case niche.

### Content strategy
Create content around search intent developers already have:
- “Flutter Google Maps bottom sheet”
- “Flutter sticky header bottom sheet”
- “Flutter draggable search result panel”
- “Flutter map result drawer”

### Channels
- pub.dev README
- GitHub README visuals
- Flutter Awesome / Awesome Flutter
- short demo posts on X, Reddit, Medium, Dev.to
- sample repo or mini showcase app

### Social proof assets
- GIF-first demos
- “Built with grabber_sheet” gallery
- concise comparisons versus built-in Flutter APIs

---

## README Conversion Strategy

The README should answer this sequence:
1. **What is it?**
2. **Why would I use it instead of plain `DraggableScrollableSheet`?**
3. **Can I copy and paste this in 2 minutes?**
4. **Does it fit my app use case?**
5. **What are the key APIs?**
6. **What are the current limitations?**

If a visitor cannot answer those questions in under a minute, adoption drops.

---

## Recommended Package Narrative

### Before
“A reusable and customizable draggable bottom sheet for Flutter.”

### After
“A Google Maps-style draggable bottom sheet for Flutter with a built-in grabber, sticky header area, and scroll-ready content API.”

That shift is important because it changes the package from a generic utility into a recognizable UI solution.

---

## 30-Day Action Plan

### Week 1
- Rewrite README
- Replace example README boilerplate
- Add one flagship Maps-style demo

### Week 2
- Publish a release centered on documentation and examples
- Submit to Flutter discovery lists and communities
- Share short demo clips publicly

### Week 3
- Collect user feedback from issues and installation questions
- Identify the top 3 missing capabilities blocking real adoption

### Week 4
- Ship one high-leverage feature:
  - modal wrapper, or
  - preset API, or
  - richer decoration API

---

## North-Star Outcome

The package wins when Flutter developers start saying:

> “If you want a Google Maps-style bottom sheet, just use `grabber_sheet`.”

That is a much stronger and more defensible position than trying to be just another bottom sheet package.
