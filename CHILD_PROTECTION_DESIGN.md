# Child Protection App - Design Concept
**Visual Style Inspired by Modern Pastel UI Design**

## Design Philosophy
- **Child-friendly**: Soft, approachable colors and rounded elements
- **Accessible**: High contrast for readability, large touch targets
- **Calm & Safe**: Gentle color palette that feels welcoming
- **Modern**: Clean, minimalist design with subtle shadows

---

## Color Palette

### Primary Colors
```dart
// UNICEF Brand - adapted to softer palette
static const unicefBlue = Color(0xFF1CA7EC);      // Primary brand color
static const softBlue = Color(0xFF7ED7D0);        // Lighter, gentler blue
static const skyBlue = Color(0xFFB8E6F0);         // Very light blue

// Background & Surface
static const background = Color(0xFFF3F8FA);      // Light blue-gray
static const cardWhite = Color(0xFFFFFFFF);       // Pure white for cards
static const surfaceGray = Color(0xFFF7F9FC);     // Alternative surface

// Accent Colors - Pastel
static const pastelPink = Color(0xFFF7C8D8);      // Gentle pink
static const pastelYellow = Color(0xFFFFF0C2);    // Soft yellow
static const pastelPurple = Color(0xFFE7D7FF);    // Light purple
static const pastelGreen = Color(0xFFD4F4DD);     // Mint green

// Text Colors
static const textDark = Color(0xFF1B1D21);        // Headings
static const textMedium = Color(0xFF6D6D6D);      // Body text
static const textLight = Color(0xFF9E9E9E);       // Captions

// Semantic Colors (softer versions)
static const success = Color(0xFF7FD99E);         // Soft green
static const warning = Color(0xFFFFD88A);         // Soft orange
static const error = Color(0xFFFFB3B3);           // Soft red
static const info = Color(0xFF9DD4F7);            // Soft blue

// Shadows
static const cardShadow = Color(0x22000000);      // 13% black
```

