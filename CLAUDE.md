# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**mandalaapp** is a Flutter-based mobile application for UNICEF child protection awareness, incident reporting, educational content access, and community engagement. The app targets iOS and Android platforms.

See `APP_WORKFLOW_PLAN.md` for comprehensive feature specifications, API contracts, data models, UI/UX specifications, and business rules.

## 🎨 CRITICAL: Design System Compliance

**⚠️ MANDATORY: Before creating ANY widget, screen, or UI component, you MUST:**

1. **Read `CHILD_PROTECTION_DESIGN.md`** - This file contains the complete design system
2. **Follow the design specifications exactly** - Colors, typography, spacing, shadows, border radius
3. **Use the component patterns defined** - Don't create new patterns, use existing ones
4. **Match the visual style** - Pastel colors, soft shadows, rounded cards (20px), clean layouts

### Design System Quick Reference

**Always use these from CHILD_PROTECTION_DESIGN.md:**
- **Colors**: Pastel palette (UNICEF blue, soft pink, yellow, purple, green)
- **Background**: `#F3F8FA` (light blue-gray)
- **Card radius**: `20px` with soft shadows
- **Button radius**: `12px`
- **Spacing**: 8px increments (8, 16, 24, 32)
- **Fonts**: Poppins (headings), Nunito Sans (body)

### When Creating UI:
1. Check `CHILD_PROTECTION_DESIGN.md` for the component type
2. Copy the exact styling (colors, shadows, borders, padding)
3. Use the defined color constants
4. Follow the spacing guidelines
5. Maintain consistency with existing screens

**DO NOT:**
- Create new color schemes
- Use different border radius values
- Deviate from the shadow specifications
- Ignore the typography system
- Create custom component styles without checking the design doc first

**The design file is the source of truth for ALL visual design decisions.**

## Development Commands

### Setup
```bash
# Install dependencies
flutter pub get

# Update dependencies to latest versions (per user preference)
flutter pub upgrade
```

### Running the App
```bash
# Run on connected device or emulator
flutter run

# Run on specific device
flutter devices  # List available devices
flutter run -d <device-id>

# Run in release mode
flutter run --release

# Run in profile mode (for performance testing)
flutter run --profile
```

### Testing
```bash
# Run all tests
flutter test

# Run tests with coverage
flutter test --coverage

# Run specific test file
flutter test test/widget_test.dart
```

### Code Quality
```bash
# Analyze code
flutter analyze

# Format code
flutter format lib/ test/

# Check formatting without modifying
flutter format --set-exit-if-changed lib/ test/
```

### Building
```bash
# Build APK (Android)
flutter build apk
flutter build apk --release

# Build App Bundle (Android - for Play Store)
flutter build appbundle

# Build iOS app
flutter build ios
flutter build ipa  # For App Store submission
```

### Cleaning
```bash
# Clean build artifacts
flutter clean

# Full reset (clean + get dependencies)
flutter clean && flutter pub get
```

## Architecture Overview

### Target Application Structure

The application will follow a clean architecture pattern with the following structure:

```
lib/
├── core/                 # Core functionality shared across features
│   ├── constants/        # App-wide constants, colors, strings
│   ├── utils/           # Utility functions and helpers
│   ├── services/        # Core services (API client, storage, etc.)
│   └── theme/           # App theme configuration
├── features/            # Feature-based modules
│   ├── auth/           # Authentication (login, signup, password reset)
│   ├── news/           # News feed and article details
│   ├── events/         # Event/incident reporting
│   ├── education/      # Educational content browsing
│   ├── feedback/       # Feedback viewing and submission
│   ├── subscription/   # Email subscription
│   └── contact/        # Contact form
├── models/             # Data models and DTOs
├── widgets/            # Reusable UI components
└── main.dart           # App entry point
```

Each feature module should contain:
- `screens/` - UI screens
- `widgets/` - Feature-specific widgets
- `providers/` or `blocs/` - State management
- `repositories/` - Data access layer
- `models/` - Feature-specific models (if not shared)

### State Management

**Primary Recommendation: Riverpod**

Use **Riverpod** as the state management solution for this project. Riverpod is the modern evolution of Provider with significant improvements:

