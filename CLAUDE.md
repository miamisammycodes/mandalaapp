# CLAUDE.md

## Project Overview

**Child Mandala App** - A Flutter mobile app for UNICEF Bhutan focused on child protection awareness, age-based parenting content (ICAP), and community engagement. Targets iOS and Android.

**Status:** Building prototype with mock data. See `docs/ROADMAP.md` for the 12-phase implementation plan.

---

## Quick Commands

```bash
# Setup & Run
flutter pub get              # Install dependencies
flutter pub upgrade          # Update packages (preferred)
flutter run                  # Run app

# Quality
flutter analyze              # Check code
flutter format lib/          # Format code
flutter test                 # Run tests

# Build
flutter build apk --release  # Android APK
flutter build ios --release  # iOS build
```

---

## Design System

**Read `docs/CHILD_PROTECTION_DESIGN.md` before creating any UI.**

Quick reference:
- **Colors:** UNICEF blue #1CA7EC, pastels (pink, yellow, purple, green), background #F3F8FA
- **Radius:** Cards 20px, buttons 12px
- **Spacing:** 8px increments (8, 16, 24, 32)
- **Fonts:** Poppins (headings), Nunito Sans (body)
- **Constants:** `lib/core/constants/` (app_colors.dart, app_dimensions.dart, app_typography.dart)

---

## Project Structure

```
lib/
├── core/
│   ├── constants/       # Colors, dimensions, typography
│   ├── services/        # API client, storage, dummy data
│   ├── theme/           # App theme
│   ├── providers/       # Global providers
│   └── router/          # go_router configuration
├── models/              # Data models
├── screens/             # All screens by feature
├── providers/           # Feature providers
├── repositories/        # Data layer
├── widgets/             # Reusable components
└── l10n/                # Localization (ARB files)
```

---

## Key Technologies

- **State:** Riverpod (flutter_riverpod)
- **Routing:** go_router with route guards
- **HTTP:** Dio (currently mock data)
- **Storage:** flutter_secure_storage, shared_preferences
- **Localization:** Flutter l10n with ARB files (English + Dzongkha)

---

## Prototype Features

**Keep as-is:** Home/Mandala, News, Feedback, Subscription, Contact, Event Reporting

**Replace:**
- Email auth → Phone+OTP (parent) + PIN (child)
- Education → ICAP chapters with YouTube + expandable sections

**Add new:**
- Multilingual (English + Dzongkha)
- Parent/Child dual sessions
- Child-friendly mode (colorful, large buttons)
- Events section (agency events)
- Online Safety (4 C's framework)
- Chatbot prototype (Coming Soon)
- Push notifications (FCM)

---

## Content Structure

ICAP content in `docs/content/`:
```
docs/content/
├── en/                    # English
│   ├── chapter-1-overview/
│   │   ├── _meta.json    # Chapter metadata + YouTube video ID
│   │   └── topic-*.md    # Topic content
│   └── chapter-2-pregnancy/
└── dz/                    # Dzongkha (placeholders)
```

---

## Auth Flow

1. Language selection (first launch)
2. Parent: Phone → OTP → Add children
3. Child: Select profile → PIN → Age-filtered content

Age groups: Pregnancy, 0-3, 3-5, 6-12, 13-17 (calculated from DOB)

---

## Coding Standards

- **Files:** snake_case
- **Classes:** PascalCase
- **Use const** wherever possible
- **Riverpod:** StateNotifierProvider for complex state
- **Navigation:** `context.goNamed()`, `context.push()`
- **Always install latest package versions** without version constraints

---

## Related Docs

- `docs/ROADMAP.md` - 12-phase prototype plan
- `docs/CHILD_PROTECTION_DESIGN.md` - Design system (read before UI work)