### Color Usage Guide
- **Background**: `background` (#F3F8FA) for all screens
- **Cards**: `cardWhite` with `cardShadow` for depth
- **Primary Actions**: `unicefBlue` for buttons
- **Categories**: Use pastel colors for different sections
  - Education: `pastelPurple`
  - Events: `pastelPink`
  - News: `pastelYellow`
  - Feedback: `pastelGreen`

---

## Typography

### Font Family
```dart
// Primary: Poppins (headings) - friendly, rounded
// Secondary: Nunito Sans (body) - clean, readable
```

### Text Styles
```dart
// Headings
h1: Poppins, 28px, Weight: 700, Color: textDark
h2: Poppins, 22px, Weight: 600, Color: textDark
h3: Poppins, 18px, Weight: 600, Color: textDark
h4: Poppins, 16px, Weight: 500, Color: textDark

// Body
body1: Nunito Sans, 16px, Weight: 400, Color: textMedium, LineHeight: 1.5
body2: Nunito Sans, 14px, Weight: 400, Color: textMedium, LineHeight: 1.5
caption: Nunito Sans, 12px, Weight: 400, Color: textLight

// Button Text
button: Nunito Sans, 16px, Weight: 600, Color: white
```

---

## Component Design

### 1. Card Components

#### Standard Card
```dart
Container(
  decoration: BoxDecoration(
    color: AppColors.cardWhite,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [
      BoxShadow(
        color: AppColors.cardShadow,
        blurRadius: 8,
        offset: Offset(0, 4),
      )
    ],
  ),
  // content...
)
```

**Usage**: News articles, education content, feedback items

#### Category Card (Grid Item)
```dart
// Rounded card with colored circular avatar
Column(
  children: [
    Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: cardShadow, blurRadius: 8)],
        ),
        child: Center(
          child: CircleAvatar(
            radius: 34,
            backgroundColor: pastelColor, // Different per category
            child: Icon/Image,
          ),
        ),
      ),
    ),
    SizedBox(height: 8),
    Text(categoryName),
  ],
)
```

**Usage**: Education categories (4 mandala sections), topic selection

### 2. Buttons

#### Primary Button
```dart
ElevatedButton(
  style: ElevatedButton.styleFrom(
    primary: AppColors.unicefBlue,
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    elevation: 2,
  ),
  child: Text('Submit', style: buttonTextStyle),
)
```

**Height**: 48px minimum (touch target)

#### Secondary Button
```dart
OutlinedButton(
  style: OutlinedButton.styleFrom(
    side: BorderSide(color: AppColors.unicefBlue, width: 2),
    padding: EdgeInsets.symmetric(vertical: 14, horizontal: 24),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
  ),
  child: Text('Cancel', style: TextStyle(color: unicefBlue)),
)
```

### 3. Input Fields

```dart
TextField(
  decoration: InputDecoration(
    hintText: 'Enter your name',
    filled: true,
    fillColor: AppColors.surfaceGray,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppColors.unicefBlue, width: 2),
    ),
    contentPadding: EdgeInsets.all(16),
  ),
)
```

**Height**: 48px minimum

### 4. List Items

#### News Article Card (Horizontal)
```dart
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(20),
    boxShadow: [BoxShadow(color: cardShadow, blurRadius: 8)],
  ),
  child: Row(
    children: [
      // Left: Image (110x110, rounded left corners)
      ClipRRect(
        borderRadius: BorderRadius.horizontal(left: Radius.circular(20)),
        child: Image.network(imageUrl, width: 110, height: 110, fit: BoxFit.cover),
      ),
      // Right: Content
      Expanded(
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: h3),
              SizedBox(height: 6),
              Text(snippet, style: body2, maxLines: 2),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.favorite_border, size: 18),
                  SizedBox(width: 4),
                  Text('24 likes', style: caption),
                  Spacer(),
                  ElevatedButton(child: Text('Read'), onPressed: ...)
                ],
              ),
            ],
          ),
        ),
      ),
    ],
  ),
)
```

**Spacing**: 12px between list items

### 5. Grids

#### Education Categories (3x2 grid)
```dart
GridView.builder(
  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    mainAxisSpacing: 16,
    crossAxisSpacing: 16,
    childAspectRatio: 0.85,
  ),
  itemBuilder: (ctx, idx) => CategoryCard(...),
)
```

---

## Screen Layouts

### 1. Home Screen (Mandala)
```
┌─────────────────────────────┐
│ [Back] The Child Mandala  🔔│  ← UNICEF Blue AppBar
├─────────────────────────────┤
│                             │
│   ┌───────────────────┐    │
│   │                   │    │
│   │   MANDALA IMAGE   │    │  ← SVG mandala (no overlays)
│   │   (Interactive)    │    │
│   │                   │    │
│   └───────────────────┘    │
│                             │
│  Tap on sections to explore │  ← Caption (textLight)
│  child rights topics        │
│                             │
└─────────────────────────────┘
```

**Design Notes**:
- Clean, centered layout
- Mandala takes 70% of screen height
- No visible overlays (invisible tap detection)
- Soft background color

### 2. Education Category Screen (After tapping mandala section)
```
┌─────────────────────────────┐
│ ← Survival & Development    │  ← Colored AppBar (pastelPurple)
├─────────────────────────────┤
│                             │
│  ╔═══════════════════════╗  │  ← Hero Image Card
│  ║                       ║  │     (rounded, shadowed)
│  ║   [Happy Children]    ║  │
│  ║                       ║  │
│  ╚═══════════════════════╝  │
│                             │
│  Happiness and Wellbeing    │  ← Title (h2)
│  I'm happy                  │  ← Subtitle (h4, colored)
│                             │
│  ┌─────────────────────┐   │  ← Content Card
│  │ Educational content │   │     (white, rounded, shadowed)
│  │ text goes here...   │   │
│  │                     │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │  ← Related Topics (Grid)
│  │ [Topic] │ [Topic]   │   │
│  │ [Topic] │ [Topic]   │   │
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

### 3. News Feed Screen
```
┌─────────────────────────────┐
│ News & Updates        🔍    │  ← Header with search
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐   │  ← News Card (horizontal)
│  │[IMG]│ Breaking News │   │
│  │     │ article...    │   │
│  │     │ ♡ 24  [Read]  │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │[IMG]│ Latest Update │   │
│  │     │ content...    │   │
│  │     │ ♡ 15  [Read]  │   │
│  └─────────────────────┘   │
│                             │
│  ┌─────────────────────┐   │
│  │[IMG]│ Community...  │   │
│  │     │ story...      │   │
│  │     │ ♡ 32  [Read]  │   │
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

### 4. Event Reporting Form
```
┌─────────────────────────────┐
│ ← Report an Incident        │
├─────────────────────────────┤
│                             │
│  ┌─────────────────────┐   │  ← Form Card (white)
│  │ Title *             │   │
│  │ [____________]      │   │
│  │                     │   │
│  │ Description *       │   │
│  │ [____________]      │   │
│  │ [____________]      │   │
│  │                     │   │
│  │ Category *          │   │
│  │ [▼ Select...]       │   │
│  │                     │   │
│  │ Location            │   │
│  │ [____________]      │   │
│  │                     │   │
│  │ ┌─────────────┐    │   │  ← Upload Area
│  │ │  📷         │    │   │
│  │ │  Add Photos │    │   │
│  │ └─────────────┘    │   │
│  │                     │   │
│  │  [ Submit Report ]  │   │  ← Primary button
│  │  [    Cancel    ]   │   │  ← Secondary button
│  └─────────────────────┘   │
│                             │
└─────────────────────────────┘
```

---

## Spacing & Layout

### Padding
- **Screen edges**: 16px
- **Card padding**: 16-20px
- **Between elements**: 8-16px (using 8px increments)
- **Between sections**: 24-32px

### Border Radius
- **Cards**: 20px
- **Buttons**: 12px
- **Input fields**: 12px
- **Small elements**: 8-10px
- **Circular avatars**: 50% (full circle)

### Shadows
```dart
// Default card shadow
BoxShadow(
  color: Color(0x22000000),  // 13% opacity black
  blurRadius: 8,
  offset: Offset(0, 4),
)

// Elevated elements (buttons on press)
BoxShadow(
  color: Color(0x33000000),  // 20% opacity black
  blurRadius: 12,
  offset: Offset(0, 6),
)
```

---

## Icon Style
- **Line icons** (outlined, not filled)
- **Size**: 24px for navigation, 20px for inline icons
- **Color**: Match text color (textMedium or textLight)

---

## Animations

### Page Transitions
```dart
// Gentle fade + slide up
PageRouteBuilder(
  transitionDuration: Duration(milliseconds: 300),
  pageBuilder: (context, animation, secondaryAnimation) => page,
  transitionsBuilder: (context, animation, secondaryAnimation, child) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: Offset(0, 0.1),
          end: Offset.zero,
        ).animate(CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        )),
        child: child,
      ),
    );
  },
)
```

### Button Press
```dart
// Scale down slightly on tap
AnimatedScale(
  scale: _isPressed ? 0.95 : 1.0,
  duration: Duration(milliseconds: 100),
  curve: Curves.easeOut,
  child: button,
)
```

---

## Accessibility

- **Minimum touch target**: 44x44px
- **Text contrast ratio**: Minimum 4.5:1 (WCAG AA)
- **Interactive elements**: Clear visual feedback
- **Focus indicators**: 2px border for keyboard navigation
- **Screen reader**: Semantic labels on all interactive elements

---

## Bottom Navigation (if used)

```dart
BottomNavigationBar(
  backgroundColor: Colors.white,
  selectedItemColor: AppColors.unicefBlue,
  unselectedItemColor: AppColors.textLight,
  elevation: 8,
  items: [
    BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Home'),
    BottomNavigationBarItem(icon: Icon(Icons.article_outlined), label: 'News'),
    BottomNavigationBarItem(icon: Icon(Icons.report_outlined), label: 'Report'),
    BottomNavigationBarItem(icon: Icon(Icons.school_outlined), label: 'Learn'),
  ],
)
```

**Height**: 56px

---

## AppBar Design

```dart
AppBar(
  backgroundColor: AppColors.unicefBlue,
  elevation: 2,
  title: Text(
    'Screen Title',
    style: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.w500,
    ),
  ),
  iconTheme: IconThemeData(color: Colors.white),
  actions: [
    IconButton(icon: Icon(Icons.search), onPressed: ...),
    IconButton(icon: Icon(Icons.notifications_none), onPressed: ...),
  ],
)
```

**Height**: 56px

---

## Image Treatment

### List/Grid Thumbnails
- **Aspect ratio**: 1:1 (square) or 16:9 (landscape)
- **Border radius**: Match container (usually 12-16px)
- **Loading**: Show skeleton/placeholder with shimmer effect
- **Error**: Show placeholder icon in pastel color background

### Full-Width Images
- **Max height**: 40% of screen height
- **Fit**: BoxFit.cover
- **Rounded corners**: Top corners only (if in card)

---

## Empty States

```dart
Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        Icons.inbox_outlined,
        size: 80,
        color: AppColors.textLight,
      ),
      SizedBox(height: 16),
      Text(
        'No items yet',
        style: h3.copyWith(color: textLight),
      ),
      SizedBox(height: 8),
      Text(
        'Content will appear here',
        style: body2.copyWith(color: textLight),
      ),
    ],
  ),
)
```

---

## Loading States

### Shimmer Effect (Skeleton)
```dart
// Use shimmer package
Shimmer.fromColors(
  baseColor: Colors.grey[300]!,
  highlightColor: Colors.grey[100]!,
  child: Container(
    height: 110,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20),
    ),
  ),
)
```

### Circular Progress
```dart
Center(
  child: CircularProgressIndicator(
    valueColor: AlwaysStoppedAnimation<Color>(AppColors.unicefBlue),
  ),
)
```

---

## Implementation Priority

### Phase 1: Core Design System
1. Set up color constants
2. Define text styles
3. Create base card component
4. Implement button styles

### Phase 2: Key Screens
1. Mandala home screen (with clean design)
2. Education content screens (with pastel headers)
3. News feed (horizontal cards)

### Phase 3: Forms & Interactions
1. Event reporting form
2. Feedback form
3. Subscription form

### Phase 4: Polish
1. Animations
2. Loading states
3. Empty states
4. Error handling UI