**Why Riverpod:**
- **Compile-time safety:** Catches errors at compile time vs runtime
- **No BuildContext dependency:** Access providers from anywhere
- **Better testability:** Easy to mock and test providers in isolation
- **Immutability by default:** Encourages better state design
- **DevTools support:** Excellent debugging experience
- **Good fit for app size:** Not overkill like Bloc, more robust than setState

**State Organization:**
```
lib/
├── core/
│   └── providers/
│       ├── auth_provider.dart       # Global auth state
│       └── connectivity_provider.dart
├── features/
│   ├── news/
│   │   └── providers/
│   │       ├── news_list_provider.dart
│   │       └── news_detail_provider.dart
│   └── events/
│       └── providers/
│           └── event_form_provider.dart
```

**Provider Types & When to Use:**

1. **Provider** - For immutable values, dependency injection
   ```dart
   final apiServiceProvider = Provider((ref) => ApiService());
   ```

2. **StateProvider** - For simple state (filters, toggles)
   ```dart
   final newsFilterProvider = StateProvider<String?>((ref) => null);
   ```

3. **StateNotifierProvider** - For complex, mutable state (recommended)
   ```dart
   final newsListProvider = StateNotifierProvider<NewsNotifier, AsyncValue<List<News>>>((ref) {
     return NewsNotifier(ref.read(newsRepositoryProvider));
   });
   ```

4. **FutureProvider** - For async data fetching
   ```dart
   final newsDetailProvider = FutureProvider.family<News, String>((ref, id) async {
     return ref.read(newsRepositoryProvider).getNewsById(id);
   });
   ```

5. **StreamProvider** - For real-time data streams
   ```dart
   final connectivityProvider = StreamProvider((ref) {
     return Connectivity().onConnectivityChanged;
   });
   ```

**Best Practices:**
- Keep state immutable - use `@freezed` or immutable classes
- One provider per concern (news list, auth state, etc.)
- Use `ref.watch()` to rebuild on changes, `ref.read()` for one-time reads
- Dispose resources in StateNotifier.dispose()
- Use family/autoDispose modifiers appropriately
- Handle loading/error states with AsyncValue

**Example StateNotifier:**
```dart
@freezed
class NewsState with _$NewsState {
  const factory NewsState({
    @Default([]) List<News> articles,
    @Default(false) bool isLoading,
    String? error,
  }) = _NewsState;
}

class NewsNotifier extends StateNotifier<NewsState> {
  NewsNotifier(this._repository) : super(const NewsState());

  final NewsRepository _repository;

  Future<void> loadNews() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final articles = await _repository.getNews();
      state = state.copyWith(articles: articles, isLoading: false);
    } catch (e) {
      state = state.copyWith(error: e.toString(), isLoading: false);
    }
  }
}
```

**Alternative: Provider**
If your team is more familiar with Provider or prefers simpler approach:
- Use ChangeNotifier for mutable state
- Migration path to Riverpod is straightforward later
- Good for rapid prototyping

## Navigation & Routing

**Primary Recommendation: go_router**

Use **go_router** for declarative routing with excellent deep linking support and type-safe navigation.

**Why go_router:**
- **Declarative routing:** Define routes in one place
- **Deep linking:** Built-in support for app links and web URLs
- **Type-safe navigation:** Compile-time route validation
- **Nested navigation:** Support for tabs and nested navigators
- **Redirection:** Easy auth guards and conditional routing
- **Web support:** Works seamlessly on web platform
- **Maintained by Flutter team:** Official support and updates

**Installation:**
```yaml
dependencies:
  go_router: latest
```

**Route Structure:**

Map routes to feature modules from Architecture:

