# UNICEF Child Protection App - Development Roadmap

> **Note:** This roadmap is adapted for development with **dummy/mock data** since the backend API is not yet available. All API integration tasks focus on creating mock services that can later be replaced with real API calls.

---

## Overview

This roadmap outlines the complete development journey from initial setup to production deployment. The app is a Flutter-based mobile application for UNICEF child protection awareness, incident reporting, educational content access, and community engagement.

### Current Status
- ✅ Interactive mandala home screen with SVG rendering
- ✅ Basic education content screens (placeholder)
- ✅ Simple route navigation
- ⏳ ~15% complete

### Target Completion
- 8 phases over approximately 8 weeks
- 100+ specific tasks
- Production-ready mobile app for iOS and Android

---

## Phase 1: Infrastructure Setup & Design System
**Duration:** Week 1 (5-7 days)
**Focus:** Foundation, dependencies, design system, core architecture

### 1.1 Project Foundation

#### Task 1.1.1: Install Core Dependencies
**Description:** Add all required packages to pubspec.yaml and run `flutter pub get`

**Dependencies to add:**
- State Management: `flutter_riverpod`, `riverpod_annotation`
- Navigation: `go_router`
- HTTP: `dio`
- Storage: `shared_preferences`, `flutter_secure_storage`
- UI/Fonts: `google_fonts`, `cached_network_image`
- Utilities: `intl`, `connectivity_plus`, `url_launcher`, `flutter_html`
- Images: `image_picker`, `flutter_image_compress`
- Code Gen: `freezed`, `freezed_annotation`, `json_annotation`, `json_serializable`, `build_runner`, `riverpod_generator`
- Dev: `flutter_lints`, `mockito`, `riverpod_test`

**Acceptance Criteria:**
- [x] All dependencies added to pubspec.yaml with latest versions
- [x] `flutter pub get` runs successfully
- [x] No version conflicts
- [x] Dev dependencies in dev_dependencies section

---

#### Task 1.1.2: Create Core Folder Structure
**Description:** Set up the type-based folder structure (organized by type rather than feature)

**Create directories:**
```
lib/
├── core/
│   ├── config/
│   ├── constants/
│   ├── utils/
│   ├── services/
│   ├── theme/
│   ├── providers/
│   └── router/
├── models/
│   ├── home/
│   ├── education/
│   ├── news/
│   ├── auth/
│   ├── events/
│   ├── feedback/
│   ├── subscription/
│   └── contact/
├── screens/
│   ├── home/
│   ├── education/
│   ├── news/
│   ├── auth/
│   ├── events/
│   ├── feedback/
│   ├── subscription/
│   └── contact/
├── providers/
│   ├── home/
│   ├── education/
│   ├── news/
│   ├── auth/
│   ├── events/
│   ├── feedback/
│   ├── subscription/
│   └── contact/
├── repositories/
│   ├── education/
│   ├── news/
│   ├── auth/
│   ├── events/
│   ├── feedback/
│   ├── subscription/
│   └── contact/
└── widgets/
    ├── home/
    ├── education/
    ├── news/
    ├── auth/
    ├── events/
    ├── feedback/
    ├── subscription/
    ├── contact/
    └── shared/
```

**Acceptance Criteria:**
- [x] All directories created
- [x] Existing home/ and education/ features preserved
- [x] Type-based organization implemented

---

#### Task 1.1.3: Create App Configuration
**Description:** Create simple Dart configuration class for app settings

**File to create:** `lib/core/config/app_config.dart`

**Configuration to include:**
- App name and version
- Mock data flag (always true for now)
- Debug/logging flags
- Feature flags

**Note:** Using simple Dart constants for now. When backend API is ready, you can switch to `--dart-define` for build-time configuration or implement Flavors for true environment separation.

**Acceptance Criteria:**
- [x] AppConfig class created in `lib/core/config/app_config.dart`
- [x] All configuration as static const values
- [x] Documentation comments explaining each config
- [x] Imported and used in main.dart

---

### 1.2 Design System Implementation

#### Task 1.2.1: Create Color Constants
**Description:** Implement all colors from CHILD_PROTECTION_DESIGN.md

**File:** `lib/core/constants/app_colors.dart`

