import 'package:flutter/material.dart';

/// Application dimensions and spacing system
///
/// All dimensions are defined according to the CHILD_PROTECTION_DESIGN.md
/// specifications to ensure consistency across the application.
///
/// Design Principle: 8px base unit for all spacing
class AppDimensions {
  // Private constructor to prevent instantiation
  AppDimensions._();

  // ============================================================================
  // SPACING (8px increments)
  // ============================================================================

  /// Extra small spacing - 4px
  ///
  /// Usage: Minimal gaps, tight spacing
  static const double spaceXs = 4.0;

  /// Small spacing - 8px (Base unit)
  ///
  /// Usage: Compact spacing, list item gaps
  static const double spaceSm = 8.0;

  /// Medium spacing - 16px
  ///
  /// Usage: Standard padding, card content spacing
  static const double spaceMd = 16.0;

  /// Large spacing - 24px
  ///
  /// Usage: Section spacing, larger gaps
  static const double spaceLg = 24.0;

  /// Extra large spacing - 32px
  ///
  /// Usage: Major section breaks, screen padding
  static const double spaceXl = 32.0;

  /// Extra extra large spacing - 40px
  ///
  /// Usage: Large section breaks
  static const double spaceXxl = 40.0;

  /// Extra extra extra large spacing - 48px
  ///
  /// Usage: Screen-level spacing, major dividers
  static const double spaceXxxl = 48.0;

  // ============================================================================
  // BORDER RADIUS
  // ============================================================================

  /// Small radius - 8px
  ///
  /// Usage: Small elements, chips, badges
  static const double radiusSm = 8.0;

  /// Medium radius - 12px
  ///
  /// Usage: Buttons, input fields, small cards
  static const double radiusMd = 12.0;

  /// Large radius - 16px
  ///
  /// Usage: Category cards, medium containers
  static const double radiusLg = 16.0;

  /// Extra large radius - 20px
  ///
  /// Usage: Standard cards, feature cards, news articles
  static const double radiusXl = 20.0;

  /// Extra extra large radius - 24px
  ///
  /// Usage: Large containers, modal dialogs
  static const double radiusXxl = 24.0;

  /// Circular radius - 999px
  ///
  /// Usage: Fully rounded elements, pills
  static const double radiusCircular = 999.0;

  // ============================================================================
  // COMPONENT HEIGHTS
  // ============================================================================

  /// Button height - 48px (minimum touch target)
  ///
  /// Usage: All buttons (primary, secondary, text)
  static const double buttonHeight = 48.0;

  /// Small button height - 40px
  ///
  /// Usage: Compact buttons in tight spaces
  static const double buttonHeightSmall = 40.0;

  /// Large button height - 56px
  ///
  /// Usage: Prominent CTAs, hero buttons
  static const double buttonHeightLarge = 56.0;

  /// Input field height - 48px (minimum touch target)
  ///
  /// Usage: Text fields, dropdowns, date pickers
  static const double inputHeight = 48.0;

  /// App bar height - 56px
  ///
  /// Usage: Top navigation bar
  static const double appBarHeight = 56.0;

  /// Bottom navigation height - 60px
  ///
  /// Usage: Bottom navigation bar
  static const double bottomNavHeight = 60.0;

  /// List item height - 72px
  ///
  /// Usage: Standard list items with icon and text
  static const double listItemHeight = 72.0;

  // ============================================================================
  // ICON SIZES
  // ============================================================================

  /// Extra small icon - 16px
  ///
  /// Usage: Inline icons, small indicators
  static const double iconXs = 16.0;

  /// Small icon - 20px
  ///
  /// Usage: Button icons, input icons
  static const double iconSm = 20.0;

  /// Medium icon - 24px (default)
  ///
  /// Usage: Standard icons, navigation icons
  static const double iconMd = 24.0;

  /// Large icon - 32px
  ///
  /// Usage: List item icons, feature icons
  static const double iconLg = 32.0;

  /// Extra large icon - 40px
  ///
  /// Usage: Card icons, prominent features
  static const double iconXl = 40.0;

  /// Extra extra large icon - 48px
  ///
  /// Usage: Hero icons, splash screens
  static const double iconXxl = 48.0;

  /// Extra extra extra large icon - 64px
  ///
  /// Usage: Large feature icons, empty states
  static const double iconXxxl = 64.0;

  // ============================================================================
  // AVATAR SIZES
  // ============================================================================

  /// Small avatar - 32px
  ///
  /// Usage: Compact user avatars, inline display
  static const double avatarSm = 32.0;

  /// Medium avatar - 40px
  ///
  /// Usage: Standard user avatars, list items
  static const double avatarMd = 40.0;