```dart
// lib/core/router/app_router.dart
import 'package:go_router/go_router.dart';
import 'package:riverpod_flutter/riverpod_flutter.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/',
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isAuthRoute = state.matchedLocation.startsWith('/auth');

      // Redirect to login if not authenticated
      if (!isLoggedIn && !isAuthRoute) {
        return '/auth/login';
      }

      // Redirect to home if already logged in and on auth page
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }

      return null; // No redirect
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // News routes
      GoRoute(
        path: '/news',
        name: 'news',
        builder: (context, state) => const NewsListScreen(),
        routes: [
          GoRoute(
            path: ':id',
            name: 'news-detail',
            builder: (context, state) {
              final id = state.pathParameters['id']!;
              return NewsDetailScreen(newsId: id);
            },
          ),
        ],
      ),

      // Event reporting (auth required - handled by redirect)
      GoRoute(
        path: '/events/report',
        name: 'event-report',
        builder: (context, state) => const EventReportScreen(),
      ),

      // Educational content
      GoRoute(
        path: '/education',
        name: 'education',
        builder: (context, state) => const EducationCategoryScreen(),
        routes: [
          GoRoute(
            path: ':categoryId',
            name: 'education-category',
            builder: (context, state) {
              final categoryId = state.pathParameters['categoryId']!;
              return EducationContentScreen(categoryId: categoryId);
            },
            routes: [
              GoRoute(
                path: ':contentId',
                name: 'education-content',
                builder: (context, state) {
                  final contentId = state.pathParameters['contentId']!;
                  return ContentDetailScreen(contentId: contentId);
                },
              ),
            ],
          ),
        ],
      ),

      // Authentication routes
      GoRoute(
        path: '/auth/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/signup',
        name: 'signup',
        builder: (context, state) => const SignupScreen(),
      ),
      GoRoute(
        path: '/auth/forgot-password',
        name: 'forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),

      // Other routes
      GoRoute(
        path: '/feedback',
        name: 'feedback',
        builder: (context, state) => const FeedbackScreen(),
      ),
      GoRoute(
        path: '/contact',
        name: 'contact',
        builder: (context, state) => const ContactScreen(),
      ),
      GoRoute(
        path: '/subscribe',
        name: 'subscribe',
        builder: (context, state) => const SubscriptionScreen(),
      ),
    ],
    errorBuilder: (context, state) => const NotFoundScreen(),
  );
});
```

**Using Routes in Code:**

```dart
// Navigate to named route
context.goNamed('news');

// Navigate with parameters
context.goNamed('news-detail', pathParameters: {'id': '123'});

// Navigate with query parameters
context.goNamed('news', queryParameters: {'filter': 'recent'});

// Push (keeps previous route in stack)
context.pushNamed('event-report');

// Pop
context.pop();

// Replace current route
context.replaceNamed('home');
```

**Deep Linking Setup:**

**Android** (android/app/src/main/AndroidManifest.xml):
```xml
<intent-filter android:autoVerify="true">
    <action android:name="android.intent.action.VIEW" />
    <category android:name="android.intent.category.DEFAULT" />
    <category android:name="android.intent.category.BROWSABLE" />
    <data android:scheme="https" android:host="unicef.app" />
    <data android:scheme="unicef" />
</intent-filter>
```

**iOS** (ios/Runner/Info.plist):
```xml
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>unicef</string>
        </array>
    </dict>
</array>
```

**Deep Link Examples:**
- `unicef://news/123` → Opens news article with ID 123
- `https://unicef.app/education/survival` → Opens education category
- `unicef://events/report` → Opens event reporting form

**Route Guards & Redirection:**

Auth guard is handled in the main router's `redirect` callback (see above). For more complex guards:

```dart
GoRoute(
  path: '/admin',
  redirect: (context, state) {
    final user = ref.read(authProvider).user;
    if (user?.role != 'admin') {
      return '/'; // Redirect non-admins
    }
    return null;
  },
  builder: (context, state) => const AdminScreen(),
),
```

**Nested Navigation (Bottom Navigation):**

For apps with bottom navigation:
```dart
final rootNavigatorKey = GlobalKey<NavigatorState>();
final shellNavigatorKey = GlobalKey<NavigatorState>();

GoRouter(
  navigatorKey: rootNavigatorKey,
  routes: [
    ShellRoute(
      navigatorKey: shellNavigatorKey,
      builder: (context, state, child) {
        return ScaffoldWithNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/news',
          builder: (context, state) => const NewsScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
      ],
    ),
  ],
);
```

**Best Practices:**
- **Named routes:** Always use named routes for type safety
- **Centralized routing:** Define all routes in one router file
- **Path parameters:** Use for required IDs (`:id`)
- **Query parameters:** Use for optional filters and flags
- **Error handling:** Always provide errorBuilder
- **Testing:** Router is easily testable with go_router_builder

### API Integration

