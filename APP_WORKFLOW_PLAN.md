# UNICEF Child Protection App - Workflow Plan

**Version:** 1.0
**Date:** 2025-11-20
**Purpose:** Framework-agnostic workflow documentation for rebuilding the application

---

## Table of Contents

1. [App Overview](#app-overview)
2. [User Roles & Personas](#user-roles--personas)
3. [Core Features & Workflows](#core-features--workflows)
4. [Screen Flow Diagrams](#screen-flow-diagrams)
5. [API Contracts](#api-contracts)
6. [Data Models](#data-models)
7. [Business Rules](#business-rules)
8. [UI/UX Specifications](#uiux-specifications)
9. [Security Requirements](#security-requirements)
10. [Technical Requirements](#technical-requirements)

---

## 1. App Overview

### 1.1 Purpose
Mobile application for child protection awareness, reporting incidents, accessing educational content, and engaging with UNICEF initiatives.

### 1.2 Target Users
- General public (parents, guardians, community members)
- Children and youth
- Educators and social workers
- UNICEF staff and volunteers

### 1.3 Key Objectives
- Provide educational content on child rights and protection
- Enable incident/event reporting with media uploads
- Facilitate community engagement through news and feedback
- Build email subscriber base for UNICEF updates
- Provide contact mechanisms for assistance

### 1.4 Platform Requirements
- iOS mobile app
- Android mobile app
- Offline capability (future enhancement)
- Multi-language support (future enhancement)

---

## 2. User Roles & Personas

### 2.1 Anonymous User
**Access Level:** Limited
**Capabilities:**
- View educational content
- Read news articles
- Access app information
- Sign up for account
- Subscribe to email list
- Submit contact form

**Restrictions:**
- Cannot like news articles
- Cannot report events
- Cannot submit feedback

### 2.2 Registered User
**Access Level:** Full
**Capabilities:**
- All anonymous user capabilities
- Like/unlike news articles
- Report events with file attachments
- Submit detailed feedback
- Access personalized features

**Requirements:**
- Valid email address
- Password-protected account

### 2.3 Administrator (Backend)
**Access Level:** Full backend access
**Capabilities:**
- Manage news content
- Review event reports
- Manage educational content
- View feedback submissions
- Manage user accounts
- Moderate content

---

## 3. Core Features & Workflows

### 3.1 Authentication & User Management

#### **3.1.1 User Registration Flow**

**Trigger:** User taps "Sign Up" button

**Steps:**
1. User navigates to signup screen
2. User enters registration details:
   - Full Name (required)
   - Email Address (required, must be valid format)
   - Password (required, min 8 characters, must include uppercase, lowercase, number)
   - Confirm Password (required, must match password)
3. User agrees to Terms & Conditions (checkbox)
4. User taps "Register" button
5. System validates inputs:
   - Check all required fields filled
   - Validate email format
   - Check password strength
   - Verify password match
   - Check email not already registered
6. System sends registration data to API
7. API creates user account
8. System displays success message
9. User redirected to login screen

**Validation Rules:**
- Email: RFC 5322 compliant format
- Password: Minimum 8 characters, at least 1 uppercase, 1 lowercase, 1 number, 1 special character
- Name: Minimum 2 characters, letters and spaces only
- All fields: No leading/trailing whitespace

**Error Handling:**
- Email already exists: "This email is already registered. Please login or use a different email."
- Weak password: "Password must contain at least 8 characters with uppercase, lowercase, and numbers."
- Network error: "Unable to connect. Please check your internet connection and try again."
- Server error: "Registration failed. Please try again later."

**Success State:**
- Modal/Toast: "Registration successful! Please login with your credentials."
- Auto-navigate to login screen after 2 seconds

---

#### **3.1.2 User Login Flow**

**Trigger:** User taps "Login" from menu or is redirected

**Steps:**
1. User navigates to login screen
2. User enters credentials:
   - Email Address
   - Password
3. User taps "Login" button
4. System validates inputs:
   - Check fields not empty
   - Validate email format
5. System sends credentials to API
6. API validates credentials
7. API returns authentication token + user details
8. System stores:
   - Auth token (secure storage)
   - User ID
   - User name
   - Login timestamp
   - Session flag
9. System redirects to Home/Inbox
10. System updates menu to show logged-in state

**Session Management:**
- Token stored in secure encrypted storage (NOT sessionStorage)
- Token expires after 24 hours
- Auto-logout on token expiry
- Token sent in Authorization header for all authenticated requests

**Error Handling:**
- Invalid credentials: "Incorrect email or password. Please try again."
- Account locked: "Your account has been locked. Please contact support."
- Network error: "Unable to connect. Please check your internet connection."
- Too many attempts: "Too many login attempts. Please try again in 15 minutes."

**Success State:**
- Navigate to /folder/Inbox
- Update menu items to show authenticated options
- Display welcome message: "Welcome back, [Name]!"

---

#### **3.1.3 Forgot Password Flow**

**Trigger:** User taps "Forgot Password?" link on login screen

**Steps:**
1. User navigates to forgot password screen
2. User enters registered email address
3. User taps "Send Reset Link" button
4. System validates email format
5. System sends request to API
6. API generates password reset token (valid 1 hour)
7. API sends email with reset link
8. System displays confirmation message
9. User checks email
10. User taps reset link (opens app or web)
11. User enters new password (2 fields: password + confirm)
12. User taps "Reset Password" button
13. System validates:
    - Token not expired
    - Passwords match
    - Password meets strength requirements
14. API updates password
15. System displays success message
16. User redirected to login screen

**Security Requirements:**
- Reset token: Cryptographically secure, 256-bit, single-use
- Token expiry: 1 hour
- Rate limiting: Max 3 reset requests per email per hour
- Email verification: Don't reveal if email exists or not

**Error Handling:**
- Invalid email format: "Please enter a valid email address."
- Token expired: "This reset link has expired. Please request a new one."
- Token invalid: "Invalid reset link. Please request a new password reset."
- Passwords don't match: "Passwords do not match. Please try again."

---

#### **3.1.4 Logout Flow**

**Trigger:** User taps "Logout" button (future feature)

**Steps:**
1. System displays confirmation dialog: "Are you sure you want to logout?"
2. User confirms
3. System clears:
   - Auth token
   - User data
   - Session flag
   - Cached user-specific content
4. System updates menu to show anonymous state
5. System redirects to Home/Inbox
6. System displays message: "You have been logged out successfully."

---

### 3.2 News & Engagement Feature

#### **3.2.1 View News Feed Flow**

**Trigger:** User taps "News" menu item or navigates to news screen

**Steps:**
1. User navigates to news screen
2. System displays loading indicator
3. System fetches news list from API (GET /getNews)
4. System receives news array with:
   - News ID
   - Title
   - Content/Description
   - Image filename
   - Author
   - Published date
   - Like count
   - Category/tags
5. For each news item with image:
   - System fetches image file (GET /getFiles/{filename})
   - System converts image to displayable format
   - System caches image locally
6. System displays news list:
   - Show loading skeleton while images load
   - Display news items in chronological order (newest first)
   - Show thumbnail, title, date, like count
7. User can:
   - Scroll through news list
   - Tap item to read full article
   - Like/unlike articles (if logged in)
   - Refresh list (pull-to-refresh)

**UI Components:**
- News Card: Thumbnail (16:9), Title (max 2 lines), Date, Like count, Like button
- List Layout: Vertical scroll, card-based
- Empty State: "No news articles available at the moment."
- Error State: "Unable to load news. Tap to retry."

**Performance Optimization:**
- Lazy load images (only when visible)
- Cache images locally for 24 hours
- Paginate results (20 items per page)
- Implement pull-to-refresh

---

#### **3.2.2 Read Full News Article Flow**

**Trigger:** User taps a news item in feed

**Steps:**
1. User taps news card
2. System navigates to article detail view (full screen or modal)
3. System displays:
   - Full-size hero image
   - Article title
   - Publication date
   - Author name
   - Full content (with rich text formatting)
   - Like count and button
   - Share button (future)
4. User can:
   - Read full content with scrolling
   - Like/unlike article
   - Return to news feed
   - Share article (future)

**Content Rendering:**
- Support HTML formatting (headings, paragraphs, lists, bold, italic)
- Support embedded images
- Support hyperlinks
- Sanitize HTML to prevent XSS

---

#### **3.2.3 Like/Unlike News Article Flow**

**Trigger:** User taps like button on news item

**Precondition:** User must be logged in

**Steps:**
1. User taps heart/like icon
2. System checks authentication state
3. If not logged in:
   - Display message: "Please login to like articles."
   - Redirect to login (optional)
   - Exit flow
4. If logged in:
   - System immediately toggles like button visual state (optimistic update)
   - System updates like count locally (+1 or -1)
   - System sends like/unlike request to API:
     - POST /addLikes with payload: { postId, userId }
   - API records like/unlike
   - API returns updated like count
   - System updates UI with server count (if different)

**Error Handling:**
- API error: Revert optimistic update, show message: "Unable to like article. Please try again."
- Network error: Queue action for retry when online

**Data Tracking:**
- Record: User ID, Post ID, Timestamp, Action (like/unlike)
- Prevent duplicate likes per user per post

---

### 3.3 Event/Incident Reporting Feature

#### **3.3.1 Report Event Flow**

**Trigger:** User taps "Event Sharing" or "Report Incident" menu item

**Precondition:** User should be logged in (enforce with route guard)

**Steps:**
1. User navigates to event reporting screen
2. System checks authentication:
   - If not logged in: Redirect to login with return URL
3. System displays event reporting form
4. User fills in event details:
   - **Event Title** (required, max 100 chars)
   - **Event Description** (required, max 1000 chars)
   - **Location/Venue** (required, text or map picker)
   - **Date & Time** (required, date-time picker)
   - **Contact Name** (required, auto-filled from user profile, editable)
   - **Contact Number** (required, phone number format)
   - **Category** (optional, dropdown: Child Abuse, Neglect, Exploitation, Other)
   - **Severity** (optional, dropdown: Low, Medium, High, Critical)
   - **Witnesses** (optional, text)
5. User attaches file (optional):
   - Tap "Attach Photo/Video" button
   - Choose source: Camera or Gallery
   - Select file (max 10MB)
   - System displays preview
   - User can remove and re-select
6. User taps "Submit Report" button
7. System validates inputs:
   - All required fields filled
   - Phone number valid format
   - File size within limit
   - File type allowed (jpg, png, pdf, mp4, mov)
8. If file attached:
   - System uploads file first (POST /fileUpload with FormData)
   - System displays upload progress
   - API returns file path/ID
9. System submits event data (POST /addEvent):
   - Include all form fields
   - Include file path if uploaded
   - Include user ID
   - Include timestamp
10. API stores event report
11. System displays success message:
    - "Thank you for your report. We will review it shortly."
    - "Report ID: #12345 - Keep this for reference."
12. System clears form
13. System navigates back to home or shows "Submit Another" option

**Form Validation Rules:**
- Title: 10-100 characters, alphanumeric + basic punctuation
- Description: 20-1000 characters
- Phone: Valid international format (E.164)
- File: Max 10MB, allowed types: image/jpeg, image/png, application/pdf, video/mp4, video/quicktime
- Date: Cannot be future date (for incidents), can be future (for events)

**File Upload Specifications:**
- Supported formats: JPEG, PNG, PDF, MP4, MOV
- Max file size: 10MB
- Compression: Auto-compress images >2MB before upload
- Upload method: Multipart form data
- Progress indication: Show percentage uploaded

**Privacy & Security:**
- Encrypt file during upload (HTTPS)
- Store files in secure cloud storage
- Generate unique filename (prevent overwrite)
- Scan files for malware
- Strip EXIF data from images (protect location privacy)

**Error Handling:**
- File too large: "File size exceeds 10MB. Please choose a smaller file."
- Invalid file type: "Invalid file type. Please upload JPG, PNG, PDF, or MP4 files only."
- Upload failed: "File upload failed. Please try again."
- Network error: Save draft locally, allow retry
- Server error: "Unable to submit report. Please try again later."

**Success State:**
- Display confirmation with report ID
- Send confirmation email to user
- Clear form data
- Option to submit another report or return home

---

### 3.4 Educational Content Feature

#### **3.4.1 Content Category Structure**

**Categories:**

1. **Survival & Development** (Category ID: 1)
   - Maternal and Child Health
   - Nutrition
   - Hygiene and Sanitation
   - Human Virus/Health Topics
   - Early Childhood Care and Development (ECCD)

2. **Respect for Child Views** (Category ID: 2)
   - Content about listening to children
   - Child participation rights

3. **Best Interest of the Child** (Category ID: 3)
   - Decision-making principles
   - Child-centered policies

4. **Non-Discrimination** (Category ID: 4)
   - Equality and inclusion
   - Fighting discrimination

---

#### **3.4.2 Browse Educational Content Flow**

**Trigger:** User taps educational menu items (Survival, Non-Discrimination, etc.)

**Steps:**
1. User taps category from menu (e.g., "Survival & Development")
2. System navigates to category landing page
3. System fetches content:
   - GET /getAllContent/{categoryId}
   - Returns array of content items
4. For Category 1 (Survival):
   - Display subcategory grid/list:
     - Maternal and Child Health (icon + title)
     - Nutrition (icon + title)
     - Hygiene and Sanitation (icon + title)
     - Health Topics (icon + title)
     - ECCD (icon + title)
   - User taps subcategory
   - Navigate to subcategory content page
5. For Categories 2-4:
   - Display content directly (no subcategories)
   - Show hero image
   - Show title and description
   - Show full content with rich formatting
6. System displays:
   - Loading skeleton while fetching
   - Error message if fetch fails
   - Empty state if no content

---

#### **3.4.3 View Subcategory Content Flow**

**Trigger:** User taps subcategory (e.g., "Maternal and Child Health")

**Steps:**
1. User taps subcategory card
2. System navigates to content detail page
3. System fetches:
   - GET /getAllCategories (for category mapping)
   - GET /getAllContent/{categoryId} (for specific subcategory)
4. System displays:
   - Hero image (full width)
   - Content title
   - Content body (rich text with HTML formatting)
   - Related resources (future)
   - Download PDF option (future)
5. User can:
   - Scroll through content
   - Tap embedded links
   - Navigate back to category
   - Share content (future)
   - Bookmark content (future)

**Content Rendering:**
- Support HTML: headings, paragraphs, lists, tables, images
- Support multimedia embeds: YouTube videos, audio clips
- Responsive images: Scale to screen width
- Accessibility: Screen reader support, alt text for images

---

### 3.5 Feedback & Communication Features

#### **3.5.1 View Feedback List Flow**

**Trigger:** User taps "Feedback" menu item

**Steps:**
1. User navigates to feedback screen
2. System displays loading indicator
3. System fetches feedback list (GET /getFeedback)
4. System displays feedback items:
   - User name or "Anonymous"
   - Feedback text (truncated to 2 lines)
   - Date submitted
   - Category/tag
5. User can:
   - Scroll through feedback list
   - Tap to read full feedback (future)
   - Filter by category (future)
   - Submit new feedback (future)

**Note:** Current implementation is view-only. Submission capability should be added.

---

#### **3.5.2 Submit Feedback Flow** (Future Enhancement)

**Trigger:** User taps "Submit Feedback" button

**Steps:**
1. User taps floating action button or "Submit" button
2. System displays feedback form (modal or new screen)
3. User enters:
   - Feedback Category (dropdown: App Issue, Suggestion, Complaint, Appreciation)
   - Subject (required, max 100 chars)
   - Message (required, max 500 chars)
   - Email (optional if logged in, required if anonymous)
   - Allow Contact checkbox (optional)
4. User taps "Submit" button
5. System validates inputs
6. System submits to API (POST /addFeedback)
7. API stores feedback
8. System displays success message
9. System adds feedback to list (if approved)

---

#### **3.5.3 Email Subscription Flow**

**Trigger:** User taps "Subscribe" or "Email Subscription" menu item

**Steps:**
1. User navigates to subscription screen
2. System displays subscription form:
   - Email input field (required)
   - Subscription preferences (checkboxes):
     - News updates
     - Event notifications
     - Educational content
     - Monthly newsletter
   - Privacy policy agreement checkbox (required)
3. User enters email address
4. User selects preferences
5. User taps "Subscribe" button
6. System validates:
   - Email format valid
   - Privacy policy agreed
   - At least one preference selected
7. System sends subscription request (POST /addEmailSubscription)
8. API stores subscription
9. API sends confirmation email
10. System displays success message:
    - "Thank you for subscribing! Please check your email to confirm."
11. User clicks confirmation link in email
12. Subscription activated

**Validation Rules:**
- Email: RFC 5322 format, max 254 characters
- No duplicate subscriptions (same email)
- Unsubscribe link in every email

**Error Handling:**
- Invalid email: "Please enter a valid email address."
- Already subscribed: "This email is already subscribed. Check your inbox for updates."
- API error: "Unable to subscribe. Please try again later."

**Privacy Compliance:**
- GDPR compliant (for EU users)
- Double opt-in (email confirmation required)
- Easy unsubscribe mechanism
- Privacy policy link visible
- Data retention policy (stated in policy)

---

#### **3.5.4 Contact Us Flow**

**Trigger:** User taps "Contact Us" menu item

**Steps:**
1. User navigates to contact form screen
2. System displays contact form:
   - Name (required, auto-filled if logged in)
   - Email (required, auto-filled if logged in)
   - Subject (optional, dropdown: General Inquiry, Support Request, Partnership, Media)
   - Message (required, max 1000 chars)
   - Attach file (optional, max 5MB)
3. User fills form
4. User taps "Send Message" button
5. System validates inputs
6. System submits to API (POST /addContact)
7. API stores contact submission
8. API sends confirmation email to user
9. API notifies UNICEF team
10. System displays success:
    - "Thank you for contacting us! We will respond within 48 hours."
    - "Reference number: #12345"
11. System clears form

**Response SLA:**
- Acknowledgment email: Immediate (automated)
- Response time: Within 48 hours (business days)
- Urgent inquiries: Flagged for priority handling

---

### 3.6 Navigation & App Shell

#### **3.6.1 Main Navigation Structure**

**Navigation Pattern:** Side menu (drawer) with split-pane layout

**Menu Items (Anonymous User):**
- Home / Inbox
- News
- Feedback (view only)
- Survival & Development (with submenu)
  - Maternal and Child Health
  - Nutrition
  - Hygiene and Sanitation
  - Health Topics
  - ECCD
- Respect for Child Views
- Best Interest of the Child
- Non-Discrimination
- Email Subscription
- Contact Us
- Login
- Sign Up

**Menu Items (Logged In User):**
- Home / Inbox
- News
- Event Reporting *(new)*
- Feedback
- Survival & Development (with submenu)
- Respect for Child Views
- Best Interest of the Child
- Non-Discrimination
- Email Subscription
- Contact Us
- My Profile *(future)*
- Settings *(future)*
- Logout *(future)*

**Header/Toolbar:**
- App logo (left)
- Page title (center)
- Menu toggle button (hamburger icon, left)
- Notifications icon (right, if logged in) *(future)*
- Search icon (right) *(future)*

**Footer:**
- Copyright notice
- UNICEF branding
- Links: Privacy Policy, Terms of Service, About

---

#### **3.6.2 Home/Inbox Screen Flow**

**Trigger:** App launch or user taps "Home" menu item

**Steps:**
1. System displays home screen
2. System checks authentication state
3. System displays:
   - Welcome banner (personalized if logged in)
   - Featured news (top 3 items)
   - Quick action cards:
     - Report Event (if logged in)
     - Subscribe to Newsletter
     - Educational Content
     - Contact Us
   - Recent updates section
   - Educational content carousel
4. User can:
   - Navigate to any feature via quick actions
   - Scroll through featured content
   - Access menu for full navigation

**Personalization (Logged In):**
- "Welcome back, [Name]!"
- Show recent activity
- Recommend content based on interests (future)

**Empty State (First Launch):**
- Welcome message
- App introduction
- Call-to-action to explore content

---

## 4. Screen Flow Diagrams

### 4.1 Authentication Flow

```
App Launch
    ↓
[Home Screen]
    ↓
User taps "Login"
    ↓
[Login Screen]
    ├─ Enter Email & Password → Tap "Login" → Success → [Home Screen - Logged In]
    ├─ Tap "Forgot Password?" → [Forgot Password Screen] → Enter Email → Check Email → Reset Password → [Login Screen]
    └─ Tap "Sign Up" → [Signup Screen] → Enter Details → Success → [Login Screen]
```

### 4.2 News Engagement Flow

```
[Home Screen]
    ↓
User taps "News"
    ↓
[News Feed]
    ├─ Scroll through articles
    ├─ Tap article → [Article Detail] → Read → Like (if logged in) → Back
    ├─ Pull to refresh → Reload feed
    └─ Tap like on feed item → Update count
```

### 4.3 Event Reporting Flow

```
[Home Screen] (Logged In)
    ↓
User taps "Event Reporting"
    ↓
[Event Form]
    ↓
Fill in details
    ↓
Tap "Attach File"
    ↓
[File Picker] → Select from Camera/Gallery
    ↓
Preview file
    ↓
Tap "Submit Report"
    ↓
[Upload Progress]
    ↓
[Success Confirmation]
    ↓
Return to Home or Submit Another
```

### 4.4 Educational Content Flow

```
[Home Screen]
    ↓
User taps "Survival & Development"
    ↓
[Category Screen - Subcategories]
    ↓
User taps "Maternal and Child Health"
    ↓
[Content Detail Screen]
    ├─ Scroll through content
    ├─ Tap embedded links
    ├─ Bookmark (future)
    └─ Share (future)
```

### 4.5 Complete App Flow Map

```
[App Launch]
    ↓
[Splash Screen] → Check Auth
    ├─ Authenticated → [Home - Logged In]
    └─ Not Authenticated → [Home - Anonymous]

[Main Menu]
├─ News → [News Feed] → [Article Detail]
├─ Event Reporting (Auth Required) → [Event Form] → [Confirmation]
├─ Feedback → [Feedback List]
├─ Educational Content
│   ├─ Survival → [Subcategories] → [Content Detail]
│   ├─ Respect Child Views → [Content Detail]
│   ├─ Best Interest → [Content Detail]
│   └─ Non-Discrimination → [Content Detail]
├─ Subscribe → [Subscription Form] → [Confirmation]
├─ Contact → [Contact Form] → [Confirmation]
├─ Login → [Login Form] → [Home - Logged In]
└─ Sign Up → [Signup Form] → [Login]
```

---

## 5. API Contracts

### 5.1 Base Configuration

**Base URL:** `https://api.unicef.example.com/api/v1/`
**Protocol:** HTTPS only
**Authentication:** Bearer token (JWT)
**Content-Type:** `application/json` (except file uploads)

**Request Headers:**
```
Authorization: Bearer {token}
Content-Type: application/json
Accept: application/json
X-Client-Version: {app_version}
X-Platform: {ios|android}
```

**Response Format:**
```json
{
  "success": true,
  "message": "Success message",
  "data": { },
  "timestamp": "2025-11-20T10:30:00Z",
  "requestId": "uuid-here"
}
```

**Error Response Format:**
```json
{
  "success": false,
  "error": {
    "code": "ERROR_CODE",
    "message": "Human-readable error message",
    "details": { }
  },
  "timestamp": "2025-11-20T10:30:00Z",
  "requestId": "uuid-here"
}
```

---

### 5.2 Authentication Endpoints

#### **POST /auth/register**
Register new user account

**Request:**
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "password": "SecurePass123!",
  "agreeToTerms": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Registration successful",
  "data": {
    "userId": "uuid-here",
    "email": "john.doe@example.com",
    "name": "John Doe",
    "createdAt": "2025-11-20T10:30:00Z"
  }
}
```

**Validation:**
- Name: 2-100 characters
- Email: Valid format, unique
- Password: Min 8 chars, complexity requirements
- AgreeToTerms: Must be true

**Error Codes:**
- `EMAIL_EXISTS`: Email already registered
- `INVALID_EMAIL`: Email format invalid
- `WEAK_PASSWORD`: Password doesn't meet requirements
- `TERMS_NOT_ACCEPTED`: Must agree to terms

---

#### **POST /auth/login**
Authenticate user and get access token

**Request:**
```json
{
  "email": "john.doe@example.com",
  "password": "SecurePass123!"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Login successful",
  "data": {
    "accessToken": "jwt-token-here",
    "refreshToken": "refresh-token-here",
    "expiresIn": 86400,
    "user": {
      "userId": "uuid-here",
      "name": "John Doe",
      "email": "john.doe@example.com",
      "avatar": "https://cdn.example.com/avatars/user.jpg"
    }
  }
}
```

**Error Codes:**
- `INVALID_CREDENTIALS`: Email or password incorrect
- `ACCOUNT_LOCKED`: Too many failed attempts
- `ACCOUNT_DISABLED`: Account has been disabled
- `EMAIL_NOT_VERIFIED`: Email verification required

---

#### **POST /auth/forgot-password**
Request password reset

**Request:**
```json
{
  "email": "john.doe@example.com"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password reset email sent",
  "data": {
    "email": "john.doe@example.com",
    "expiresIn": 3600
  }
}
```

**Note:** Always returns success even if email doesn't exist (security)

---

#### **POST /auth/reset-password**
Reset password with token

**Request:**
```json
{
  "token": "reset-token-here",
  "newPassword": "NewSecurePass123!"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Password reset successful"
}
```

**Error Codes:**
- `INVALID_TOKEN`: Token invalid or expired
- `WEAK_PASSWORD`: Password doesn't meet requirements

---

#### **POST /auth/refresh-token**
Refresh access token

**Request:**
```json
{
  "refreshToken": "refresh-token-here"
}
```

**Response:**
```json
{
  "success": true,
  "data": {
    "accessToken": "new-jwt-token",
    "expiresIn": 86400
  }
}
```

---

### 5.3 News Endpoints

#### **GET /news**
Get list of news articles

**Query Parameters:**
- `page`: Page number (default: 1)
- `limit`: Items per page (default: 20, max: 100)
- `category`: Filter by category ID
- `sort`: Sort order (newest, oldest, popular)

**Request:**
```
GET /news?page=1&limit=20&sort=newest
```

**Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "news-uuid-1",
        "title": "UNICEF launches new child protection initiative",
        "excerpt": "Brief summary of the article...",
        "content": "Full HTML content...",
        "image": "https://cdn.example.com/news/image1.jpg",
        "author": {
          "name": "UNICEF Communications",
          "avatar": "https://cdn.example.com/avatars/unicef.jpg"
        },
        "publishedAt": "2025-11-15T08:00:00Z",
        "category": "Announcements",
        "tags": ["child protection", "initiative"],
        "likeCount": 245,
        "isLikedByUser": false
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 98,
      "hasNext": true,
      "hasPrevious": false
    }
  }
}
```

---

#### **GET /news/{id}**
Get single news article details

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "news-uuid-1",
    "title": "UNICEF launches new child protection initiative",
    "content": "Full HTML content with images and formatting...",
    "image": "https://cdn.example.com/news/image1.jpg",
    "author": {
      "name": "UNICEF Communications",
      "avatar": "https://cdn.example.com/avatars/unicef.jpg"
    },
    "publishedAt": "2025-11-15T08:00:00Z",
    "updatedAt": "2025-11-16T10:30:00Z",
    "category": "Announcements",
    "tags": ["child protection", "initiative"],
    "likeCount": 245,
    "isLikedByUser": false,
    "relatedArticles": [
      {
        "id": "news-uuid-2",
        "title": "Related article title",
        "image": "https://cdn.example.com/news/image2.jpg"
      }
    ]
  }
}
```

---

#### **POST /news/{id}/like**
Like or unlike a news article

**Authentication:** Required

**Request:** (No body needed)

**Response:**
```json
{
  "success": true,
  "message": "Article liked successfully",
  "data": {
    "newsId": "news-uuid-1",
    "likeCount": 246,
    "isLikedByUser": true
  }
}
```

**Note:** Toggle behavior - if already liked, this will unlike

---

### 5.4 Event Reporting Endpoints

#### **POST /events**
Submit event/incident report

**Authentication:** Required

**Request:**
```json
{
  "title": "Witnessed child abuse incident",
  "description": "Detailed description of what happened...",
  "location": {
    "address": "123 Main Street, City",
    "latitude": 40.7128,
    "longitude": -74.0060
  },
  "dateTime": "2025-11-19T14:30:00Z",
  "category": "child_abuse",
  "severity": "high",
  "contactName": "John Doe",
  "contactPhone": "+1234567890",
  "witnesses": "Name of witnesses if any",
  "attachments": ["file-uuid-1", "file-uuid-2"]
}
```

**Response:**
```json
{
  "success": true,
  "message": "Report submitted successfully",
  "data": {
    "reportId": "report-uuid-123",
    "referenceNumber": "UNICEF-2025-001234",
    "status": "submitted",
    "submittedAt": "2025-11-20T10:30:00Z",
    "estimatedReviewTime": "48 hours"
  }
}
```

**Categories:**
- `child_abuse`: Physical or emotional abuse
- `neglect`: Child neglect
- `exploitation`: Child exploitation
- `trafficking`: Human trafficking
- `other`: Other child protection concerns

**Severity Levels:**
- `low`: Minor concern
- `medium`: Moderate concern
- `high`: Serious concern
- `critical`: Immediate danger

---

#### **POST /files/upload**
Upload file attachment

**Authentication:** Required

**Request:** Multipart form data
```
Content-Type: multipart/form-data

file: [binary file data]
purpose: event_attachment
```

**Response:**
```json
{
  "success": true,
  "data": {
    "fileId": "file-uuid-here",
    "fileName": "document.pdf",
    "fileSize": 1048576,
    "mimeType": "application/pdf",
    "url": "https://cdn.example.com/uploads/file-uuid-here.pdf",
    "expiresAt": "2025-12-20T10:30:00Z"
  }
}
```

**Supported File Types:**
- Images: JPEG, PNG, GIF (max 10MB)
- Documents: PDF (max 10MB)
- Videos: MP4, MOV (max 50MB)

**Error Codes:**
- `FILE_TOO_LARGE`: File exceeds size limit
- `INVALID_FILE_TYPE`: File type not allowed
- `UPLOAD_FAILED`: Server error during upload

---

### 5.5 Educational Content Endpoints

#### **GET /content/categories**
Get all content categories

**Response:**
```json
{
  "success": true,
  "data": [
    {
      "id": 1,
      "name": "Survival & Development",
      "slug": "survival",
      "description": "Content about child survival and development",
      "icon": "https://cdn.example.com/icons/survival.svg",
      "hasSubcategories": true,
      "subcategories": [
        {
          "id": 11,
          "name": "Maternal and Child Health",
          "slug": "maternal-child-health",
          "icon": "https://cdn.example.com/icons/mch.svg"
        },
        {
          "id": 12,
          "name": "Nutrition",
          "slug": "nutrition",
          "icon": "https://cdn.example.com/icons/nutrition.svg"
        }
      ]
    },
    {
      "id": 2,
      "name": "Respect for Child Views",
      "slug": "respect-child-views",
      "description": "Content about respecting children's opinions",
      "icon": "https://cdn.example.com/icons/respect.svg",
      "hasSubcategories": false
    }
  ]
}
```

---

#### **GET /content**
Get content by category or subcategory

**Query Parameters:**
- `categoryId`: Category ID (required)
- `subcategoryId`: Subcategory ID (optional)
- `page`: Page number
- `limit`: Items per page

**Request:**
```
GET /content?categoryId=1&subcategoryId=11&page=1&limit=10
```

**Response:**
```json
{
  "success": true,
  "data": {
    "category": {
      "id": 1,
      "name": "Survival & Development"
    },
    "subcategory": {
      "id": 11,
      "name": "Maternal and Child Health"
    },
    "items": [
      {
        "id": "content-uuid-1",
        "title": "Prenatal Care Essentials",
        "excerpt": "Essential information about prenatal care...",
        "content": "Full HTML content...",
        "image": "https://cdn.example.com/content/prenatal.jpg",
        "publishedAt": "2025-10-01T00:00:00Z",
        "readTime": 5,
        "downloads": {
          "pdf": "https://cdn.example.com/pdfs/prenatal-care.pdf"
        }
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 3,
      "totalItems": 28
    }
  }
}
```

---

#### **GET /content/{id}**
Get single content item details

**Response:**
```json
{
  "success": true,
  "data": {
    "id": "content-uuid-1",
    "title": "Prenatal Care Essentials",
    "content": "Full HTML content with rich formatting...",
    "image": "https://cdn.example.com/content/prenatal.jpg",
    "category": {
      "id": 1,
      "name": "Survival & Development"
    },
    "subcategory": {
      "id": 11,
      "name": "Maternal and Child Health"
    },
    "author": "UNICEF Health Team",
    "publishedAt": "2025-10-01T00:00:00Z",
    "updatedAt": "2025-11-01T00:00:00Z",
    "readTime": 5,
    "tags": ["prenatal", "health", "pregnancy"],
    "downloads": {
      "pdf": "https://cdn.example.com/pdfs/prenatal-care.pdf",
      "epub": "https://cdn.example.com/epub/prenatal-care.epub"
    },
    "relatedContent": [
      {
        "id": "content-uuid-2",
        "title": "Nutrition During Pregnancy",
        "image": "https://cdn.example.com/content/nutrition.jpg"
      }
    ]
  }
}
```

---

### 5.6 Feedback Endpoints

#### **GET /feedback**
Get feedback list (admin/public view)

**Query Parameters:**
- `page`: Page number
- `limit`: Items per page
- `status`: Filter by status (pending, approved, rejected)

**Response:**
```json
{
  "success": true,
  "data": {
    "items": [
      {
        "id": "feedback-uuid-1",
        "category": "suggestion",
        "subject": "Improve app navigation",
        "message": "It would be great if...",
        "submittedBy": "Anonymous",
        "submittedAt": "2025-11-18T15:30:00Z",
        "status": "approved"
      }
    ],
    "pagination": {
      "currentPage": 1,
      "totalPages": 5,
      "totalItems": 92
    }
  }
}
```

---

#### **POST /feedback**
Submit new feedback

**Request:**
```json
{
  "category": "suggestion",
  "subject": "Improve app navigation",
  "message": "It would be great if the app had better navigation between sections...",
  "email": "user@example.com",
  "allowContact": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Feedback submitted successfully",
  "data": {
    "feedbackId": "feedback-uuid-123",
    "status": "pending",
    "submittedAt": "2025-11-20T10:30:00Z"
  }
}
```

**Categories:**
- `app_issue`: Technical problem with app
- `suggestion`: Feature suggestion
- `complaint`: Complaint about service
- `appreciation`: Positive feedback
- `other`: Other feedback

---

### 5.7 Subscription Endpoints

#### **POST /subscriptions**
Subscribe to email list

**Request:**
```json
{
  "email": "user@example.com",
  "preferences": {
    "news": true,
    "events": true,
    "educational": false,
    "newsletter": true
  },
  "agreeToPrivacyPolicy": true
}
```

**Response:**
```json
{
  "success": true,
  "message": "Subscription successful. Please check your email to confirm.",
  "data": {
    "subscriptionId": "sub-uuid-123",
    "email": "user@example.com",
    "status": "pending_confirmation",
    "confirmationSentAt": "2025-11-20T10:30:00Z"
  }
}
```

---

#### **POST /subscriptions/confirm**
Confirm email subscription

**Request:**
```json
{
  "token": "confirmation-token-here"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Email confirmed. You are now subscribed!",
  "data": {
    "subscriptionId": "sub-uuid-123",
    "status": "active",
    "confirmedAt": "2025-11-20T11:00:00Z"
  }
}
```

---

#### **DELETE /subscriptions/{id}**
Unsubscribe from email list

**Request:**
```
DELETE /subscriptions/{subscriptionId}?token={unsubscribe-token}
```

**Response:**
```json
{
  "success": true,
  "message": "You have been unsubscribed successfully"
}
```

---

### 5.8 Contact Endpoints

#### **POST /contact**
Submit contact form

**Request:**
```json
{
  "name": "John Doe",
  "email": "john.doe@example.com",
  "subject": "general_inquiry",
  "message": "I would like to know more about...",
  "attachment": "file-uuid-here"
}
```

**Response:**
```json
{
  "success": true,
  "message": "Message sent successfully. We will respond within 48 hours.",
  "data": {
    "contactId": "contact-uuid-123",
    "referenceNumber": "CONTACT-2025-001234",
    "submittedAt": "2025-11-20T10:30:00Z",
    "estimatedResponseTime": "48 hours"
  }
}
```

**Subject Options:**
- `general_inquiry`: General question
- `support_request`: Technical support
- `partnership`: Partnership inquiry
- `media`: Media inquiry
- `other`: Other

---

## 6. Data Models

### 6.1 User Model

```typescript
interface User {
  id: string;                    // UUID
  email: string;                 // Unique, RFC 5322 format
  name: string;                  // 2-100 characters
  password: string;              // Hashed (bcrypt), never returned in API
  avatar?: string;               // URL to profile picture
  phone?: string;                // E.164 format
  role: 'user' | 'admin' | 'moderator';
  status: 'active' | 'inactive' | 'suspended';
  emailVerified: boolean;
  emailVerifiedAt?: Date;
  lastLoginAt?: Date;
  createdAt: Date;
  updatedAt: Date;
  preferences?: UserPreferences;
}

interface UserPreferences {
  language: string;              // ISO 639-1 code (e.g., 'en', 'es')
  notifications: {
    email: boolean;
    push: boolean;
  };
  theme: 'light' | 'dark' | 'auto';
}
```

---

### 6.2 News Model

```typescript
interface News {
  id: string;                    // UUID
  title: string;                 // 5-200 characters
  excerpt: string;               // Brief summary, max 500 chars
  content: string;               // Full HTML content
  image: string;                 // URL to hero image
  author: {
    name: string;
    avatar?: string;
  };
  category: string;              // e.g., 'Announcements', 'Events'
  tags: string[];                // Array of tag strings
  publishedAt: Date;
  updatedAt?: Date;
  status: 'draft' | 'published' | 'archived';
  likeCount: number;             // Computed field
  viewCount: number;             // Analytics
  relatedArticles?: News[];      // Related content
}

interface NewsLike {
  id: string;
  newsId: string;                // FK to News
  userId: string;                // FK to User
  createdAt: Date;
}
```

---

### 6.3 Event Report Model

```typescript
interface EventReport {
  id: string;                    // UUID
  referenceNumber: string;       // Human-readable (UNICEF-2025-001234)
  userId: string;                // FK to User (reporter)

  // Event details
  title: string;                 // 10-100 characters
  description: string;           // 20-1000 characters
  category: EventCategory;
  severity: EventSeverity;

  // Location
  location: {
    address: string;
    city?: string;
    country?: string;
    latitude?: number;
    longitude?: number;
  };

  // Timing
  eventDateTime: Date;           // When incident occurred
  reportedAt: Date;              // When report was submitted

  // Contact
  contactName: string;
  contactPhone: string;          // E.164 format
  contactEmail?: string;

  // Additional info
  witnesses?: string;
  attachments: Attachment[];     // Files uploaded

  // Status tracking
  status: 'submitted' | 'under_review' | 'investigating' | 'resolved' | 'closed';
  assignedTo?: string;           // Admin user ID
  notes?: string;                // Internal notes (admin only)

  // Timestamps
  createdAt: Date;
  updatedAt: Date;
  reviewedAt?: Date;
  resolvedAt?: Date;
}

type EventCategory =
  | 'child_abuse'
  | 'neglect'
  | 'exploitation'
  | 'trafficking'
  | 'other';

type EventSeverity = 'low' | 'medium' | 'high' | 'critical';

interface Attachment {
  id: string;
  fileId: string;                // FK to File
  fileName: string;
  fileSize: number;              // Bytes
  mimeType: string;
  url: string;
  uploadedAt: Date;
}
```

---

### 6.4 Educational Content Model

```typescript
interface ContentCategory {
  id: number;
  name: string;
  slug: string;                  // URL-friendly name
  description: string;
  icon: string;                  // URL to icon image
  order: number;                 // Display order
  hasSubcategories: boolean;
  subcategories?: ContentSubcategory[];
  parentId?: number;             // For nested categories
}

interface ContentSubcategory {
  id: number;
  categoryId: number;            // FK to ContentCategory
  name: string;
  slug: string;
  icon: string;
  order: number;
}

interface Content {
  id: string;                    // UUID
  title: string;                 // 5-200 characters
  excerpt: string;               // Brief summary
  content: string;               // Full HTML content
  image: string;                 // Hero image URL

  // Categorization
  categoryId: number;            // FK to ContentCategory
  subcategoryId?: number;        // FK to ContentSubcategory
  tags: string[];

  // Metadata
  author: string;
  publishedAt: Date;
  updatedAt?: Date;
  status: 'draft' | 'published' | 'archived';

  // Reading info
  readTime: number;              // Minutes
  viewCount: number;

  // Downloads
  downloads?: {
    pdf?: string;                // URL to PDF version
    epub?: string;               // URL to ePub version
  };

  // Relations
  relatedContent?: Content[];
}
```

---

### 6.5 Feedback Model

```typescript
interface Feedback {
  id: string;                    // UUID
  userId?: string;               // FK to User (optional for anonymous)

  category: FeedbackCategory;
  subject: string;               // Max 100 characters
  message: string;               // Max 500 characters
  email?: string;                // Contact email (if anonymous)
  allowContact: boolean;

  status: 'pending' | 'approved' | 'rejected' | 'archived';
  moderatedBy?: string;          // Admin user ID
  moderatedAt?: Date;
  moderatorNotes?: string;

  submittedAt: Date;
  updatedAt?: Date;
}

type FeedbackCategory =
  | 'app_issue'
  | 'suggestion'
  | 'complaint'
  | 'appreciation'
  | 'other';
```

---

### 6.6 Subscription Model

```typescript
interface EmailSubscription {
  id: string;                    // UUID
  email: string;                 // Unique

  preferences: {
    news: boolean;
    events: boolean;
    educational: boolean;
    newsletter: boolean;
  };

  status: 'pending_confirmation' | 'active' | 'unsubscribed';

  confirmationToken?: string;    // For double opt-in
  confirmationSentAt?: Date;
  confirmedAt?: Date;

  unsubscribeToken: string;      // For easy unsubscribe
  unsubscribedAt?: Date;

  subscribedAt: Date;
  updatedAt: Date;

  // Analytics
  emailsSent: number;
  emailsOpened: number;
  lastEmailSentAt?: Date;
}
```

---

### 6.7 Contact Submission Model

```typescript
interface ContactSubmission {
  id: string;                    // UUID
  referenceNumber: string;       // CONTACT-2025-001234

  userId?: string;               // FK to User (if logged in)
  name: string;
  email: string;
  subject: ContactSubject;
  message: string;               // Max 1000 characters
  attachment?: string;           // File UUID

  status: 'new' | 'in_progress' | 'responded' | 'closed';
  assignedTo?: string;           // Admin user ID
  response?: string;             // Admin response text

  submittedAt: Date;
  respondedAt?: Date;
  closedAt?: Date;
}

type ContactSubject =
  | 'general_inquiry'
  | 'support_request'
  | 'partnership'
  | 'media'
  | 'other';
```

---

## 7. Business Rules

### 7.1 Authentication Rules

1. **Password Requirements:**
   - Minimum 8 characters
   - At least 1 uppercase letter
   - At least 1 lowercase letter
   - At least 1 number
   - At least 1 special character (!@#$%^&*)
   - Cannot contain user's name or email
   - Cannot be common password (check against list)

2. **Account Lockout:**
   - Lock account after 5 failed login attempts
   - Lockout duration: 15 minutes
   - Send email notification on lockout
   - Admin can manually unlock

3. **Session Management:**
   - Access token valid for 24 hours
   - Refresh token valid for 30 days
   - Force logout on password change
   - Only 1 active session per device (or allow multiple with device tracking)

4. **Email Verification:**
   - Required for certain features (optional for basic browsing)
   - Verification link valid for 24 hours
   - Resend verification email (max 3 times per hour)

---

### 7.2 Content Moderation Rules

1. **News Articles:**
   - All news must be approved by admin before publishing
   - Can schedule publish date
   - Draft saved automatically every 30 seconds
   - Cannot delete articles with likes/comments (archive instead)

2. **Event Reports:**
   - All reports reviewed within 48 hours
   - Critical severity reports flagged for immediate review
   - Reports with attachments scanned for malware
   - Reporter notified of status changes via email

3. **Feedback:**
   - Pending status by default
   - Approved feedback shown publicly
   - Rejected feedback not shown
   - Moderation decision within 7 days

---

### 7.3 File Upload Rules

1. **Image Files:**
   - Formats: JPEG, PNG, GIF, WebP
   - Max size: 10MB
   - Auto-compress if >2MB
   - Generate thumbnails: 150x150, 400x400, 800x800
   - Strip EXIF data for privacy

2. **Video Files:**
   - Formats: MP4, MOV, AVI
   - Max size: 50MB
   - Max duration: 5 minutes
   - Auto-generate thumbnail from first frame

3. **Document Files:**
   - Formats: PDF only
   - Max size: 10MB
   - Scan for malware
   - No password-protected PDFs

4. **General Rules:**
   - Virus scan all uploads
   - Generate unique filename (prevent overwrite)
   - Store in CDN for performance
   - Set expiry for temporary files (event attachments: 90 days)

---

### 7.4 Like/Engagement Rules

1. **News Likes:**
   - User can like each article only once
   - Like count updated in real-time
   - Unlike removes 1 from count
   - Logged-in users only
   - Track user who liked (for analytics)

2. **Rate Limiting:**
   - Max 100 likes per user per hour
   - Prevents spam/abuse

---

### 7.5 Email Subscription Rules

1. **Double Opt-in:**
   - Confirmation email required
   - Subscription not active until confirmed
   - Confirmation link valid for 7 days
   - Can resend confirmation (max 3 times)

2. **Unsubscribe:**
   - One-click unsubscribe from emails
   - No login required
   - Process immediately
   - Send confirmation email

3. **Email Preferences:**
   - Can update preferences anytime
   - At least 1 preference must be selected
   - Changes take effect immediately

4. **Frequency:**
   - News updates: As published (max 1 per day digest)
   - Events: When relevant events posted
   - Educational: Weekly digest
   - Newsletter: Monthly

---

### 7.6 Reporting Rules

1. **Event Reports:**
   - Authenticated users only
   - Cannot edit after submission
   - Can add comments/updates to own reports
   - Admin can request additional information
   - Duplicate reports merged by admin

2. **Sensitive Information:**
   - No personal identifiers in public fields
   - Child's name redacted in descriptions
   - Location generalized (city level, not exact address)
   - Contact info only visible to admins

---

### 7.7 Data Retention Rules

1. **User Accounts:**
   - Active: Retained indefinitely
   - Inactive (no login 2+ years): Email reminder, then delete after 30 days
   - Deleted: 30-day soft delete (can recover), then permanent

2. **Event Reports:**
   - Active cases: Retained indefinitely
   - Closed cases: Retained for 7 years (legal requirement)
   - Attachments: Deleted after case closed + 90 days

3. **Logs:**
   - Access logs: 90 days
   - Error logs: 180 days
   - Audit logs: 7 years

4. **Analytics:**
   - Aggregated data: Indefinitely
   - User-level data: Anonymized after 1 year

---

## 8. UI/UX Specifications

### 8.1 Design System

#### **8.1.1 Color Palette**

**Primary Colors:**
```
UNICEF Blue:     #1CA7EC (primary brand color)
Dark Blue:       #034156 (footer, dark accents)
Bright Cyan:     #23D2FD (active states, highlights)
```

**Text Colors:**
```
Heading:         #1B1D21 (dark grey/black)
Body:            #6D6D6D (medium grey)
Light Text:      #9E9E9E (hints, placeholders)
White:           #FFFFFF
```

**Semantic Colors:**
```
Success:         #00C851 (green)
Warning:         #FFBB33 (amber)
Error:           #F04141 (red)
Info:            #33B5E5 (light blue)
```

**Background Colors:**
```
App Background:  #F5F5F5 (light grey)
Card Background: #FFFFFF (white)
Input Background:#EFEFEF (very light grey)
Disabled:        #E0E0E0 (grey)
```

---

#### **8.1.2 Typography**

**Font Families:**
- **Headings/Titles:** Poppins (Regular, Medium, SemiBold)
- **Body Text:** Nunito Sans (Regular, SemiBold)
- **Monospace:** Roboto Mono (for codes, references)

**Font Sizes:**
```
Display Large:   32px / 2rem      (Page titles)
Display:         28px / 1.75rem   (Section headers)
Heading 1:       24px / 1.5rem    (Card titles)
Heading 2:       20px / 1.25rem   (Subheadings)
Body Large:      16px / 1rem      (Primary text)
Body:            14px / 0.875rem  (Default body)
Caption:         12px / 0.75rem   (Meta info, labels)
Tiny:            10px / 0.625rem  (Fine print)
```

**Line Heights:**
```
Tight:           1.2 (headings)
Normal:          1.5 (body text)
Relaxed:         1.8 (long-form content)
```

**Font Weights:**
```
Light:           300
Regular:         400
Medium:          500
SemiBold:        600
Bold:            700
```

---

#### **8.1.3 Spacing System**

**Base Unit:** 4px

**Spacing Scale:**
```
xxxs:  4px   (0.25rem)
xxs:   8px   (0.5rem)
xs:    12px  (0.75rem)
sm:    16px  (1rem)
md:    24px  (1.5rem)
lg:    32px  (2rem)
xl:    48px  (3rem)
xxl:   64px  (4rem)
xxxl:  96px  (6rem)
```

**Usage:**
- Container padding: 16px (sm)
- Card padding: 16px (sm)
- Section margins: 24px (md)
- Component gaps: 8px (xxs) - 16px (sm)

---

#### **8.1.4 Iconography**

**Icon Library:** Ionicons (Ionic's default)

**Icon Sizes:**
```
Small:   16px
Medium:  24px (default)
Large:   32px
XLarge:  48px
```

**Common Icons:**
- Home: `home-outline`
- News: `newspaper-outline`
- Event: `calendar-outline`
- Feedback: `chatbox-outline`
- Education: `book-outline`
- Subscribe: `mail-outline`
- Contact: `call-outline`
- Login: `log-in-outline`
- Logout: `log-out-outline`
- Like: `heart` (filled) / `heart-outline` (unfilled)
- Upload: `cloud-upload-outline`
- Camera: `camera-outline`
- Search: `search-outline`
- Menu: `menu-outline`
- Close: `close-outline`
- Settings: `settings-outline`

---

### 8.2 Component Specifications

#### **8.2.1 Buttons**

**Primary Button:**
```
Background:      #1CA7EC (UNICEF Blue)
Text:            #FFFFFF (white)
Font:            Nunito Sans, 16px, SemiBold
Height:          48px
Border Radius:   8px
Padding:         12px 24px
Shadow:          0 2px 4px rgba(0,0,0,0.1)

States:
- Hover:         Background #1896D3
- Active:        Background #1585C0
- Disabled:      Background #E0E0E0, Text #9E9E9E
- Loading:       Show spinner, disable interaction
```

**Secondary Button:**
```
Background:      #FFFFFF (white)
Text:            #1CA7EC (UNICEF Blue)
Border:          2px solid #1CA7EC
Font:            Nunito Sans, 16px, SemiBold
Height:          48px
Border Radius:   8px
Padding:         12px 24px

States:
- Hover:         Background #F0F9FD
- Active:        Background #E0F3FA
- Disabled:      Border #E0E0E0, Text #9E9E9E
```

**Text Button:**
```
Background:      Transparent
Text:            #1CA7EC
Font:            Nunito Sans, 16px, SemiBold
Padding:         8px 16px

States:
- Hover:         Text #1896D3, Underline
- Active:        Text #1585C0
- Disabled:      Text #9E9E9E
```

**Icon Button:**
```
Size:            44px x 44px (touch target)
Icon Size:       24px
Border Radius:   50% (circle)

States:
- Hover:         Background #F5F5F5
- Active:        Background #ECECEC
```

---

#### **8.2.2 Form Inputs**

**Text Input:**
```
Height:          48px
Border:          1px solid #23D2FD (bright cyan)
Border Radius:   3px
Background:      #EFEFEF (light grey)
Padding:         12px 16px
Font:            Nunito Sans, 16px, Regular
Text Color:      #1B1D21

States:
- Focus:         Border 2px solid #1CA7EC, Background #FFFFFF
- Error:         Border 2px solid #F04141
- Disabled:      Background #E0E0E0, Text #9E9E9E
- Read-only:     Background #F5F5F5, no border

Label:
- Font:          Nunito Sans, 14px, Medium
- Color:         #1B1D21
- Margin Bottom: 8px

Placeholder:
- Color:         #9E9E9E
- Font Style:    Italic
```

**Textarea:**
```
Min Height:      120px
Border:          1px solid #24A899 (teal - as per current)
Border Radius:   3px
Background:      #EFEFEF
Padding:         12px 16px
Font:            Nunito Sans, 16px, Regular
Resize:          Vertical

Note: Standardize border color to match text inputs (#23D2FD)
```

**Select/Dropdown:**
```
Height:          48px
Border:          1px solid #23D2FD
Border Radius:   3px
Background:      #EFEFEF
Padding:         12px 16px 12px 16px
Icon:            Chevron-down (right side)

States:
- Focus:         Border 2px solid #1CA7EC
- Open:          Show options list below
```

**Checkbox:**
```
Size:            24px x 24px
Border:          2px solid #1CA7EC
Border Radius:   4px
Background:      #FFFFFF

Checked:
- Background:    #1CA7EC
- Icon:          White checkmark

Label:
- Font:          Nunito Sans, 16px, Regular
- Margin Left:   12px
```

**Radio Button:**
```
Size:            24px x 24px (outer circle)
Border:          2px solid #1CA7EC
Border Radius:   50%
Background:      #FFFFFF

Selected:
- Inner Circle:  12px, #1CA7EC

Label:
- Font:          Nunito Sans, 16px, Regular
- Margin Left:   12px
```

**Toggle Switch:**
```
Track Width:     48px
Track Height:    24px
Border Radius:   12px (pill shape)
Background:      #E0E0E0 (off), #1CA7EC (on)

Thumb:
- Size:          20px
- Background:    #FFFFFF
- Shadow:        0 2px 4px rgba(0,0,0,0.2)
- Position:      Left (off), Right (on)
```

---

#### **8.2.3 Cards**

**News Card:**
```
Background:      #FFFFFF
Border Radius:   12px
Shadow:          0 2px 8px rgba(0,0,0,0.08)
Padding:         0 (image full width), 16px (content)

Layout:
- Image:         16:9 aspect ratio, top
- Title:         Poppins, 18px, Medium, max 2 lines, ellipsis
- Date:          Nunito Sans, 12px, #6D6D6D
- Like Section:  Heart icon + count, 14px

Hover:
- Shadow:        0 4px 12px rgba(0,0,0,0.12)
- Transform:     translateY(-2px)
```

**Content Card:**
```
Background:      #FFFFFF
Border Radius:   12px
Shadow:          0 2px 8px rgba(0,0,0,0.08)
Padding:         16px

Layout:
- Icon:          48px, top-left or centered
- Title:         Poppins, 20px, Medium
- Description:   Nunito Sans, 14px, #6D6D6D
- Action:        Link or button at bottom

Hover:
- Border:        2px solid #1CA7EC
```

---

#### **8.2.4 Lists**

**List Item:**
```
Height:          Auto (min 64px)
Padding:         12px 16px
Border Bottom:   1px solid #F0F0F0
Background:      #FFFFFF

Layout:
- Avatar/Icon:   40px, left
- Text:
  - Primary:     Nunito Sans, 16px, Medium, #1B1D21
  - Secondary:   Nunito Sans, 14px, Regular, #6D6D6D
- Action:        Icon or button, right

States:
- Hover:         Background #F5F5F5
- Active:        Background #ECECEC
```

---

#### **8.2.5 Modals/Dialogs**

**Modal Container:**
```
Width:           90% (max 600px on tablet/desktop)
Height:          Auto (max 80vh)
Background:      #FFFFFF
Border Radius:   16px (top corners on mobile), 12px (desktop)
Shadow:          0 8px 32px rgba(0,0,0,0.2)
Padding:         24px

Backdrop:
- Background:    rgba(0,0,0,0.5)
- Blur:          4px (optional, performance consideration)

Header:
- Title:         Poppins, 24px, Medium
- Close Button:  Icon button (top-right)
- Border Bottom: 1px solid #F0F0F0

Content:
- Padding:       24px 0
- Max Height:    calc(80vh - 160px)
- Overflow:      Scroll (if needed)

Footer:
- Padding Top:   16px
- Border Top:    1px solid #F0F0F0
- Buttons:       Right-aligned, 8px gap
```

---

#### **8.2.6 Navigation**

**Side Menu (Drawer):**
```
Width:           280px (mobile), 320px (tablet+)
Background:      #FFFFFF
Shadow:          2px 0 8px rgba(0,0,0,0.1)
Padding:         0

Header:
- Height:        200px
- Background:    Gradient (#1CA7EC to #034156)
- Logo:          Centered, 80px height
- App Title:     White text, Poppins, 24px

Menu Items:
- Height:        56px
- Padding:       12px 24px
- Icon:          24px, left, #6D6D6D
- Text:          Nunito Sans, 16px, #1B1D21
- Gap:           12px

States:
- Hover:         Background #F5F5F5
- Active:        Background #E0F3FA, Blue left border 4px, Blue text
```

**Top Toolbar:**
```
Height:          56px
Background:      #1CA7EC (UNICEF Blue)
Padding:         0 16px
Shadow:          0 2px 4px rgba(0,0,0,0.1)

Layout:
- Menu Button:   Left, 44px touch target
- Title:         Center, Poppins, 20px, Medium, White
- Actions:       Right, icon buttons, 44px each
```

**Bottom Navigation (Mobile Alternative):**
```
Height:          64px
Background:      #FFFFFF
Border Top:      1px solid #F0F0F0
Shadow:          0 -2px 4px rgba(0,0,0,0.05)
Padding:         8px 0

Items:
- Width:         Equal distribution
- Icon:          24px, centered
- Label:         10px, centered below icon
- Gap:           4px

States:
- Active:        Blue icon + text (#1CA7EC)
- Inactive:      Grey icon + text (#6D6D6D)
```

---

#### **8.2.7 Feedback Components**

**Toast Notification:**
```
Width:           90% (max 400px)
Height:          Auto (min 56px)
Background:      #1B1D21 (dark)
Border Radius:   8px
Padding:         12px 16px
Position:        Bottom-center (mobile), Top-right (desktop)
Shadow:          0 4px 12px rgba(0,0,0,0.3)
Animation:       Slide up, fade in

Text:
- Font:          Nunito Sans, 14px, Regular
- Color:         #FFFFFF

Duration:        3 seconds (default), 5s (info), until dismissed (error)

Variants:
- Success:       Left border 4px green, success icon
- Error:         Left border 4px red, error icon
- Info:          Left border 4px blue, info icon
- Warning:       Left border 4px amber, warning icon
```

**Alert Dialog:**
```
Width:           90% (max 400px)
Background:      #FFFFFF
Border Radius:   12px
Padding:         24px
Shadow:          0 8px 24px rgba(0,0,0,0.2)

Title:
- Font:          Poppins, 20px, Medium
- Color:         #1B1D21

Message:
- Font:          Nunito Sans, 16px, Regular
- Color:         #6D6D6D
- Margin:        16px 0

Buttons:
- Layout:        Horizontal (2 buttons), Vertical (3+ buttons)
- Gap:           8px
- Primary:       Blue button
- Secondary:     Text button
```

**Loading Spinner:**
```
Size:            40px (default), 24px (inline)
Color:           #1CA7EC
Animation:       Circular rotation, 1s duration

Overlay:
- Background:    rgba(255,255,255,0.9)
- Blur:          2px
- Z-index:       1000
```

**Progress Bar:**
```
Height:          4px
Background:      #E0E0E0
Border Radius:   2px

Progress:
- Background:    #1CA7EC
- Animation:     Smooth width transition
```

**Skeleton Loader:**
```
Background:      Linear gradient (#E0E0E0 to #F5F5F5)
Border Radius:   4px
Animation:       Shimmer effect, 1.5s duration

Shapes:
- Text Line:     Height 16px, Width 100%
- Circle:        Avatar sizes
- Rectangle:     Card/image shapes
```

---

#### **8.2.8 Empty States**

**Layout:**
```
Alignment:       Center (vertical & horizontal)
Padding:         48px 24px

Icon:
- Size:          96px
- Color:         #E0E0E0 (light grey)
- Style:         Outline

Title:
- Font:          Poppins, 20px, Medium
- Color:         #1B1D21
- Margin Top:    24px

Description:
- Font:          Nunito Sans, 16px, Regular
- Color:         #6D6D6D
- Margin Top:    8px
- Max Width:     400px
- Text Align:    Center

Action Button:
- Margin Top:    24px
- Type:          Primary or Secondary
```

---

### 8.3 Responsive Breakpoints

**Breakpoint System:**
```
Mobile:          0 - 576px
Tablet:          577px - 992px
Desktop:         993px - 1200px
Large Desktop:   1201px+
```

**Layout Adaptations:**

**Mobile (< 576px):**
- Side menu: Full overlay drawer
- Content: 16px padding
- Grid: 1 column
- Font sizes: Base sizes
- Bottom navigation: Visible (alternative to side menu)

**Tablet (577px - 992px):**
- Side menu: Dismissible drawer
- Content: 24px padding
- Grid: 2 columns
- Font sizes: Base sizes
- Split pane: Menu 280px, content fills remaining

**Desktop (993px+):**
- Side menu: Always visible (split-pane)
- Content: 32px padding (max 1200px container)
- Grid: 3-4 columns
- Font sizes: +2px (optional scaling)
- Split pane: Menu 320px, content fills remaining

---

### 8.4 Accessibility Guidelines

1. **Color Contrast:**
   - Text on background: Minimum 4.5:1 ratio (WCAG AA)
   - Large text (18px+): Minimum 3:1 ratio
   - Icons: Minimum 3:1 ratio

2. **Touch Targets:**
   - Minimum size: 44px x 44px
   - Spacing between targets: 8px minimum

3. **Focus Indicators:**
   - Visible outline: 2px solid #1CA7EC
   - Offset: 2px from element
   - Never remove focus outline (`:focus-visible` ok)

4. **Screen Reader Support:**
   - All images: Descriptive alt text
   - Form inputs: Associated labels
   - Buttons: Descriptive text or aria-label
   - Navigation: Semantic HTML (nav, main, footer)
   - Headings: Proper hierarchy (h1, h2, h3)

5. **Keyboard Navigation:**
   - Tab order: Logical flow
   - All interactive elements: Keyboard accessible
   - Modal dialogs: Focus trap, Esc to close
   - Dropdown menus: Arrow keys to navigate

6. **Motion:**
   - Respect `prefers-reduced-motion`
   - Provide alternative to animations
   - No auto-play videos with sound

---

### 8.5 Animation Specifications

**Transition Timings:**
```
Fast:            150ms (hover states, simple transitions)
Medium:          300ms (modal open/close, page transitions)
Slow:            500ms (complex animations)
```

**Easing Functions:**
```
Standard:        cubic-bezier(0.4, 0, 0.2, 1)
Decelerate:      cubic-bezier(0, 0, 0.2, 1) (enter animations)
Accelerate:      cubic-bezier(0.4, 0, 1, 1) (exit animations)
Sharp:           cubic-bezier(0.4, 0, 0.6, 1) (attention-grabbing)
```

**Common Animations:**

**Fade In:**
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}
/* Duration: 300ms, Easing: standard */
```

**Slide Up:**
```css
@keyframes slideUp {
  from {
    transform: translateY(20px);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}
/* Duration: 300ms, Easing: decelerate */
```

**Scale In:**
```css
@keyframes scaleIn {
  from {
    transform: scale(0.9);
    opacity: 0;
  }
  to {
    transform: scale(1);
    opacity: 1;
  }
}
/* Duration: 200ms, Easing: decelerate */
```

---

## 9. Security Requirements

### 9.1 Data Security

1. **Encryption in Transit:**
   - All API communication: HTTPS/TLS 1.3
   - Certificate pinning for mobile apps
   - No HTTP fallback allowed

2. **Encryption at Rest:**
   - Sensitive data encrypted: Passwords (bcrypt), tokens (AES-256)
   - File storage: Server-side encryption (S3, Azure Blob)
   - Database: Encryption at rest enabled
   - Mobile: Keychain (iOS), Keystore (Android) for tokens

3. **Data Minimization:**
   - Collect only necessary data
   - Don't store sensitive data unnecessarily
   - Anonymize analytics data

---

### 9.2 Authentication Security

1. **Password Security:**
   - Hash with bcrypt (cost factor: 12)
   - Salted hashing
   - Never transmit plain passwords
   - Never log passwords

2. **Token Security:**
   - JWT with RS256 signing
   - Short-lived access tokens (24h)
   - Refresh tokens (30 days, revocable)
   - Include token expiry
   - Validate signature on every request

3. **Session Security:**
   - Secure session storage (not localStorage for sensitive data)
   - Regenerate session ID on login
   - Implement CSRF tokens for state-changing operations
   - Logout invalidates all tokens

---

### 9.3 API Security

1. **Rate Limiting:**
   - Login: 5 attempts per 15 minutes per IP
   - Registration: 3 per hour per IP
   - File upload: 10 per hour per user
   - API calls: 100 per minute per user
   - Public endpoints: 20 per minute per IP

2. **Input Validation:**
   - Validate all inputs server-side
   - Sanitize HTML content
   - Check file types and sizes
   - Reject malformed requests

3. **Authorization:**
   - Verify user permissions for every request
   - Implement role-based access control (RBAC)
   - Check resource ownership

4. **OWASP Top 10 Protection:**
   - SQL Injection: Use parameterized queries
   - XSS: Sanitize outputs, CSP headers
   - CSRF: Token validation
   - Insecure Deserialization: Validate JSON
   - Security Misconfiguration: Harden servers
   - Sensitive Data Exposure: Encrypt sensitive fields
   - Broken Access Control: Verify permissions
   - XXE: Disable external entity processing
   - Using Components with Known Vulnerabilities: Keep dependencies updated
   - Insufficient Logging: Log security events

---

### 9.4 Mobile App Security

1. **Code Obfuscation:**
   - Minify JavaScript
   - Obfuscate critical logic
   - Remove console logs in production

2. **Root/Jailbreak Detection:**
   - Detect rooted/jailbroken devices
   - Warn user or restrict features

3. **Secure Storage:**
   - Use iOS Keychain for sensitive data
   - Use Android Keystore for sensitive data
   - Never store secrets in shared preferences

4. **Certificate Pinning:**
   - Pin API certificate
   - Prevent MITM attacks

---

### 9.5 Content Security

1. **File Upload Security:**
   - Virus/malware scanning
   - File type validation (whitelist)
   - File size limits
   - Rename files (prevent overwrite)
   - Store outside web root

2. **HTML Sanitization:**
   - Use DOMPurify or similar library
   - Whitelist allowed tags
   - Remove JavaScript
   - Remove dangerous attributes (onclick, onerror)

3. **Image Security:**
   - Strip EXIF data (prevent location leaks)
   - Validate image format
   - Re-encode images

---

### 9.6 Privacy Requirements

1. **GDPR Compliance (if applicable):**
   - Obtain consent for data collection
   - Provide data export (download user data)
   - Provide data deletion (right to be forgotten)
   - Privacy policy: Clear, accessible
   - Data processing agreement with third parties

2. **COPPA Compliance (for children):**
   - Parental consent for users under 13
   - Limited data collection for children
   - No behavioral advertising to children

3. **Data Sharing:**
   - Never share user data with third parties without consent
   - Anonymize data for analytics
   - Document data sharing in privacy policy

---

### 9.7 Incident Response

1. **Breach Detection:**
   - Monitor for unusual activity
   - Automated alerts for security events
   - Regular security audits

2. **Breach Response:**
   - Incident response plan documented
   - Notify affected users within 72 hours
   - Report to authorities as required by law
   - Post-mortem and remediation

---

## 10. Technical Requirements

### 10.1 Performance Requirements

1. **Page Load Time:**
   - Initial load: < 3 seconds (3G network)
   - Subsequent pages: < 1 second
   - API response: < 500ms (p95)

2. **App Size:**
   - Initial download: < 25MB
   - Incremental updates: < 5MB
   - Asset optimization: Lazy load images, code splitting

3. **Battery & Memory:**
   - Minimal background activity
   - Image caching: Max 100MB
   - Memory usage: < 200MB

4. **Offline Capability:**
   - Cache critical content
   - Queue actions when offline
   - Sync when online

---

### 10.2 Scalability Requirements

1. **User Load:**
   - Support: 100,000 concurrent users
   - Database: Horizontal scaling (sharding)
   - CDN: For static assets

2. **Data Volume:**
   - News: 1000s of articles
   - Events: 10,000s of reports
   - Files: Unlimited (cloud storage)

---

### 10.3 Platform Requirements

1. **Mobile:**
   - iOS: 13.0+
   - Android: 8.0+ (API level 26)

2. **Browsers (if web):**
   - Chrome: Last 2 versions
   - Safari: Last 2 versions
   - Firefox: Last 2 versions
   - Edge: Last 2 versions

---

### 10.4 Third-Party Integrations

1. **Analytics:**
   - Google Analytics or similar
   - Track: Page views, user flows, events
   - Privacy-compliant

2. **Crash Reporting:**
   - Sentry, Crashlytics, or similar
   - Auto-report crashes
   - User feedback on errors

3. **Push Notifications:**
   - Firebase Cloud Messaging (FCM)
   - Apple Push Notification Service (APNS)
   - Opt-in required

4. **Email Service:**
   - SendGrid, Mailchimp, or similar
   - Transactional emails
   - Marketing emails

5. **Cloud Storage:**
   - AWS S3, Azure Blob, or Google Cloud Storage
   - CDN integration

6. **Maps (future):**
   - Google Maps or Mapbox
   - Location picker
   - Display incident locations

---

### 10.5 Development Requirements

1. **Version Control:**
   - Git repository
   - Branch strategy: Gitflow or trunk-based
   - Pull request reviews

2. **CI/CD:**
   - Automated testing on PR
   - Automated builds
   - Staged deployments (dev, staging, production)

3. **Testing:**
   - Unit tests: 80%+ coverage
   - Integration tests: Critical paths
   - E2E tests: User flows
   - Manual QA: Before release

4. **Code Quality:**
   - Linter: ESLint, Prettier
   - Code reviews: Required
   - Static analysis: SonarQube or similar

5. **Documentation:**
   - API documentation: OpenAPI/Swagger
   - Code comments: For complex logic
   - README: Setup instructions
   - CHANGELOG: Version history

---

### 10.6 Deployment Requirements

1. **Backend:**
   - Cloud hosting: AWS, Azure, GCP
   - Containerization: Docker
   - Orchestration: Kubernetes (optional for scale)
   - Auto-scaling: Based on load

2. **Mobile App:**
   - App Store (iOS)
   - Google Play Store (Android)
   - Beta testing: TestFlight, Google Play Beta

3. **Monitoring:**
   - Uptime monitoring: Pingdom, UptimeRobot
   - Application monitoring: New Relic, Datadog
   - Error tracking: Sentry
   - Log aggregation: ELK stack, Splunk

4. **Backup:**
   - Database backups: Daily, retained 30 days
   - File backups: Incremental
   - Disaster recovery plan: Documented

---

## Appendix A: Sample Workflows (Visual)

### Workflow 1: User Registration to Event Reporting

```
┌─────────────────┐
│  User Opens App │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  View Home Page │◄──────────┐
└────────┬────────┘           │
         │                    │
         ▼                    │
  Taps "Sign Up"              │
         │                    │
         ▼                    │
┌─────────────────┐           │
│  Fill Sign Up   │           │
│     Form        │           │
└────────┬────────┘           │
         │                    │
         ▼                    │
  Submit Registration         │
         │                    │
         ▼                    │
┌─────────────────┐           │
│  Email Sent     │           │
│  Success Alert  │           │
└────────┬────────┘           │
         │                    │
         ▼                    │
  Navigate to Login           │
         │                    │
         ▼                    │
┌─────────────────┐           │
│  Enter Login    │           │
│  Credentials    │           │
└────────┬────────┘           │
         │                    │
         ▼                    │
  Submit Login                │
         │                    │
         ▼                    │
┌─────────────────┐           │
│  Authenticated  │───────────┘
│  Home Page      │
└────────┬────────┘
         │
         ▼
  Taps "Event Reporting"
         │
         ▼
┌─────────────────┐
│  Event Report   │
│      Form       │
└────────┬────────┘
         │
         ▼
  Fill Event Details
         │
         ▼
  Tap "Attach File"
         │
         ▼
┌─────────────────┐
│  File Picker    │
│  (Camera/       │
│   Gallery)      │
└────────┬────────┘
         │
         ▼
  Select File
         │
         ▼
  Preview File
         │
         ▼
  Tap "Submit Report"
         │
         ▼
┌─────────────────┐
│  Upload File    │
│  (Progress Bar) │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Submit Event   │
│     Data        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Success        │
│  Confirmation   │
│  (Report ID)    │
└────────┬────────┘
         │
         ▼
  Return to Home or
  Submit Another
```

---

### Workflow 2: Anonymous User to Subscriber

```
┌─────────────────┐
│  User Opens App │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Home Page      │
│  (Anonymous)    │
└────────┬────────┘
         │
         ▼
  Browse Content
  (News, Education)
         │
         ▼
  Taps "Subscribe"
         │
         ▼
┌─────────────────┐
│  Subscription   │
│     Form        │
└────────┬────────┘
         │
         ▼
  Enter Email
         │
         ▼
  Select Preferences
  (News, Newsletter, etc.)
         │
         ▼
  Agree to Privacy Policy
         │
         ▼
  Tap "Subscribe"
         │
         ▼
┌─────────────────┐
│  API Validation │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Success Alert  │
│  "Check Email"  │
└────────┬────────┘
         │
         ▼
  User Checks Email
         │
         ▼
  Taps Confirmation Link
         │
         ▼
┌─────────────────┐
│  Opens App/Web  │
│  Confirmation   │
│     Page        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│  Subscription   │
│    Activated    │
└────────┬────────┘
         │
         ▼
  Success Message
  "You're Subscribed!"
```

---

## Appendix B: Error Scenarios & Handling

### Common Error Scenarios

1. **Network Errors:**
   - **Scenario:** User loses internet connection
   - **Handling:**
     - Show offline indicator
     - Queue actions (likes, form submissions)
     - Retry automatically when online
     - Display cached content

2. **Authentication Errors:**
   - **Scenario:** Token expired during session
   - **Handling:**
     - Attempt auto-refresh with refresh token
     - If refresh fails, redirect to login
     - Show message: "Your session expired. Please login again."

3. **File Upload Errors:**
   - **Scenario:** File too large or upload fails
   - **Handling:**
     - Show specific error: "File size exceeds 10MB limit."
     - Allow retry
     - Save form data (don't lose user's work)
     - Show upload progress

4. **Form Validation Errors:**
   - **Scenario:** User submits invalid data
   - **Handling:**
     - Highlight invalid fields
     - Show inline error messages
     - Don't clear valid fields
     - Focus on first error

5. **Server Errors (5xx):**
   - **Scenario:** Backend service down
   - **Handling:**
     - Show generic message: "Something went wrong. Please try again."
     - Log error details for debugging
     - Offer retry option
     - Provide support contact

---

## Appendix C: Localization Considerations (Future)

### Supported Languages (Future Roadmap)
- English (default)
- Spanish
- French
- Arabic (RTL support)
- Portuguese

### Implementation Requirements
- Extract all text strings to resource files
- Use i18n library (e.g., i18next)
- Support RTL layouts
- Format dates/times per locale
- Format numbers/currency per locale
- Translate content in database (multi-language content table)

---

## Appendix D: Analytics & Metrics

### Key Performance Indicators (KPIs)

1. **User Engagement:**
   - Daily Active Users (DAU)
   - Monthly Active Users (MAU)
   - Session duration
   - Screens per session

2. **Content Engagement:**
   - News article views
   - Educational content views
   - Video views (if applicable)
   - Content shares (future)

3. **Conversion Metrics:**
   - Sign-ups per week
   - Login rate
   - Event reports submitted per week
   - Email subscriptions per week

4. **Feature Usage:**
   - % of users who reported events
   - % of users who liked news
   - Most viewed educational categories
   - Contact form submissions

5. **Technical Metrics:**
   - App crashes per session
   - API error rate
   - Average API response time
   - Page load time

### Event Tracking

**User Events:**
- App opened
- User registered
- User logged in
- User logged out

**Content Events:**
- News article viewed
- News article liked
- Educational content viewed
- Content shared (future)

**Action Events:**
- Event reported
- File uploaded
- Feedback submitted
- Subscription confirmed
- Contact form submitted

**Error Events:**
- API error
- File upload failed
- Form validation error
- App crash

---

## Document Change Log

| Version | Date       | Author | Changes |
|---------|------------|--------|---------|
| 1.0     | 2025-11-20 | Claude | Initial comprehensive workflow plan created from existing Ionic/Angular app |

---

**End of Document**

This workflow plan provides a complete, framework-agnostic blueprint for rebuilding the UNICEF Child Protection mobile application. It can be used with React Native, Flutter, Swift/Kotlin native, or any other mobile development framework.