**Colors to define:**
- Primary: UNICEF Blue (#1CA7EC), Soft Pink, Soft Yellow, Soft Purple, Soft Green
- Background: #F3F8FA
- Text: Headings (#1B1D21), Body (#6D6D6D), Light (#9E9E9E)
- Semantic: Success, Warning, Error, Info
- Card/Input backgrounds

**Acceptance Criteria:**
- [x] All colors defined as static const Color
- [x] Documentation comments for each color
- [x] Colors match CHILD_PROTECTION_DESIGN.md exactly
- [x] Organized by category (primary, semantic, backgrounds, text)

---

#### Task 1.2.2: Create Typography Constants
**Description:** Define text styles using google_fonts package

**File:** `lib/core/constants/app_typography.dart`

**Text styles:**
- Headings: Poppins (H1-H6)
- Body: Nunito Sans (Body1, Body2, Caption)
- Special: Button text, Input text

**Acceptance Criteria:**
- [x] All text styles defined
- [x] Uses google_fonts for Poppins and Nunito Sans
- [x] Font sizes, weights, line heights match design
- [x] Reusable TextStyle objects

---

#### Task 1.2.3: Create Spacing & Sizing Constants
**Description:** Define consistent spacing, border radius, and sizing

**File:** `lib/core/constants/app_dimensions.dart`

**Constants:**
- Spacing: 8, 16, 24, 32, 40, 48 (8px increments)
- Border radius: 8 (buttons), 12 (cards), 20 (feature cards)
- Button height: 48
- Input height: 48
- Icon sizes: 24, 32, 40
- Touch targets: 44x44 minimum

**Acceptance Criteria:**
- [x] All dimensions defined
- [x] Organized by category
- [x] Documentation for usage

---

#### Task 1.2.4: Create App Theme
**Description:** Centralized theme configuration with Material 3

**File:** `lib/core/theme/app_theme.dart`

**Theme elements:**
- ColorScheme from app_colors.dart
- TextTheme from app_typography.dart
- InputDecorationTheme
- ElevatedButtonTheme
- OutlinedButtonTheme
- CardTheme
- AppBarTheme

**Acceptance Criteria:**
- [x] Light theme fully configured
- [x] All component themes defined
- [x] Uses design system constants
- [x] Applied in main.dart MaterialApp

---

#### Task 1.2.5: Create Shadow Styles
**Description:** Define consistent box shadows for elevation

**File:** `lib/core/constants/app_shadows.dart`

**Shadows:**
- Soft shadow (cards): offset (0, 2), blur 8, color with opacity
- Medium shadow (elevated cards): offset (0, 4), blur 12
- Strong shadow (modals): offset (0, 8), blur 16

**Acceptance Criteria:**
- [x] Shadow constants defined
- [x] Matches CHILD_PROTECTION_DESIGN.md specifications
- [x] Reusable BoxShadow lists

---

### 1.3 Core Services

#### Task 1.3.1: Create Mock API Client
**Description:** Create Dio-based HTTP client that returns dummy data

**File:** `lib/core/services/api_client.dart`

**Features:**
- Dio instance with baseUrl from env
- Request/response interceptors for logging
- Error handling interceptor
- Mock responses for all endpoints
- Simulated network delay (500ms-1s)

**Acceptance Criteria:**
- [x] ApiClient class created
- [x] Singleton pattern or Provider-based
- [x] Returns dummy data instead of making real HTTP calls
- [x] Error handling implemented
- [x] Logging in debug mode

---

#### Task 1.3.2: Create Secure Storage Service
**Description:** Wrapper for flutter_secure_storage

**File:** `lib/core/services/storage_service.dart`

**Methods:**
- saveToken(String token)
- getToken() → String?
- deleteToken()
- saveUser(Map<String, dynamic> user)
- getUser() → Map?
- clear()

**Acceptance Criteria:**
- [x] StorageService class created
- [x] All methods implemented
- [x] Error handling for platform issues
- [x] Singleton pattern for dependency injection

---

#### Task 1.3.3: Create Connectivity Service
**Description:** Monitor network connectivity status

**File:** `lib/core/services/connectivity_service.dart`

**Features:**
- Check current connectivity
- Stream of connectivity changes
- Online/offline detection

**Acceptance Criteria:**
- [x] ConnectivityService class created
- [x] Uses connectivity_plus package
- [x] Stream for connectivity state (ready for StreamProvider)
- [x] Handles all connection types (wifi, mobile, ethernet, vpn, none)

---

#### Task 1.3.4: Create Dummy Data Service
**Description:** Centralized service for generating mock data

**File:** `lib/core/services/dummy_data_service.dart`

**Mock data generators:**
- generateNewsList(int count)
- generateNewsDetail(String id)
- generateCategories()
- generateContentList(String categoryId)
- generateFeedbackList()
- generateUser()

**Acceptance Criteria:**
- [x] DummyDataService class created
- [x] Realistic mock data with varied content
- [x] Uses custom random data generators (faker package optional)
- [x] Returns data in correct model format
- [x] Consistent IDs and references

---

### 1.4 Shared Components

#### Task 1.4.1: Create Button Components
**Description:** Reusable button widgets following design system

**File:** `lib/widgets/shared/app_button.dart`

**Variants:**
- Primary button (filled, UNICEF blue)
- Secondary button (outlined)
- Text button
- Icon button

**Acceptance Criteria:**
- [x] AppButton widget created
- [x] Uses design system colors and dimensions
- [x] Loading state support
- [x] Disabled state styling
- [x] onPressed callback

---

#### Task 1.4.2: Create Input Components
**Description:** Styled text input fields

**File:** `lib/widgets/shared/app_text_field.dart`

**Features:**
- Standard text input
- Password input (with visibility toggle)
- Multi-line text input
- Validation error display
- Prefix/suffix icons

**Acceptance Criteria:**
- [x] AppTextField widget created
- [x] Uses design system styling
- [x] Error state with red border
- [x] Focus state styling
- [x] Accessibility labels

---

#### Task 1.4.3: Create Card Components
**Description:** Reusable card containers

**File:** `lib/widgets/shared/app_card.dart`

**Variants:**
- Basic card (white background, 12px radius, soft shadow)
- Featured card (20px radius, image support)
- Interactive card (with tap feedback)

**Acceptance Criteria:**
- [x] AppCard widget created
- [x] Uses design system shadows and radius
- [x] Padding options
- [x] onTap callback for interactive cards

---

#### Task 1.4.4: Create Loading Components
**Description:** Loading indicators and skeleton screens

**Files:**
- `lib/widgets/shared/app_loading_indicator.dart`
- `lib/widgets/shared/skeleton_loader.dart`

**Components:**
- Circular progress indicator (UNICEF blue)
- Linear progress indicator
- Skeleton card (shimmer effect)
- Skeleton list

**Acceptance Criteria:**
- [x] Loading widgets created
- [x] Uses brand colors
- [x] Shimmer effect for skeletons
- [x] Reusable across app

---

#### Task 1.4.5: Create Empty State Components
**Description:** Display when no data available

**File:** `lib/widgets/shared/empty_state.dart`

**Features:**
- Icon/illustration
- Headline text
- Description text
- Optional action button

**Acceptance Criteria:**
- [x] EmptyState widget created
- [x] Customizable message and icon
- [x] Uses design system typography
- [x] Centered layout

---

**Phase 1 Milestone:**
✅ Design system fully implemented
✅ Core services created with mock data
✅ Reusable components library established
✅ Ready to build features

---

## Phase 2: Navigation & Authentication
**Duration:** Week 2 (5-7 days)
**Focus:** App routing, auth flow, user session management

### 2.1 Navigation Setup

#### Task 2.1.1: Setup go_router Configuration
**Description:** Create centralized routing with go_router

**File:** `lib/core/router/app_router.dart`

**Routes to define:**
- `/` - Home screen
- `/news` - News feed
- `/news/:id` - News detail
- `/events/report` - Event reporting (auth required)
- `/education` - Education categories
- `/education/:categoryId` - Content list
- `/education/:categoryId/:contentId` - Content detail
- `/feedback` - Feedback list
- `/subscribe` - Email subscription
- `/contact` - Contact form
- `/auth/login` - Login
- `/auth/signup` - Signup
- `/auth/forgot-password` - Password reset

**Acceptance Criteria:**
- [ ] AppRouter provider created
- [ ] All routes defined with named routes
- [ ] Path parameters configured
- [ ] Error/404 route defined
- [ ] Router integrated in main.dart

---

#### Task 2.1.2: Implement Route Guards
**Description:** Protect routes that require authentication

**Features:**
- Redirect to login if not authenticated
- Redirect to home if already logged in (on auth pages)
- Check auth state before navigation

**Acceptance Criteria:**
- [ ] Route guard logic in redirect callback
- [ ] Watches auth state provider
- [ ] Proper redirects for protected routes
- [ ] Maintains intended destination after login

---

#### Task 2.1.3: Create App Shell with Drawer
**Description:** Main navigation structure with side menu

**Files:**
- `lib/widgets/navigation/app_drawer.dart`
- `lib/widgets/navigation/app_scaffold.dart`

**Drawer items:**
- Home
- News
- Education
- Report Event
- Feedback
- Subscribe
- Contact Us
- Login/Logout

**Acceptance Criteria:**
- [ ] AppDrawer widget created
- [ ] Uses design system styling
- [ ] Active route highlighting
- [ ] User info section (when logged in)
- [ ] Logout functionality
- [ ] Navigation to all routes

---

#### Task 2.1.4: Deep Linking Setup
**Description:** Configure app to handle deep links

**Android:** Update AndroidManifest.xml
**iOS:** Update Info.plist

**Deep link patterns:**
- `unicef://news/:id`
- `unicef://education/:categoryId`
- `unicef://events/report`

**Acceptance Criteria:**
- [ ] Android deep links configured
- [ ] iOS deep links configured
- [ ] Test deep link navigation
- [ ] go_router handles deep link paths

---

### 2.2 Authentication Implementation

#### Task 2.2.1: Create Auth Models
**Description:** User and auth-related data models

**Files:**
- `lib/features/auth/models/user.dart`
- `lib/features/auth/models/auth_state.dart`
- `lib/features/auth/models/login_request.dart`
- `lib/features/auth/models/register_request.dart`

**Models:**
```dart
User: id, email, name, avatar, role, createdAt
AuthState: user, token, isAuthenticated, isLoading, error
LoginRequest: email, password
RegisterRequest: name, email, password, confirmPassword
```

**Acceptance Criteria:**
- [ ] All models created with freezed
- [ ] JSON serialization configured
- [ ] Proper validation methods
- [ ] Immutable classes

---

#### Task 2.2.2: Create Auth Repository (Mock)
**Description:** Auth operations with dummy data

**File:** `lib/features/auth/repositories/auth_repository.dart`

**Methods:**
- login(email, password) → User + token
- register(name, email, password) → User + token
- forgotPassword(email) → success message
- logout() → void
- refreshToken() → new token

**Mock behavior:**
- Accept any email/password (for testing)
- Return hardcoded user and token
- Simulate 500ms delay
- Return error for specific test cases

**Acceptance Criteria:**
- [ ] AuthRepository class created
- [ ] All methods return mock data
- [ ] Simulated network delay
- [ ] Error cases handled
- [ ] Provider created for DI

---

#### Task 2.2.3: Create Auth State Provider
**Description:** Global authentication state management

**File:** `lib/features/auth/providers/auth_provider.dart`

**State:**
- Current user
- Auth token
- Loading state
- Error messages

**Actions:**
- login(email, password)
- register(name, email, password)
- logout()
- checkAuthStatus() (on app start)

**Acceptance Criteria:**
- [ ] StateNotifierProvider created
- [ ] Uses AuthRepository
- [ ] Saves token to secure storage
- [ ] Loads token on app start
- [ ] Updates auth state properly

---

#### Task 2.2.4: Create Login Screen
**Description:** User login interface

**File:** `lib/features/auth/screens/login_screen.dart`

**UI Elements:**
- App logo
- Email input field
- Password input field
- Login button
- Forgot password link
- Sign up link
- Loading state

**Validation:**
- Email format
- Password not empty
- Show error messages

**Acceptance Criteria:**
- [ ] LoginScreen widget created
- [ ] Uses design system components
- [ ] Form validation implemented
- [ ] Calls auth provider on submit
- [ ] Shows loading indicator
- [ ] Navigates to home on success
- [ ] Displays error messages

---

#### Task 2.2.5: Create Signup Screen
**Description:** User registration interface

**File:** `lib/features/auth/screens/signup_screen.dart`

**UI Elements:**
- Name input
- Email input
- Password input
- Confirm password input
- Signup button
- Login link
- Terms checkbox (optional)

**Validation:**
- All fields required
- Email format
- Password strength (8+ chars, uppercase, lowercase, number)
- Passwords match

**Acceptance Criteria:**
- [ ] SignupScreen widget created
- [ ] All validations implemented
- [ ] Calls auth provider on submit
- [ ] Loading and error states
- [ ] Navigates to home on success

---

#### Task 2.2.6: Create Forgot Password Screen
**Description:** Password reset request

**File:** `lib/features/auth/screens/forgot_password_screen.dart`

**UI Elements:**
- Email input
- Submit button
- Back to login link
- Success message

**Flow:**
- User enters email
- Mock service returns success
- Show confirmation message
- (No actual email sent in mock)

**Acceptance Criteria:**
- [ ] ForgotPasswordScreen created
- [ ] Email validation
- [ ] Calls auth repository
- [ ] Shows success message
- [ ] Back navigation

---

#### Task 2.2.7: Add Auth Interceptor
**Description:** Automatically add auth token to API requests

**File:** `lib/core/services/auth_interceptor.dart`

**Features:**
- Read token from secure storage
- Add Authorization header to requests
- Handle 401 unauthorized (logout user)
- Token refresh on 401 (future)

**Acceptance Criteria:**
- [ ] AuthInterceptor class created
- [ ] Added to Dio interceptors
- [ ] Reads token from storage
- [ ] Adds Bearer token to headers
- [ ] Handles unauthorized errors

---

**Phase 2 Milestone:**
✅ Complete navigation system with go_router
✅ Authentication flow functional (login, signup, logout)
✅ Route guards protecting features
✅ Session persistence working

---

## Phase 3: News Feature
**Duration:** Week 3 (5-7 days)
**Focus:** News feed, article details, like functionality, pagination

### 3.1 News Models & Data

#### Task 3.1.1: Create News Models
**Description:** Data models for news articles

**Files:**
- `lib/features/news/models/news.dart`
- `lib/features/news/models/news_category.dart`

**News model fields:**
- id, title, excerpt, content (HTML)
- image, author, authorAvatar
- category, tags
- likeCount, isLikedByUser
- publishedAt, readTime

**Acceptance Criteria:**
- [ ] Models created with freezed
- [ ] JSON serialization
- [ ] Proper date handling
- [ ] Validation methods

---

#### Task 3.1.2: Create News Repository (Mock)
**Description:** News data operations with dummy data

**File:** `lib/features/news/repositories/news_repository.dart`

**Methods:**
- getNews(page, limit, category?) → List<News>
- getNewsById(id) → News
- likeNews(id) → updated News
- unlikeNews(id) → updated News

**Mock data:**
- Generate 50+ dummy articles
- Various categories
- Realistic content
- Different publish dates
- Random like counts

**Acceptance Criteria:**
- [ ] NewsRepository created
- [ ] Uses DummyDataService
- [ ] Pagination support
- [ ] Category filtering
- [ ] Like state persists in memory

---

#### Task 3.1.3: Create News State Providers
**Description:** State management for news feature

**Files:**
- `lib/features/news/providers/news_list_provider.dart`
- `lib/features/news/providers/news_detail_provider.dart`

**Providers:**
- newsListProvider - List with pagination
- newsDetailProvider.family - Single article by ID
- newsFilterProvider - Current filter state

**Acceptance Criteria:**
- [ ] All providers created
- [ ] Uses NewsRepository
- [ ] Handles loading/error states
- [ ] Pagination logic implemented
- [ ] Filter state management

---

### 3.2 News UI Components

#### Task 3.2.1: Create News Card Widget
**Description:** Reusable card for news list

**File:** `lib/features/news/widgets/news_card.dart`

**UI Elements:**
- Featured image (cached)
- Category tag
- Title (2 lines max)
- Excerpt (3 lines max)
- Author with avatar
- Publish date
- Like button with count
- Read time

**Acceptance Criteria:**
- [ ] NewsCard widget created
- [ ] Uses design system styling
- [ ] Image caching with placeholder
- [ ] Tap navigates to detail
- [ ] Like button functional

---

#### Task 3.2.2: Create News List Screen
**Description:** Main news feed with infinite scroll

**File:** `lib/features/news/screens/news_list_screen.dart`

**Features:**
- Pull to refresh
- Infinite scroll pagination
- Category filter chips
- Loading states (skeleton)
- Empty state
- Error handling

**Acceptance Criteria:**
- [ ] NewsListScreen created
- [ ] Pagination working (20 items/page)
- [ ] Pull to refresh implemented
- [ ] Category filtering
- [ ] Skeleton loaders during fetch
- [ ] Empty state when no news
- [ ] Error retry mechanism

---

#### Task 3.2.3: Create News Detail Screen
**Description:** Full article view

**File:** `lib/features/news/screens/news_detail_screen.dart`

**UI Elements:**
- Hero image
- Category badge
- Title
- Author info with avatar
- Publish date & read time
- Full content (HTML rendering)
- Like button
- Share button (future)
- Related articles (future)

**Acceptance Criteria:**
- [ ] NewsDetailScreen created
- [ ] HTML content rendered with flutter_html
- [ ] Images in content cached
- [ ] Like functionality works
- [ ] Loading skeleton
- [ ] Error state
- [ ] Back navigation

---

#### Task 3.2.4: Implement Like Functionality
**Description:** Like/unlike articles with auth check

**File:** `lib/features/news/providers/like_provider.dart`

**Features:**
- Check if user authenticated
- Optimistic UI update
- Update like count
- Persist state
- Sync across screens

**Acceptance Criteria:**
- [ ] Like provider created
- [ ] Auth check before like
- [ ] Optimistic update (instant feedback)
- [ ] Updates both list and detail views
- [ ] Shows login prompt if not authenticated

---

#### Task 3.2.5: Add News Category Filter
**Description:** Filter news by category

**File:** `lib/features/news/widgets/news_filter_bar.dart`

**Categories:**
- All
- Health
- Education
- Protection
- Advocacy
- Emergency

**Acceptance Criteria:**
- [ ] FilterBar widget created
- [ ] Horizontal scrollable chips
- [ ] Selected state styling
- [ ] Updates news list on selection
- [ ] Persists selection (optional)

---

**Phase 3 Milestone:**
✅ News feed fully functional
✅ Article detail view working
✅ Like/unlike functionality
✅ Pagination and filtering
✅ Polished UI with loading states

---

## Phase 4: Educational Content
**Duration:** Week 4 (5-7 days)
**Focus:** Browse categories, view content, mandala integration

### 4.1 Content Models & Data

#### Task 4.1.1: Create Content Models
**Description:** Educational content data structures

**Files:**
- `lib/features/education/models/content_category.dart`
- `lib/features/education/models/content_subcategory.dart`
- `lib/features/education/models/content.dart`

**Category fields:**
- id, name, slug, description
- icon, color, order
- hasSubcategories, subcategories

**Content fields:**
- id, title, excerpt, content (HTML)
- image, categoryId, subcategoryId
- tags, author, readTime
- downloads (PDF URLs - future)

**Acceptance Criteria:**
- [ ] All models created with freezed
- [ ] JSON serialization
- [ ] 4 main categories defined
- [ ] Subcategories for Survival & Development

---

#### Task 4.1.2: Create Education Repository (Mock)
**Description:** Educational content operations

**File:** `lib/features/education/repositories/education_repository.dart`

**Methods:**
- getCategories() → List<ContentCategory>
- getSubcategories(categoryId) → List<ContentSubcategory>
- getContent(categoryId, subcategoryId?) → List<Content>
- getContentById(id) → Content

**Mock data:**
- 4 main categories (Survival, Non-Discrimination, Best Interest, Respect Views)
- 5 subcategories for Survival & Development
- 30+ content articles
- Rich HTML content with images

**Acceptance Criteria:**
- [ ] EducationRepository created
- [ ] Realistic dummy content
- [ ] All 4 categories with content
- [ ] HTML content includes formatting

---

#### Task 4.1.3: Create Education Providers
**Description:** State management for education feature

**Files:**
- `lib/features/education/providers/categories_provider.dart`
- `lib/features/education/providers/content_provider.dart`

**Providers:**
- categoriesProvider - All categories
- contentListProvider.family - Content by category/subcategory
- contentDetailProvider.family - Single content by ID

**Acceptance Criteria:**
- [ ] All providers created
- [ ] Uses EducationRepository
- [ ] Loading/error handling
- [ ] Caching for performance

---

### 4.2 Education UI

#### Task 4.2.1: Update Mandala Home Screen
**Description:** Enhance existing mandala with real navigation

**File:** `lib/features/home/screens/mandala_home_screen.dart`

**Updates:**
- Use go_router for navigation (replace current routing)
- Add category metadata from providers
- Show category descriptions on tap
- Smooth animations

**Acceptance Criteria:**
- [ ] Uses go_router navigation
- [ ] Integrates with categories provider
- [ ] Animations polished
- [ ] Maintains current visual design

---

#### Task 4.2.2: Create Category Selection Screen
**Description:** Alternative category browsing (list view)

**File:** `lib/features/education/screens/category_selection_screen.dart`

**UI:**
- Grid or list of 4 main categories
- Category cards with icon, name, description
- Tap navigates to subcategories or content

**Acceptance Criteria:**
- [ ] CategorySelectionScreen created
- [ ] Uses design system cards
- [ ] Shows all 4 categories
- [ ] Navigation to content

---

#### Task 4.2.3: Create Subcategory Screen
**Description:** Browse subcategories (for Survival & Development)

**File:** `lib/features/education/screens/subcategory_screen.dart`

**UI:**
- List of 5 subcategories
- Card design with icons
- Navigation to content list

**Acceptance Criteria:**
- [ ] SubcategoryScreen created
- [ ] Shows subcategories for category
- [ ] Card layout with design system
- [ ] Navigation working

---

#### Task 4.2.4: Create Content List Screen
**Description:** Browse content articles in a category

**File:** `lib/features/education/screens/content_list_screen.dart`

**UI:**
- List of content cards
- Image, title, excerpt
- Read time
- Empty state if no content

**Acceptance Criteria:**
- [ ] ContentListScreen created
- [ ] Shows content for category/subcategory
- [ ] Card design consistent
- [ ] Navigation to detail
- [ ] Empty state

---

#### Task 4.2.5: Create Content Detail Screen
**Description:** Full content article view

**File:** `lib/features/education/screens/content_detail_screen.dart`

**UI:**
- Hero image
- Title
- Full HTML content
- Related content (future)
- Share button (future)
- Download PDF button (future - disabled)

**Acceptance Criteria:**
- [ ] ContentDetailScreen created
- [ ] HTML rendering with flutter_html
- [ ] Images cached
- [ ] Scrollable content
- [ ] Loading states

---

#### Task 4.2.6: Create Content Card Widget
**Description:** Reusable card for content lists

**File:** `lib/features/education/widgets/content_card.dart`

**UI:**
- Horizontal card layout
- Image thumbnail
- Title (2 lines)
- Excerpt (2 lines)
- Read time
- Category badge

**Acceptance Criteria:**
- [ ] ContentCard widget created
- [ ] Design system styling
- [ ] Image caching
- [ ] Tap navigation

---

**Phase 4 Milestone:**
✅ Educational content browsing complete
✅ All 4 categories accessible
✅ Content detail views functional
✅ Mandala navigation integrated

---

## Phase 5: Event Reporting
**Duration:** Week 5 (5-7 days)
**Focus:** Report incidents, file upload, form validation

### 5.1 Event Models & Services

#### Task 5.1.1: Create Event Models
**Description:** Event reporting data structures

**Files:**
- `lib/features/events/models/event_report.dart`
- `lib/features/events/models/event_category.dart`
- `lib/features/events/models/event_severity.dart`
- `lib/features/events/models/attachment.dart`

**EventReport fields:**
- id, referenceNumber, userId, title, description
- category, severity, location, dateTime
- contactInfo (name, phone, email)
- attachments (images, videos, PDFs)
- status, createdAt

**Enums:**
- EventCategory: child_abuse, neglect, exploitation, trafficking, other
- EventSeverity: low, medium, high, critical

**Acceptance Criteria:**
- [ ] All models created
- [ ] Freezed annotations
- [ ] Validation methods
- [ ] Reference number generation

---

#### Task 5.1.2: Create File Upload Service
**Description:** Handle file selection and compression

**File:** `lib/core/services/file_upload_service.dart`

**Features:**
- Pick image from camera/gallery
- Pick video
- Pick document (PDF)
- Compress images >2MB
- Strip EXIF data
- Validate file size/type
- Preview generation

**Acceptance Criteria:**
- [ ] FileUploadService created
- [ ] Uses image_picker
- [ ] Image compression with flutter_image_compress
- [ ] File size validation (10MB images, 50MB videos)
- [ ] EXIF removal
- [ ] Returns file metadata

---

#### Task 5.1.3: Create Events Repository (Mock)
**Description:** Event submission with mock backend

**File:** `lib/features/events/repositories/events_repository.dart`

**Methods:**
- submitEvent(EventReport) → referenceNumber
- uploadFile(File) → fileUrl
- getEventStatus(referenceNumber) → status

**Mock behavior:**
- Generate unique reference number
- Simulate file upload (return dummy URL)
- Store in memory
- Return success

**Acceptance Criteria:**
- [ ] EventsRepository created
- [ ] Mock submission working
- [ ] File upload simulation
- [ ] Reference number generation

---

#### Task 5.1.4: Create Event Form Provider
**Description:** State management for report form

**File:** `lib/features/events/providers/event_form_provider.dart`

**State:**
- Form fields (title, description, etc.)
- Selected files
- Loading state
- Error messages
- Submission status

**Actions:**
- updateField(field, value)
- addFile(file)
- removeFile(index)
- submitReport()

**Acceptance Criteria:**
- [ ] Provider created
- [ ] Form state management
- [ ] File management
- [ ] Validation logic
- [ ] Submission handling

---

### 5.2 Event Reporting UI

#### Task 5.2.1: Create Event Report Form Screen
**Description:** Multi-step form for incident reporting

**File:** `lib/features/events/screens/event_report_screen.dart`

**Form sections:**
1. Basic Info (title, description, category)
2. Severity & Date/Time
3. Location (text input or future geolocation)
4. Contact Info (name, phone, email)
5. Attachments (images, videos, documents)

**Validation:**
- All required fields
- Email format
- Phone format
- File size limits
- Category/severity selection

**Acceptance Criteria:**
- [ ] EventReportScreen created
- [ ] All form fields implemented
- [ ] Multi-step or single page layout
- [ ] Validation on all fields
- [ ] Auth check (redirect if not logged in)

---

#### Task 5.2.2: Create File Picker Widget
**Description:** File selection UI component

**File:** `lib/features/events/widgets/file_picker_widget.dart`

**Features:**
- Pick from camera
- Pick from gallery
- Pick video
- Pick document
- Show selected files
- Remove file option
- File preview thumbnails
- Max 5 files limit

**Acceptance Criteria:**
- [ ] FilePickerWidget created
- [ ] Image/video/document selection
- [ ] Thumbnail previews
- [ ] Remove functionality
- [ ] File count limit
- [ ] Loading during compression

---

#### Task 5.2.3: Create Category/Severity Selector
**Description:** Dropdowns or radio buttons for selection

**File:** `lib/features/events/widgets/category_selector.dart`

**UI:**
- Category dropdown/radio
- Severity selector with visual indicators (colors)
- Descriptions for each option

**Acceptance Criteria:**
- [ ] CategorySelector widget created
- [ ] Visual severity indicators
- [ ] Clear descriptions
- [ ] Updates form state

---

#### Task 5.2.4: Create Submission Success Screen
**Description:** Confirmation after report submitted

**File:** `lib/features/events/screens/event_success_screen.dart`

**UI:**
- Success icon/animation
- Reference number (large, copyable)
- Confirmation message
- What happens next info
- Return to home button

**Acceptance Criteria:**
- [ ] SuccessScreen created
- [ ] Shows reference number
- [ ] Copy to clipboard button
- [ ] Clear messaging
- [ ] Navigation to home

---

#### Task 5.2.5: Add Form Validation
**Description:** Client-side validation for all fields

**File:** `lib/features/events/utils/event_validation.dart`

**Validators:**
- Required field
- Email format
- Phone format (with country code)
- Text length (min/max)
- Date not in future
- File size/type

**Acceptance Criteria:**
- [ ] Validation functions created
- [ ] Reusable validators
- [ ] Clear error messages
- [ ] Real-time validation feedback

---

**Phase 5 Milestone:**
✅ Event reporting fully functional
✅ File upload working (images, videos, PDFs)
✅ Form validation complete
✅ Success confirmation with reference number

---

## Phase 6: Feedback & Communication
**Duration:** Week 6 (5 days)
**Focus:** Feedback list, subscription, contact form

### 6.1 Feedback Feature

#### Task 6.1.1: Create Feedback Models
**Description:** Feedback data structures

**Files:**
- `lib/features/feedback/models/feedback.dart`
- `lib/features/feedback/models/feedback_category.dart`

**Feedback fields:**
- id, userId, category, subject, message
- email, status, createdAt, response

**Acceptance Criteria:**
- [ ] Models created with freezed
- [ ] Category enum defined
- [ ] JSON serialization

---

#### Task 6.1.2: Create Feedback Repository (Mock)
**Description:** Feedback operations with dummy data

**File:** `lib/features/feedback/repositories/feedback_repository.dart`

**Methods:**
- getFeedbackList(page, limit) → List<Feedback>
- submitFeedback(Feedback) → success

**Mock data:**
- 20+ feedback items
- Various categories and statuses
- Realistic dates

**Acceptance Criteria:**
- [ ] FeedbackRepository created
- [ ] Mock data generation
- [ ] Pagination support
- [ ] Submission simulation

---

#### Task 6.1.3: Create Feedback List Screen
**Description:** Browse submitted feedback

**File:** `lib/features/feedback/screens/feedback_list_screen.dart`

**UI:**
- List of feedback cards
- Category badge
- Subject & excerpt
- Status indicator
- Date submitted
- Empty state

**Acceptance Criteria:**
- [ ] FeedbackListScreen created
- [ ] Shows paginated feedback
- [ ] Status indicators (pending, in_review, responded)
- [ ] Card design consistent
- [ ] Empty state when no feedback

---

#### Task 6.1.4: Create Feedback Detail Screen (Optional)
**Description:** View full feedback and response

**File:** `lib/features/feedback/screens/feedback_detail_screen.dart`

**UI:**
- Full message
- Category & status
- Admin response (if any)
- Timestamp

**Acceptance Criteria:**
- [ ] FeedbackDetailScreen created
- [ ] Shows full content
- [ ] Response section (if responded)
- [ ] Navigation from list

---

### 6.2 Email Subscription

#### Task 6.2.1: Create Subscription Models
**Description:** Email subscription data

**File:** `lib/features/subscription/models/subscription.dart`

**Fields:**
- email, preferences (news, newsletter, events)
- status (pending, active, unsubscribed)
- confirmationToken

**Acceptance Criteria:**
- [ ] Model created
- [ ] Preference options defined
- [ ] Validation methods

---

#### Task 6.2.2: Create Subscription Repository (Mock)
**Description:** Email subscription operations

**File:** `lib/features/subscription/repositories/subscription_repository.dart`

**Methods:**
- subscribe(email, preferences) → success message
- confirmSubscription(token) → success
- unsubscribe(email) → success

**Mock behavior:**
- Accept any email
- Return success
- Simulate double opt-in flow

**Acceptance Criteria:**
- [ ] SubscriptionRepository created
- [ ] Mock subscription flow
- [ ] Confirmation simulation

---

#### Task 6.2.3: Create Subscription Screen
**Description:** Email subscription form

**File:** `lib/features/subscription/screens/subscription_screen.dart`

**UI:**
- Email input
- Preference checkboxes (news, newsletter, events)
- Subscribe button
- Privacy policy link
- Success message

**Validation:**
- Email format required
- At least one preference selected

**Acceptance Criteria:**
- [ ] SubscriptionScreen created
- [ ] Email validation
- [ ] Preference selection
- [ ] Success state
- [ ] Error handling

---

### 6.3 Contact Form

#### Task 6.3.1: Create Contact Models
**Description:** Contact form data structures

**File:** `lib/features/contact/models/contact_submission.dart`

**Fields:**
- referenceNumber, name, email, subject, message
- attachment (optional file)
- status, createdAt

**Acceptance Criteria:**
- [ ] Model created
- [ ] Reference number generation
- [ ] Validation methods

---

#### Task 6.3.2: Create Contact Repository (Mock)
**Description:** Contact form submission

**File:** `lib/features/contact/repositories/contact_repository.dart`

**Methods:**
- submitContact(ContactSubmission) → referenceNumber
- uploadAttachment(File) → fileUrl

**Mock behavior:**
- Generate reference number
- Simulate submission
- Return success

**Acceptance Criteria:**
- [ ] ContactRepository created
- [ ] Mock submission
- [ ] Reference number generation

---

#### Task 6.3.3: Create Contact Form Screen
**Description:** Contact us form

**File:** `lib/features/contact/screens/contact_screen.dart`

**UI:**
- Name input (pre-filled if logged in)
- Email input (pre-filled if logged in)
- Subject dropdown
- Message textarea
- Attachment picker (optional)
- Submit button

**Validation:**
- All fields required except attachment
- Email format
- Message min length (20 chars)

**Acceptance Criteria:**
- [ ] ContactScreen created
- [ ] All fields implemented
- [ ] Validation working
- [ ] Pre-fill user info if authenticated
- [ ] Attachment support
- [ ] Success message with reference number

---

**Phase 6 Milestone:**
✅ Feedback viewing functional
✅ Email subscription working
✅ Contact form complete
✅ All communication features done

---

## Phase 7: Polish & Testing
**Duration:** Week 7 (5-7 days)
**Focus:** Animations, error handling, testing, accessibility

### 7.1 UI/UX Polish

#### Task 7.1.1: Add Page Transitions
**Description:** Smooth navigation animations

**Implementation:**
- Custom page route transitions
- Slide transitions for push
- Fade transitions for modals
- Hero animations for images

**Acceptance Criteria:**
- [ ] Custom transitions in go_router
- [ ] Consistent animation duration (300ms)
- [ ] Hero animations on news/content images
- [ ] Smooth back navigation

---

#### Task 7.1.2: Add Micro-interactions
**Description:** Button feedback and hover states

**Enhancements:**
- Button press animations (scale)
- Ripple effects
- Loading button states
- Swipe gestures (future)

**Acceptance Criteria:**
- [ ] All buttons have press feedback
- [ ] Loading states animated
- [ ] Smooth interactions throughout app

---

#### Task 7.1.3: Implement Skeleton Loaders
**Description:** Replace generic loading indicators

**Files:**
- `lib/widgets/loading/news_skeleton.dart`
- `lib/widgets/loading/content_skeleton.dart`
- `lib/widgets/loading/feedback_skeleton.dart`

**Acceptance Criteria:**
- [ ] Shimmer skeleton for news list
- [ ] Shimmer skeleton for content list
- [ ] Skeleton matches actual card layouts
- [ ] Used across all list screens

---

#### Task 7.1.4: Enhance Empty States
**Description:** Better empty state designs

**Updates:**
- Custom illustrations for each feature
- Helpful messaging
- Action buttons
- Animations

**Acceptance Criteria:**
- [ ] Empty states for news, content, feedback
- [ ] Clear messaging
- [ ] Action buttons (e.g., "Browse Categories")
- [ ] Consistent styling

---

#### Task 7.1.5: Add Toast Notifications
**Description:** User feedback for actions

**File:** `lib/core/services/notification_service.dart`

**Toasts for:**
- Successful actions (login, submission, etc.)
- Errors
- Warnings
- Info messages

**Acceptance Criteria:**
- [ ] Toast service created
- [ ] Shows at bottom with icon
- [ ] Auto-dismiss (3s for success, 5s for errors)
- [ ] Queue multiple toasts
- [ ] Color-coded by type

---

### 7.2 Error Handling

#### Task 7.2.1: Create Error Screens
**Description:** Dedicated error UI

**Files:**
- `lib/widgets/errors/error_screen.dart`
- `lib/widgets/errors/network_error.dart`
- `lib/widgets/errors/not_found_screen.dart`

**Error types:**
- Network error (offline)
- Server error (500)
- Not found (404)
- Permission denied (403)

**Acceptance Criteria:**
- [ ] Error widgets created
- [ ] Retry button functionality
- [ ] Clear error messages
- [ ] Used across app

---

#### Task 7.2.2: Implement Global Error Handler
**Description:** Catch and log all errors

**File:** `lib/core/services/error_handler.dart`

**Features:**
- FlutterError.onError handler
- PlatformDispatcher.onError handler
- Log errors in debug mode
- Show user-friendly messages
- Crash reporting integration (future)

**Acceptance Criteria:**
- [ ] Global error handlers set up
- [ ] Errors logged to console
- [ ] User sees friendly messages
- [ ] App doesn't crash on errors

---

#### Task 7.2.3: Add Network Connectivity Handling
**Description:** Detect offline and show appropriate UI

**Features:**
- Banner when offline
- Disable actions requiring network
- Queue actions for when online (future)
- Retry failed requests

**Acceptance Criteria:**
- [ ] Connectivity banner widget
- [ ] Shows when offline
- [ ] Updates when connectivity restored
- [ ] Actions disabled gracefully

---

### 7.3 Testing

#### Task 7.3.1: Write Unit Tests for Business Logic
**Description:** Test utilities, validators, services

**Test files:**
- `test/core/utils/validation_test.dart`
- `test/features/auth/auth_repository_test.dart`
- `test/features/news/news_repository_test.dart`

**Coverage:**
- Validation functions
- Repository methods
- State providers
- Utility functions

**Acceptance Criteria:**
- [ ] Unit tests for all repositories
- [ ] Unit tests for validation
- [ ] Unit tests for providers
- [ ] 80%+ coverage on tested files

---

#### Task 7.3.2: Write Widget Tests for Key Screens
**Description:** Test UI components

**Test files:**
- `test/features/auth/screens/login_screen_test.dart`
- `test/features/news/screens/news_list_screen_test.dart`
- `test/widgets/buttons/app_button_test.dart`

**Coverage:**
- Login/signup screens
- News list screen
- Shared components (buttons, cards)

**Acceptance Criteria:**
- [ ] Widget tests for auth screens
- [ ] Widget tests for main screens
- [ ] Widget tests for shared components
- [ ] Tests pass with `flutter test`

---

#### Task 7.3.3: Write Integration Tests
**Description:** Test critical user flows

**Test file:** `integration_test/app_test.dart`

**Flows to test:**
1. Login → View news → Like article
2. Signup → Report event → Success
3. Browse education → View content
4. Submit contact form

**Acceptance Criteria:**
- [ ] Integration test package added
- [ ] 4 critical flows tested
- [ ] Tests run on emulator/device
- [ ] All tests passing

---

#### Task 7.3.4: Manual QA Testing
**Description:** Comprehensive manual testing

**Test scenarios:**
- All navigation paths
- Form validations
- Error states
- Loading states
- Offline behavior
- Different screen sizes (phone, tablet)
- iOS and Android

**Acceptance Criteria:**
- [ ] Test plan document created
- [ ] All scenarios tested
- [ ] Bugs logged and fixed
- [ ] Sign-off from QA

---

### 7.4 Accessibility

#### Task 7.4.1: Add Semantic Labels
**Description:** Screen reader support

**Updates:**
- Add Semantics widgets
- Label all interactive elements
- Describe images
- Reading order

**Acceptance Criteria:**
- [ ] All buttons have semantic labels
- [ ] Images have descriptions
- [ ] Forms are accessible
- [ ] Test with TalkBack/VoiceOver

---

#### Task 7.4.2: Ensure Color Contrast
**Description:** WCAG AA compliance

**Checks:**
- Text contrast ratios (4.5:1 for body, 3:1 for large)
- Button contrast
- Focus indicators

**Acceptance Criteria:**
- [ ] All text meets contrast requirements
- [ ] Buttons have clear visual states
- [ ] Focus indicators visible

---

#### Task 7.4.3: Add Keyboard Navigation (Web)
**Description:** Support for keyboard users

**Features:**
- Tab navigation
- Enter to submit
- Escape to close
- Arrow keys for lists

**Acceptance Criteria:**
- [ ] All interactive elements tabbable
- [ ] Focus order logical
- [ ] Keyboard shortcuts work
- [ ] Tested on web build

---

**Phase 7 Milestone:**
✅ App polished with animations
✅ Comprehensive error handling
✅ Test coverage >70%
✅ Accessible to all users

---

## Phase 8: Deployment Preparation
**Duration:** Week 8 (5 days)
**Focus:** App icons, splash screens, build optimization, store prep

### 8.1 Branding & Assets

#### Task 8.1.1: Generate App Icons
**Description:** Create icons for iOS and Android

**Tools:** flutter_launcher_icons package

**Sizes:**
- Android: 48dp to 512dp
- iOS: 20pt to 1024pt
- Adaptive icon (Android)

**Acceptance Criteria:**
- [ ] flutter_launcher_icons configured
- [ ] UNICEF logo as app icon
- [ ] Icons generated for all sizes
- [ ] Tested on devices

---

#### Task 8.1.2: Create Splash Screens
**Description:** Launch screen with branding

**Tools:** flutter_native_splash package

**Design:**
- UNICEF logo centered
- Brand color background
- Loading indicator (optional)

**Acceptance Criteria:**
- [ ] Splash screen configured
- [ ] iOS splash screen
- [ ] Android splash screen
- [ ] Displays correctly on launch

---

#### Task 8.1.3: Update App Name & Bundle ID
**Description:** Production app identifiers

**Android:**
- Package name: com.unicef.childprotection
- App name: UNICEF Child Protection

**iOS:**
- Bundle ID: com.unicef.childprotection
- Display name: UNICEF Child Protection

**Acceptance Criteria:**
- [ ] Android package name updated
- [ ] iOS bundle ID updated
- [ ] App names updated
- [ ] No conflicts with existing apps

---

### 8.2 Build Optimization

#### Task 8.2.1: Optimize App Size
**Description:** Reduce APK/IPA size

**Optimizations:**
- Enable ProGuard/R8 (Android)
- Split APKs by ABI
- Compress images
- Remove unused resources
- Tree-shaking

**Acceptance Criteria:**
- [ ] ProGuard enabled in release build
- [ ] App size <30MB (Android)
- [ ] App size <40MB (iOS)
- [ ] No crashes after optimization

---

#### Task 8.2.2: Performance Profiling
**Description:** Ensure smooth performance

**Profile:**
- Frame rendering (60fps target)
- Memory usage
- App startup time
- Image loading
- List scrolling

**Tools:** Flutter DevTools

**Acceptance Criteria:**
- [ ] No jank during scrolling
- [ ] Startup time <3s
- [ ] Memory usage reasonable
- [ ] Images load smoothly
- [ ] Profile mode tested

---

#### Task 8.2.3: Enable Code Obfuscation
**Description:** Protect source code

**Configuration:**
- Enable obfuscation in release builds
- Save symbol files for crash reports

**Acceptance Criteria:**
- [ ] Obfuscation enabled
- [ ] Symbol files generated
- [ ] App still functions correctly
- [ ] Debug builds not obfuscated

---

### 8.3 Production Configuration

#### Task 8.3.1: Setup Production Configuration
**Description:** Configure production settings using dart-define or update AppConfig

**Approach 1 - dart-define (Recommended):**
Pass configuration at build time using `--dart-define`:
```
flutter build apk --dart-define=API_BASE_URL=https://api.unicef.org/api/v1 --dart-define=ENABLE_LOGGING=false --release
```

**Approach 2 - Update AppConfig:**
Create production build with updated `lib/core/config/app_config.dart` constants

**Production Settings:**
- API_BASE_URL: https://api.unicef.org/api/v1 (when backend ready)
- ENABLE_LOGGING: false
- ENABLE_ANALYTICS: true
- SENTRY_DSN: Production crash reporting DSN

**Acceptance Criteria:**
- [ ] Production configuration method decided (dart-define or AppConfig)
- [ ] API URL points to production (when available)
- [ ] Logging disabled in production builds
- [ ] Analytics enabled
- [ ] Build scripts documented

---

#### Task 8.3.2: Add Crash Reporting
**Description:** Integrate Sentry or Firebase Crashlytics

**Implementation:**
- Add package (sentry_flutter or firebase_crashlytics)
- Initialize in main.dart
- Test crash reporting
- Setup dashboard

**Acceptance Criteria:**
- [ ] Crash reporting package added
- [ ] Initialized with production DSN
- [ ] Test crash reported successfully
- [ ] Dashboard accessible

---

#### Task 8.3.3: Add Analytics (Optional)
**Description:** Track user behavior

**Tools:** Firebase Analytics or similar

**Events to track:**
- Screen views
- User login/signup
- News article views
- Event report submissions
- Content views

**Acceptance Criteria:**
- [ ] Analytics package added
- [ ] Key events tracked
- [ ] Privacy compliant
- [ ] Dashboard setup

---

### 8.4 Build & Release

#### Task 8.4.1: Build Android Release
**Description:** Generate signed APK and App Bundle

**Steps:**
1. Create keystore
2. Configure signing in build.gradle
3. Build app bundle: `flutter build appbundle --release`
4. Build APK: `flutter build apk --release`

**Acceptance Criteria:**
- [ ] Keystore created and secured
- [ ] App bundle built successfully
- [ ] APK built successfully
- [ ] Tested on physical device
- [ ] No crashes or errors

---

#### Task 8.4.2: Build iOS Release
**Description:** Generate IPA for App Store

**Steps:**
1. Configure provisioning profiles
2. Update version and build number
3. Build IPA: `flutter build ipa --release`
4. Archive in Xcode

**Acceptance Criteria:**
- [ ] Provisioning profiles configured
- [ ] IPA built successfully
- [ ] Tested on physical iPhone
- [ ] No crashes or errors

---

#### Task 8.4.3: Prepare Store Listings
**Description:** App Store and Play Store metadata

**Assets needed:**
- App description (short & long)
- Screenshots (5+ per platform)
- Feature graphic (Play Store)
- Privacy policy URL
- Support email
- Category selection
- Keywords/tags

**Acceptance Criteria:**
- [ ] App descriptions written
- [ ] Screenshots captured
- [ ] Feature graphic created
- [ ] Privacy policy hosted
- [ ] All metadata prepared

---

#### Task 8.4.4: Beta Testing
**Description:** Internal/external testing

**Platforms:**
- TestFlight (iOS)
- Google Play Internal Testing (Android)

**Testers:**
- Internal team (5-10 users)
- External beta testers (20-50 users)

**Acceptance Criteria:**
- [ ] App uploaded to TestFlight
- [ ] App uploaded to Play Console (internal track)
- [ ] Beta testers invited
- [ ] Feedback collected
- [ ] Critical bugs fixed

---

#### Task 8.4.5: Final Release
**Description:** Submit to app stores

**Google Play:**
1. Upload app bundle
2. Complete store listing
3. Submit for review

**App Store:**
1. Upload IPA via Xcode
2. Complete App Store Connect listing
3. Submit for review

**Acceptance Criteria:**
- [ ] Android app submitted
- [ ] iOS app submitted
- [ ] Both apps approved
- [ ] Published to stores
- [ ] Download links tested

---

**Phase 8 Milestone:**
✅ App published to Google Play
✅ App published to App Store
✅ Production monitoring active
✅ Project complete!

---

## Summary Checklist

### Infrastructure (Phase 1)
- [ ] All dependencies installed
- [ ] Folder structure created
- [ ] Design system implemented (colors, typography, spacing, shadows)
- [ ] Core services (API client, storage, connectivity, dummy data)
- [ ] Shared components (buttons, inputs, cards, loading, empty states)

### Navigation & Auth (Phase 2)
- [ ] go_router configured with all routes
- [ ] App shell with drawer
- [ ] Login/signup/forgot password screens
- [ ] Auth state management
- [ ] Route guards

### News (Phase 3)
- [ ] News list with pagination
- [ ] News detail view
- [ ] Like/unlike functionality
- [ ] Category filtering

### Education (Phase 4)
- [ ] Mandala navigation updated
- [ ] Category/subcategory browsing
- [ ] Content detail views
- [ ] 4 main categories + subcategories

### Events (Phase 5)
- [ ] Event report form
- [ ] File upload (images, videos, PDFs)
- [ ] Form validation
- [ ] Success confirmation

### Communication (Phase 6)
- [ ] Feedback list
- [ ] Email subscription
- [ ] Contact form

### Polish (Phase 7)
- [ ] Animations and transitions
- [ ] Skeleton loaders
- [ ] Error handling
- [ ] Testing (unit, widget, integration)
- [ ] Accessibility

### Deployment (Phase 8)
- [ ] App icons and splash screens
- [ ] Build optimization
- [ ] Crash reporting
- [ ] Store listings
- [ ] Beta testing
- [ ] Final release

---

## Notes

1. **Dummy Data Approach:** All API integrations use mock data services. When backend is ready, replace `DummyDataService` and repository methods with real API calls using the `ApiClient`.

2. **Parallel Work:** Phases 3-6 can have some parallel work once core infrastructure is done. News and Education features can be built simultaneously.

3. **Testing:** Don't skip testing phase. It catches bugs early and ensures quality.

4. **Iterations:** Expect to iterate on UI/UX based on user feedback during beta testing.

5. **Future Enhancements:** Features marked "future" in requirements can be added in subsequent releases (v2.0):
   - Offline support
   - Multi-language
   - Push notifications
   - Social sharing
   - PDF downloads
   - Advanced search

---

## Success Metrics

- [ ] All 19 API endpoints integrated (with mock data)
- [ ] 20+ screens implemented
- [ ] 10+ shared components
- [ ] 70%+ test coverage
- [ ] 60fps performance
- [ ] App size <40MB
- [ ] 4.5+ star rating target (after launch)
- [ ] Zero critical bugs in production

---

## Risk Mitigation

| Risk | Mitigation |
|------|------------|
| Scope creep | Stick to roadmap, log future features separately |
| Performance issues | Profile regularly with DevTools |
| Design inconsistencies | Use design system components |
| Testing delays | Write tests as you build features |
| API changes | Keep mock services decoupled |
| Store rejection | Follow platform guidelines strictly |

---

**Last Updated:** 2025-11-21
**Version:** 1.0
**Status:** Active Development