Base API URL: To be configured in environment files
- Use `http` or `dio` package for HTTP requests
- Implement interceptors for:
  - Authentication token injection
  - Error handling
  - Request/response logging (dev mode)
  - Retry logic for network failures

### Environment Configuration

**Recommended Approach: dart-define with flutter_dotenv fallback**

Manage different environments (dev, staging, production) using build-time configuration.

**Setup:**

1. **Create environment files** (git-ignored):
   ```
   .env.dev
   .env.staging
   .env.production
   .env.example    # Template (committed to git)
   ```

2. **Add to .gitignore:**
   ```
   .env.*
   !.env.example
   ```

3. **Example .env.dev file:**
   ```
   API_BASE_URL=https://api-dev.unicef.example.com/api/v1
   ENABLE_LOGGING=true
   ENABLE_ANALYTICS=false
   SENTRY_DSN=
   ```

4. **Example .env.production file:**
   ```
   API_BASE_URL=https://api.unicef.example.com/api/v1
   ENABLE_LOGGING=false
   ENABLE_ANALYTICS=true
   SENTRY_DSN=https://your-sentry-dsn
   ```

**Loading Configuration:**

Using `flutter_dotenv`:
```yaml
dependencies:
  flutter_dotenv: latest
```

```dart
// lib/core/config/env_config.dart
import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? '';
  static bool get enableLogging => dotenv.env['ENABLE_LOGGING'] == 'true';
  static bool get enableAnalytics => dotenv.env['ENABLE_ANALYTICS'] == 'true';
  static String get sentryDsn => dotenv.env['SENTRY_DSN'] ?? '';
}

// lib/main.dart
Future<void> main() async {
  await dotenv.load(fileName: '.env.dev');  // or .env.production
  runApp(const MyApp());
}
```

**Build Commands for Different Environments:**

```bash
# Development
flutter run --dart-define=ENV=dev

# Staging
flutter run --dart-define=ENV=staging --release

# Production
flutter build apk --dart-define=ENV=production --release
flutter build ipa --dart-define=ENV=production --release
```

**Using dart-define (compile-time constants):**
```dart
// Access compile-time environment
const env = String.fromEnvironment('ENV', defaultValue: 'dev');
const apiUrl = String.fromEnvironment('API_URL', defaultValue: 'http://localhost:3000');
```

**Advanced: Flavors (for true environment separation)**

For complete app separation (different app IDs, names, icons):

**Android** (android/app/build.gradle):
```gradle
flavorDimensions "environment"
productFlavors {
    dev {
        dimension "environment"
        applicationIdSuffix ".dev"
        resValue "string", "app_name", "UNICEF Dev"
    }
    staging {
        dimension "environment"
        applicationIdSuffix ".staging"
        resValue "string", "app_name", "UNICEF Staging"
    }
    production {
        dimension "environment"
        resValue "string", "app_name", "UNICEF"
    }
}
```

**iOS** (create schemes in Xcode):
- Runner-Dev
- Runner-Staging
- Runner-Production

**Run with flavors:**
```bash
flutter run --flavor dev -t lib/main_dev.dart
flutter run --flavor production -t lib/main_production.dart
```

**Configuration Best Practices:**
- **Never commit secrets:** Use .env files and .gitignore
- **Provide .env.example:** Template for team members
- **Validate on startup:** Check required config values exist
- **Different API keys:** Separate keys for dev/staging/prod
- **Feature flags:** Control feature availability per environment
- **Logging levels:** Verbose in dev, errors only in production

### Authentication

- Store auth tokens in secure storage using `flutter_secure_storage`
- Implement JWT token refresh logic
- Token expires after 24 hours
- Session management with automatic logout on token expiry

## Flutter/Dart Coding Conventions

### Naming Conventions
- **Classes & Enums:** PascalCase (`NewsArticle`, `AuthState`, `EventCategory`)
- **Files:** snake_case (`news_article.dart`, `auth_state.dart`)
- **Variables & Functions:** lowerCamelCase (`userId`, `fetchNewsArticles()`)
- **Constants:** lowerCamelCase with const (`const maxFileSize = 10485760;`)
- **Private members:** Prefix with underscore (`_userId`, `_validateForm()`)
- **Boolean variables:** Use positive names (`isLoggedIn` not `isNotLoggedIn`)