  /// Large avatar - 56px
  ///
  /// Usage: Profile avatars, prominent display
  static const double avatarLg = 56.0;

  /// Extra large avatar - 80px
  ///
  /// Usage: Profile headers, user pages
  static const double avatarXl = 80.0;

  // ============================================================================
  // TOUCH TARGETS (Accessibility)
  // ============================================================================

  /// Minimum touch target size - 44x44
  ///
  /// Usage: Minimum size for all interactive elements (WCAG guideline)
  static const double minTouchTarget = 44.0;

  /// Recommended touch target size - 48x48
  ///
  /// Usage: Comfortable touch target for buttons and interactive elements
  static const double recommendedTouchTarget = 48.0;

  // ============================================================================
  // PADDING (Component-specific)
  // ============================================================================

  /// Button padding - Horizontal
  ///
  /// Usage: Horizontal padding inside buttons
  static const double buttonPaddingH = 24.0;

  /// Button padding - Vertical
  ///
  /// Usage: Vertical padding inside buttons
  static const double buttonPaddingV = 14.0;

  /// Input padding - All sides
  ///
  /// Usage: Content padding inside text fields
  static const double inputPadding = 16.0;

  /// Card padding - Standard
  ///
  /// Usage: Content padding inside cards
  static const double cardPadding = 16.0;

  /// Card padding - Large
  ///
  /// Usage: Generous padding for feature cards
  static const double cardPaddingLarge = 24.0;

  /// Screen padding - Horizontal
  ///
  /// Usage: Left/right padding for screen content
  static const double screenPaddingH = 16.0;

  /// Screen padding - Vertical
  ///
  /// Usage: Top/bottom padding for screen content
  static const double screenPaddingV = 16.0;

  // ============================================================================
  // ELEVATION (Shadow depth)
  // ============================================================================

  /// No elevation
  static const double elevationNone = 0.0;

  /// Small elevation - 2dp
  ///
  /// Usage: Buttons, small elevated elements
  static const double elevationSm = 2.0;

  /// Medium elevation - 4dp
  ///
  /// Usage: Cards, app bar
  static const double elevationMd = 4.0;

  /// Large elevation - 8dp
  ///
  /// Usage: Floating action button, dialogs
  static const double elevationLg = 8.0;

  /// Extra large elevation - 16dp
  ///
  /// Usage: Navigation drawer, modal sheets
  static const double elevationXl = 16.0;

  // ============================================================================
  // DIVIDER
  // ============================================================================

  /// Divider thickness - 1px
  ///
  /// Usage: Horizontal dividers, list separators
  static const double dividerThickness = 1.0;

  /// Border width - Standard
  ///
  /// Usage: Input borders, outlined buttons
  static const double borderWidth = 2.0;

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get EdgeInsets with all sides equal
  static EdgeInsets all(double value) => EdgeInsets.all(value);

  /// Get EdgeInsets with horizontal padding
  static EdgeInsets horizontal(double value) =>
      EdgeInsets.symmetric(horizontal: value);

  /// Get EdgeInsets with vertical padding
  static EdgeInsets vertical(double value) =>
      EdgeInsets.symmetric(vertical: value);

  /// Get EdgeInsets with symmetric padding
  static EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Get EdgeInsets with specific values
  static EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);

  /// Standard screen padding
  static EdgeInsets get screenPadding =>
      EdgeInsets.symmetric(horizontal: screenPaddingH, vertical: screenPaddingV);

  /// Standard card padding
  static EdgeInsets get cardPaddingInsets => EdgeInsets.all(cardPadding);

  /// Large card padding
  static EdgeInsets get cardPaddingLargeInsets =>
      EdgeInsets.all(cardPaddingLarge);

  /// Button padding
  static EdgeInsets get buttonPadding =>
      EdgeInsets.symmetric(horizontal: buttonPaddingH, vertical: buttonPaddingV);

  /// Input padding
  static EdgeInsets get inputPaddingInsets => EdgeInsets.all(inputPadding);

  /// Get BorderRadius with all corners equal
  static BorderRadius radius(double value) => BorderRadius.circular(value);

  /// Small border radius
  static BorderRadius get radiusSmall => BorderRadius.circular(radiusSm);

  /// Medium border radius
  static BorderRadius get radiusMedium => BorderRadius.circular(radiusMd);

  /// Large border radius
  static BorderRadius get radiusLarge => BorderRadius.circular(radiusLg);

  /// Extra large border radius
  static BorderRadius get radiusExtraLarge => BorderRadius.circular(radiusXl);

  /// Circular border radius
  static BorderRadius get radiusCircle => BorderRadius.circular(radiusCircular);
}
