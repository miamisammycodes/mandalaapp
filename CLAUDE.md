# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**mandalaapp** is a Flutter-based mobile application for UNICEF child protection awareness, incident reporting, educational content access, and community engagement. The app targets iOS and Android platforms.

**Important:** Currently under development with **dummy/mock data**. Backend API is not yet available. All data operations use mock services that simulate API responses. See `ROADMAP.md` for complete development plan.

See `APP_WORKFLOW_PLAN.md` for comprehensive feature specifications, API contracts, data models, UI/UX specifications, and business rules.

---

## 🎨 CRITICAL: Design System Compliance

**⚠️ MANDATORY: Before creating ANY widget, screen, or UI component, you MUST:**

1. **Read `CHILD_PROTECTION_DESIGN.md`** - This file contains the complete design system
2. **Follow the design specifications exactly** - Colors, typography, spacing, shadows, border radius
3. **Use the component patterns defined** - Don't create new patterns, use existing ones
4. **Match the visual style** - Pastel colors, soft shadows, rounded cards (20px), clean layouts

### Design System Quick Reference

**Always use these from CHILD_PROTECTION_DESIGN.md:**
- **Colors**: Pastel palette (UNICEF blue #1CA7EC, soft pink, yellow, purple, green)
- **Background**: #F3F8FA (light blue-gray)
- **Card radius**: 20px with soft shadows
- **Button radius**: 12px
- **Spacing**: 8px increments (8, 16, 24, 32)
- **Fonts**: Poppins (headings), Nunito Sans (body)

### When Creating UI:
1. Check `CHILD_PROTECTION_DESIGN.md` for the component type
2. Copy the exact styling (colors, shadows, borders, padding)
3. Use the defined color constants from `lib/core/constants/app_colors.dart`
4. Follow the spacing guidelines from `lib/core/constants/app_dimensions.dart`
5. Maintain consistency with existing screens

**DO NOT:**
- Create new color schemes
- Use different border radius values
- Deviate from the shadow specifications
- Ignore the typography system
- Create custom component styles without checking the design doc first

**The design file is the source of truth for ALL visual design decisions.**

---

## Development Commands

### Setup
Install dependencies:
- `flutter pub get` - Install dependencies
- `flutter pub upgrade` - Update to latest versions (preferred)

### Running the App
- `flutter run` - Run on connected device or emulator
- `flutter devices` - List available devices
- `flutter run -d <device-id>` - Run on specific device
- `flutter run --release` - Release mode
- `flutter run --profile` - Profile mode for performance testing

### Testing
- `flutter test` - Run all tests
- `flutter test --coverage` - Run with coverage
- `flutter test test/widget_test.dart` - Run specific test file

### Code Quality
- `flutter analyze` - Analyze code
- `flutter format lib/ test/` - Format code
- `flutter format --set-exit-if-changed lib/ test/` - Check formatting

### Building
- `flutter build apk` - Build APK (Android)
- `flutter build apk --release` - Release APK
- `flutter build appbundle` - App Bundle for Play Store
- `flutter build ios` - Build iOS app
- `flutter build ipa` - For App Store submission

### Cleaning
- `flutter clean` - Clean build artifacts
- `flutter clean && flutter pub get` - Full reset

---

## Current Project Structure

### Existing Implementation

The project currently has a partial implementation with the following structure:

**Current folders:**
- `lib/features/home/` - Mandala home screen with interactive SVG viewer
  - `screens/mandala_home_screen.dart`
  - `widgets/` - Mandala section components and clippers
  - `models/mandala_section_data.dart`
- `lib/features/education/` - Basic education content screens (placeholder)
  - `screens/education_content_screen.dart`

**What's implemented:**
- Interactive mandala viewer with 4 clickable sections
- Basic route navigation using MaterialApp routes
- Placeholder education screens

**What's missing:**
- All core infrastructure (constants, services, theme)
- All other features (auth, news, events, feedback, subscription, contact)
- State management (Riverpod)
- Modern routing (go_router)
- Design system implementation
- Shared components library

---

## Target Application Structure

The application follows a clean architecture pattern. Here's the complete structure you should build toward:

### Directory Layout

**lib/**
- **core/** - Core functionality shared across features
  - `constants/` - App-wide constants (colors, dimensions, strings)
  - `utils/` - Utility functions and helpers
  - `services/` - Core services (API client, storage, connectivity, dummy data)
  - `theme/` - App theme configuration
  - `providers/` - Global providers (auth, connectivity)
  - `router/` - Centralized go_router configuration

- **features/** - Feature-based modules
  - `home/` - ✅ Exists: Mandala home screen
  - `education/` - ✅ Exists: Educational content (needs enhancement)
  - `auth/` - ❌ To build: Login, signup, password reset
  - `news/` - ❌ To build: News feed and article details
  - `events/` - ❌ To build: Event/incident reporting
  - `feedback/` - ❌ To build: Feedback viewing and submission
  - `subscription/` - ❌ To build: Email subscription
  - `contact/` - ❌ To build: Contact form

- **models/** - Shared data models and DTOs
- **widgets/** - Reusable UI components (buttons, cards, inputs, etc.)
- **main.dart** - App entry point

### Feature Module Structure

Each feature module contains:
- `screens/` - UI screens
- `widgets/` - Feature-specific widgets
- `providers/` - Riverpod state providers
- `repositories/` - Data access layer with mock data
- `models/` - Feature-specific models (if not shared)

---

## State Management

### Primary Recommendation: Riverpod

Use **Riverpod** as the state management solution. Riverpod is the modern evolution of Provider with significant improvements.

**Why Riverpod:**
- Compile-time safety - catches errors at compile time vs runtime
- No BuildContext dependency - access providers from anywhere
- Better testability - easy to mock and test providers in isolation
- Immutability by default - encourages better state design
- DevTools support - excellent debugging experience
- Good fit for app size - not overkill, more robust than setState

### Provider Organization

Organize providers by scope:
- **Global providers:** `lib/core/providers/` (auth, connectivity)
- **Feature providers:** Within each feature's `providers/` folder

Example:
- `lib/core/providers/auth_provider.dart` - Global auth state
- `lib/features/news/providers/news_list_provider.dart` - News list state
- `lib/features/news/providers/news_detail_provider.dart` - News detail state

### Provider Types & When to Use

1. **Provider** - For immutable values, dependency injection (API services, repositories)

2. **StateProvider** - For simple state like filters, toggles, selected values

3. **StateNotifierProvider** - For complex, mutable state (recommended for most features)
   - Use for lists, forms, complex UI state
   - Provides clean separation of state and logic

4. **FutureProvider** - For async data fetching
   - Use with `.family` modifier for parameterized fetching
   - Good for one-time data loads

5. **StreamProvider** - For real-time data streams
   - Connectivity status
   - Real-time updates (future)

### Best Practices

- Keep state immutable - use `@freezed` or immutable classes
- One provider per concern (news list, auth state, event form, etc.)
- Use `ref.watch()` to rebuild on changes, `ref.read()` for one-time reads
- Dispose resources in StateNotifier.dispose()
- Use family/autoDispose modifiers appropriately
- Handle loading/error states with AsyncValue
- Create state classes with loading/error/data states

---

## Navigation & Routing

### Primary Recommendation: go_router

Use **go_router** for declarative routing with excellent deep linking support and type-safe navigation.

**Why go_router:**
- Declarative routing - define routes in one centralized place
- Deep linking - built-in support for app links and web URLs
- Type-safe navigation - compile-time route validation
- Nested navigation - support for tabs and nested navigators
- Redirection - easy auth guards and conditional routing
- Web support - works seamlessly on web platform
- Maintained by Flutter team - official support and updates

### Route Structure

Create a centralized router file at `lib/core/router/app_router.dart` that:
- Defines all application routes
- Watches auth state for protected routes
- Implements redirect logic for auth guards
- Maps to feature module screens

### Key Routes to Implement

**Public routes:**
- `/` - Home screen
- `/news` - News feed
- `/news/:id` - News detail
- `/education` - Education categories
- `/education/:categoryId` - Content list
- `/education/:categoryId/:contentId` - Content detail
- `/feedback` - Feedback list
- `/subscribe` - Email subscription
- `/contact` - Contact form

**Auth routes:**
- `/auth/login` - Login screen
- `/auth/signup` - Signup screen
- `/auth/forgot-password` - Password reset

**Protected routes (require authentication):**
- `/events/report` - Event reporting
- Any route that needs user authentication

### Navigation Methods

Use named routes with go_router:
- `context.goNamed('news')` - Navigate to named route
- `context.goNamed('news-detail', pathParameters: {'id': '123'})` - With parameters
- `context.pushNamed('event-report')` - Push (keeps previous route in stack)
- `context.pop()` - Go back
- `context.replaceNamed('home')` - Replace current route

### Deep Linking Setup

Configure deep linking for both platforms:

**Android:** Update `android/app/src/main/AndroidManifest.xml`
- Add intent filters for app scheme (unicef://)
- Add intent filters for https scheme (optional)

**iOS:** Update `ios/Runner/Info.plist`
- Add CFBundleURLTypes with app scheme

**Deep link examples:**
- `unicef://news/123` → Opens news article
- `unicef://education/survival` → Opens education category
- `unicef://events/report` → Opens event reporting

### Route Guards & Redirection

Implement auth guards in the router's redirect callback:
- Check authentication state
- Redirect unauthenticated users to login
- Redirect authenticated users away from auth pages
- Preserve intended destination for post-login redirect

### Best Practices

- Always use named routes for type safety
- Centralize all routes in one router file
- Use path parameters for required IDs (`:id`)
- Use query parameters for optional filters
- Always provide errorBuilder for 404 pages
- Test deep linking on physical devices

---

## API Integration

### Current Approach: Mock Data

Since the backend API is not yet available, use mock/dummy data services:

**Implementation:**
- Create `lib/core/services/api_client.dart` with Dio client
- Create `lib/core/services/dummy_data_service.dart` for mock data generation
- Repositories call DummyDataService instead of real API
- Simulate network delays (500ms-1s) for realistic behavior
- Return realistic mock data matching API contracts from APP_WORKFLOW_PLAN.md

**When backend is ready:**
- Replace mock service calls with real API calls
- Keep the same repository interface
- Update ApiClient to use production base URL
- Add proper error handling for real network errors

### API Client Configuration

Use `dio` package for HTTP requests with:
- Base URL from environment configuration
- Request/response interceptors for logging
- Auth interceptor for token injection
- Error handling interceptor
- Retry logic for network failures (future)

### Configuration Management

**Current Approach (Mock Data Phase):**

Create a simple configuration class: `lib/core/config/app_config.dart`

Use static const values for:
- App name and version
- Mock data flags
- Debug/logging settings
- Feature flags

**Future Approach (When Backend Ready):**

**Option 1: dart-define (Recommended)**
Pass configuration at build time via command line:
- Development: `flutter run`
- Production: `flutter build apk --dart-define=API_URL=https://api.unicef.org --dart-define=ENABLE_LOGGING=false --release`

Access in code: `const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000');`

**Option 2: Flavors (For Complete Separation)**
Set up Android/iOS build flavors for different environments:
- Different app IDs (com.unicef.app, com.unicef.app.dev)
- Different app names
- Different configurations
- Requires configuration in build.gradle (Android) and Xcode schemes (iOS)

**Configuration values:**
- API_BASE_URL - Backend API URL
- ENABLE_LOGGING - Debug logging flag
- ENABLE_ANALYTICS - Analytics flag
- SENTRY_DSN - Crash reporting DSN (production)

### Best Practices

- Never hardcode secrets or API keys in source code
- Use const for compile-time constants
- Validate required config on app startup
- Use different API keys for dev/staging/prod
- Implement feature flags per environment
- Verbose logging in debug mode, errors only in production
- Document build commands for different environments

---

## Authentication

### Token Management

- Store auth tokens securely using `flutter_secure_storage`
- Implement JWT token storage and retrieval
- Token expires after 24 hours (per API spec)
- Session management with automatic logout on token expiry
- Auto-refresh tokens before expiry (future enhancement)

### Auth Flow

1. **Login:** User credentials → API → Token + User → Secure storage
2. **Signup:** Registration data → API → Token + User → Secure storage
3. **Logout:** Clear token from storage → Reset auth state
4. **Password Reset:** Email → API → Confirmation message

### Implementation

- Auth state managed by global Riverpod provider
- Auth repository handles mock API calls
- Secure storage service wraps flutter_secure_storage
- Auth interceptor adds token to all API requests
- Route guards check auth state before navigation

---

## Flutter/Dart Coding Conventions

### Naming Conventions

- **Classes & Enums:** PascalCase (NewsArticle, AuthState, EventCategory)
- **Files:** snake_case (news_article.dart, auth_state.dart)
- **Variables & Functions:** lowerCamelCase (userId, fetchNewsArticles)
- **Constants:** lowerCamelCase with const (const maxFileSize = 10485760)
- **Private members:** Prefix with underscore (_userId, _validateForm)
- **Boolean variables:** Use positive names (isLoggedIn not isNotLoggedIn)

### File Organization

- One widget per file for major screens and complex widgets
- Group related utilities in single files (date_utils.dart, validation_utils.dart)
- Use barrel files (index.dart) to simplify imports for feature modules
- Test files mirror source structure

### Widget Composition

- Prefer composition over inheritance
- Extract widgets when build method >3 levels deep or >100 lines
- Use const constructors wherever possible
- StatelessWidget by default, StatefulWidget only when local state needed

### Code Organization Within Classes

Order class members consistently:
1. Static constants
2. Instance fields
3. Constructors
4. Lifecycle methods (initState, dispose)
5. Build method
6. Event handlers
7. Helper/utility methods
8. Private methods

### Import Organization

Order imports in four groups, separated by blank lines:
1. Dart SDK imports (dart:*)
2. Flutter SDK imports (package:flutter/*)
3. Third-party package imports (package:*)
4. Relative imports

### Documentation

- Always document public classes, methods, and functions
- Add comments explaining "why" not "what" for complex logic
- Use `// TODO(name): description` format for todos
- Use `///` for public member docs, `//` for implementation notes

### Best Practices

- Keep files under 300-400 lines
- Single Responsibility - each class has one clear purpose
- Prefer final/const and immutable data structures
- Handle nullable types explicitly, avoid `!` unless certain
- Use try-catch for async operations, provide user feedback
- No magic numbers - use named constants

---

## Design System Implementation

### Colors

Define all colors in `lib/core/constants/app_colors.dart`:

**Primary colors:**
- unicefBlue: #1CA7EC
- Soft Pink, Soft Yellow, Soft Purple, Soft Green (pastel variants)

**Text colors:**
- headingColor: #1B1D21
- bodyColor: #6D6D6D
- lightTextColor: #9E9E9E

**Semantic colors:**
- successColor: #00C851
- warningColor: #FFBB33
- errorColor: #F04141
- infoColor: #33B5E5

**Backgrounds:**
- appBackground: #F3F8FA
- cardBackground: #FFFFFF
- inputBackground: #EFEFEF

See CHILD_PROTECTION_DESIGN.md for complete color specifications.

### Typography

Define text styles in `lib/core/constants/app_typography.dart`:

- **Headings:** Poppins font (H1-H6)
- **Body:** Nunito Sans font (Body1, Body2, Caption)
- Use `google_fonts` package for font loading
- Base font size: 14px for body, 16px for inputs
- Line height: 1.5 for body text

### Spacing & Sizing

Define dimensions in `lib/core/constants/app_dimensions.dart`:

- **Spacing scale:** 8, 16, 24, 32, 40, 48 (8px increments)
- **Border radius:** 8px (buttons), 12px (cards), 20px (feature cards)
- **Component heights:** 48px (buttons), 48px (inputs)
- **Icon sizes:** 24, 32, 40
- **Touch targets:** Minimum 44x44px

### Component Standards

- Button height: 48px
- Input height: 48px
- Card elevation: Use soft shadows from design system
- Spacing: Always use 8px increments
- Touch targets: Minimum 44x44px for accessibility

### Theme Configuration

Create centralized theme in `lib/core/theme/app_theme.dart`:
- ColorScheme from app_colors.dart
- TextTheme from app_typography.dart
- Component themes (InputDecoration, ElevatedButton, Card, AppBar)
- Apply theme in MaterialApp

---

## Key Implementation Notes

### File Upload

- Max file size: 10MB for images/PDFs, 50MB for videos
- Supported formats: JPEG, PNG, PDF, MP4, MOV
- Use `image_picker` for camera/gallery access
- Compress images >2MB using `flutter_image_compress`
- Strip EXIF data from images for privacy
- Validate file size and type before upload

### Offline Support (Future)

- Cache news articles and educational content locally
- Queue event reports and feedback when offline
- Sync queued actions when connectivity restored
- Use `connectivity_plus` to monitor network status
- Show offline banner when no connection

### Platform-Specific Considerations

- **iOS:** Minimum version 13.0+
- **Android:** Minimum API level 26 (Android 8.0+)
- Request appropriate permissions (camera, storage, location if needed)
- Handle permission denials gracefully with user-friendly messages
- Test on both platforms regularly

### Security Requirements

- Never store passwords in plain text
- Use HTTPS for all API calls (when backend is ready)
- Implement certificate pinning for production
- Validate all user inputs client-side
- Sanitize HTML content before rendering (use flutter_html package)
- No sensitive data in logs (production builds)
- Use flutter_secure_storage for tokens and sensitive data

### User Roles & Access Control

- **Anonymous users:** Can view content, cannot like/report/submit feedback
- **Authenticated users:** Full access to all features
- Check authentication state before showing protected features
- Redirect to login when authentication required
- Show appropriate UI for logged out state

### Error Handling

- Show user-friendly error messages (never technical jargon)
- Log errors to crash reporting service (Sentry or Firebase Crashlytics)
- Implement retry logic for network errors
- Preserve form data on submission errors
- Never expose stack traces to end users
- Provide actionable error messages with next steps

### Testing Strategy

- **Unit tests:** For business logic, utilities, validators, and models
- **Widget tests:** For UI components and screens
- **Integration tests:** For critical user flows (login, event reporting, content browsing)
- Aim for 80%+ code coverage on core business logic
- Test error states and edge cases
- Mock external dependencies (API, storage)

---

## Important Dependencies

### Core Dependencies

**UI & Fonts:**
- google_fonts - For Poppins and Nunito Sans typography

**State Management:**
- flutter_riverpod - Modern state management
- riverpod_annotation - Code generation support

**Navigation:**
- go_router - Declarative routing and deep linking

**HTTP & API:**
- dio - HTTP client with interceptors

**Storage:**
- shared_preferences - Simple key-value storage
- flutter_secure_storage - Secure token storage

**Image Handling:**
- image_picker - Camera and gallery access
- cached_network_image - Image caching
- flutter_image_compress - Image compression

**Utilities:**
- intl - Date/time formatting and localization
- connectivity_plus - Network connectivity monitoring
- url_launcher - Open external URLs
- flutter_html - Render HTML content

**Code Generation:**
- freezed / freezed_annotation - Immutable data classes
- json_serializable / json_annotation - JSON serialization
- build_runner - Code generation runner
- riverpod_generator - Riverpod code generation

### Dev Dependencies

**Linting:**
- flutter_lints - Recommended linting rules

**Testing:**
- mockito - Mocking for tests
- riverpod_test - Testing utilities for Riverpod

**Key Package Choices Explained:**
- **flutter_riverpod:** Best-in-class state management with compile-time safety
- **go_router:** Official Flutter team routing solution with deep linking
- **dio:** Advanced HTTP client with interceptors (better than http package)
- **freezed:** Generates immutable classes with copyWith, equality, toString

---

## Performance Optimization

- Lazy load images in lists using `cached_network_image`
- Paginate all lists (20 items per page recommended)
- Cache API responses appropriately (respect cache headers)
- Use `const` constructors everywhere possible
- Profile app performance regularly with Flutter DevTools
- Optimize images before upload (compress, resize)
- Implement skeleton loaders for better perceived performance
- Use `ListView.builder` for long lists (not ListView with all items)
- Avoid rebuilding widgets unnecessarily (use const, keys, memoization)

---

## Git Workflow

When initializing git repository:
- Use meaningful commit messages (conventional commits format recommended)
- Create feature branches for new features
- Keep commits atomic and focused on single changes
- Reference APP_WORKFLOW_PLAN.md or ROADMAP.md in commits where relevant
- Don't commit sensitive files (secrets, API keys, credentials)

---

## Related Documentation

- **ROADMAP.md:** Complete development roadmap with 8 phases and detailed tasks
- **CHILD_PROTECTION_DESIGN.md:** 🎨 **MUST READ BEFORE ANY UI WORK** - Complete design system
- **APP_WORKFLOW_PLAN.md:** Feature specs, API contracts, data models, business rules
- **pubspec.yaml:** Dependencies and project metadata
- **analysis_options.yaml:** Linting rules configuration

---

## Development Notes

### Current Status (v0.1)
- ✅ Interactive mandala home screen
- ✅ Basic education content screens
- ⏳ ~15% complete

### Next Steps
See `ROADMAP.md` for complete development plan organized in 8 phases:
1. Infrastructure Setup & Design System
2. Navigation & Authentication
3. News Feature
4. Educational Content (enhance existing)
5. Event Reporting
6. Feedback & Communication
7. Polish & Testing
8. Deployment Preparation

### Important Reminders

- **Always install latest package versions** without version constraints (per user preference)
- **Read CHILD_PROTECTION_DESIGN.md** before creating any UI component
- **Use dummy data services** until backend API is available
- **Follow Material Design 3** guidelines for Android
- **Follow iOS Human Interface Guidelines** for iOS
- **Maintain consistent code style** using `flutter format`
- **Test on both iOS and Android** regularly
- **Check ROADMAP.md** for task priorities and dependencies