### File Organization
- **One widget per file** for major screens and complex widgets
- **Group related utilities** in a single file (e.g., `date_utils.dart`, `validation_utils.dart`)
- **Barrel files (index.dart)** to simplify imports for feature modules
- **Test files** mirror source structure: `lib/features/auth/login_screen.dart` → `test/features/auth/login_screen_test.dart`

### Widget Composition
- **Prefer composition over inheritance** - build widgets from smaller widgets
- **Extract widgets** when build method >3 levels deep or code >100 lines
- **Use const constructors** wherever possible for better performance
- **StatelessWidget** by default, StatefulWidget only when local state needed

### Code Organization Within Classes
Order class members consistently:
1. Static constants
2. Instance fields
3. Constructors
4. Lifecycle methods (initState, dispose, etc.)
5. Build method
6. Event handlers
7. Helper/utility methods
8. Private methods

Example:
```dart
class NewsScreen extends StatefulWidget {
  static const routeName = '/news';  // 1. Static constants

  final String? initialFilter;       // 2. Instance fields

  const NewsScreen({                 // 3. Constructor
    super.key,
    this.initialFilter,
  });

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen> {
  late ScrollController _scrollController;  // 2. Instance fields

  @override
  void initState() {                       // 4. Lifecycle
    super.initState();
    _scrollController = ScrollController();
  }

  @override
  void dispose() {                         // 4. Lifecycle
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {    // 5. Build method
    return Scaffold(...);
  }

  void _onRefresh() {                      // 6. Event handlers
    // Handle refresh
  }

  List<News> _filterNews(List<News> news) { // 7. Helper methods
    // Filter logic
  }
}
```

### Import Organization
Order imports in four groups, separated by blank lines:
1. Dart SDK imports (`dart:*`)
2. Flutter SDK imports (`package:flutter/*`)
3. Third-party package imports (`package:*`)
4. Relative imports

```dart
import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:riverpod/riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../models/news.dart';
import '../services/news_service.dart';
```

### Documentation
- **Public APIs:** Always document public classes, methods, and functions
- **Complex logic:** Add comments explaining "why" not "what"
- **TODO comments:** Use `// TODO(name): description` format
- **Documentation comments:** Use `///` for public members, `//` for implementation notes

### Best Practices
- **Avoid large files:** Keep files under 300-400 lines
- **Single Responsibility:** Each class should have one clear purpose
- **Immutability:** Prefer final/const, use immutable data structures
- **Null safety:** Always handle nullable types explicitly, avoid `!` unless certain
- **Error handling:** Use try-catch for async operations, provide user feedback

## Design System Implementation

### Colors (from APP_WORKFLOW_PLAN.md)
```dart
// Primary colors
const unicefBlue = Color(0xFF1CA7EC);
const darkBlue = Color(0xFF034156);
const brightCyan = Color(0xFF23D2FD);

// Text colors
const headingColor = Color(0xFF1B1D21);
const bodyColor = Color(0xFF6D6D6D);
const lightTextColor = Color(0xFF9E9E9E);

// Semantic colors
const successColor = Color(0xFF00C851);
const warningColor = Color(0xFFFFBB33);
const errorColor = Color(0xFFF04141);
const infoColor = Color(0xFF33B5E5);

// Backgrounds
const appBackground = Color(0xFFF5F5F5);
const cardBackground = Color(0xFFFFFFFF);
const inputBackground = Color(0xFFEFEFEF);
```

### Typography
- **Headings:** Poppins (use `google_fonts` package)
- **Body:** Nunito Sans (use `google_fonts` package)
- Base font size: 14px for body, 16px for inputs
- Line height: 1.5 for body text

### Component Standards
- Button height: 48px
- Border radius: 8px for buttons, 12px for cards
- Input height: 48px
- Touch targets: minimum 44x44px
- Spacing: use 8px increments (8, 16, 24, 32, etc.)

## Key Implementation Notes

### File Upload
- Max file size: 10MB for images/PDFs, 50MB for videos
- Supported formats: JPEG, PNG, PDF, MP4, MOV
- Use `image_picker` for camera/gallery access
- Compress images >2MB before upload using `flutter_image_compress`
- Strip EXIF data from images for privacy

### Offline Support (Future Enhancement)
- Cache news articles and educational content
- Queue event reports and feedback when offline
- Sync queued actions when connectivity restored
- Use `connectivity_plus` to monitor network status

### Platform-Specific Considerations
- **iOS:** Minimum version 13.0+
- **Android:** Minimum API level 26 (Android 8.0+)
- Request appropriate permissions (camera, storage, location if needed)
- Handle permission denials gracefully

### Security Requirements
- Never store passwords in plain text
- Use HTTPS for all API calls
- Implement certificate pinning for production
- Validate all user inputs client-side
- Sanitize HTML content before rendering
- No sensitive data in logs (production)

### User Roles & Access Control
- **Anonymous users:** Can view content, cannot like/report/submit feedback
- **Authenticated users:** Full access to all features
- Check authentication state before showing protected features
- Redirect to login when authentication required

### Error Handling
- Show user-friendly error messages
- Log errors to crash reporting service (e.g., Sentry, Firebase Crashlytics)
- Implement retry logic for network errors
- Preserve form data on submission errors
- Never expose stack traces to users

### Testing Strategy
- Unit tests: For business logic, utilities, and models
- Widget tests: For UI components and screens
- Integration tests: For critical user flows (login, event reporting)
- Aim for 80%+ code coverage on core business logic

## Important Dependencies to Consider

Based on the recommended architecture above, these are the key packages:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # UI & Icons
  cupertino_icons: ^1.0.8
  google_fonts: latest  # For Poppins and Nunito Sans

  # State Management
  flutter_riverpod: latest
  riverpod_annotation: latest

  # Navigation
  go_router: latest

  # Environment Configuration
  flutter_dotenv: latest

  # HTTP & API
  dio: latest  # Recommended over http for interceptors and better error handling

  # Storage
  shared_preferences: latest
  flutter_secure_storage: latest

  # Image handling
  image_picker: latest
  cached_network_image: latest
  flutter_image_compress: latest

  # Utilities
  intl: latest  # Date/time formatting
  connectivity_plus: latest
  url_launcher: latest

  # HTML rendering
  flutter_html: latest

  # Code generation helpers
  freezed_annotation: latest
  json_annotation: latest

dev_dependencies:
  flutter_test:
    sdk: flutter

  # Linting
  flutter_lints: ^6.0.0

  # Code generation
  build_runner: latest
  freezed: latest  # For immutable data classes
  json_serializable: latest
  riverpod_generator: latest

  # Testing
  mockito: latest
  riverpod_test: latest
```

**Key Package Choices Explained:**
- **flutter_riverpod:** Modern state management with excellent testability
- **go_router:** Declarative routing with deep linking support
- **dio:** Advanced HTTP client with interceptors and better error handling
- **freezed:** Generates immutable data classes with copyWith, equality, etc.
- **flutter_dotenv:** Environment configuration management
- **riverpod_generator:** Code generation for Riverpod providers (optional but recommended)

## Multi-Language Support (Future)
When implementing localization:
- Use `flutter_localizations` and `intl` package
- Extract all strings to ARB files
- Support RTL layouts for Arabic
- Format dates and numbers per locale

## Performance Optimization
- Lazy load images in lists (use `cached_network_image`)
- Paginate news and content lists (20 items per page)
- Cache API responses appropriately
- Use `const` constructors where possible
- Profile app performance regularly with DevTools
- Optimize images: use WebP format where supported
- Implement image placeholders and skeleton loaders

## Git Workflow
This project is not currently a git repository. When initializing:
- Use meaningful commit messages
- Create feature branches for new features
- Keep commits atomic and focused
- Reference APP_WORKFLOW_PLAN.md sections in commits where relevant

## Related Documentation
- **CHILD_PROTECTION_DESIGN.md:** 🎨 **MUST READ BEFORE ANY UI WORK** - Complete design system with colors, typography, component specs, and layouts
- **APP_WORKFLOW_PLAN.md:** Comprehensive feature specs, API contracts, data models, and business rules
- **pubspec.yaml:** Dependencies and project metadata
- **analysis_options.yaml:** Linting rules

## Notes
- Always install latest package versions without version constraints (per user preference)
- Follow Material Design 3 guidelines for Android
- Follow iOS Human Interface Guidelines for iOS
- Maintain consistent code style using `flutter format`
