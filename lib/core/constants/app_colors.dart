import 'package:flutter/material.dart';

/// Application color palette
///
/// All colors are defined according to the CHILD_PROTECTION_DESIGN.md
/// specifications. This ensures consistency across the entire application.
///
/// Design Philosophy:
/// - Child-friendly with soft, approachable colors
/// - Accessible with high contrast for readability
/// - Calm & safe with gentle pastel palette
/// - Modern with clean, minimalist aesthetic
class AppColors {
  // Private constructor to prevent instantiation
  AppColors._();

  // ============================================================================
  // PRIMARY COLORS
  // ============================================================================

  /// UNICEF Brand Blue - Primary brand color
  ///
  /// Usage: Primary buttons, app bar, links, active states
  static const Color unicefBlue = Color(0xFF1CA7EC);

  /// Soft Blue - Lighter, gentler blue
  ///
  /// Usage: Secondary elements, hover states, backgrounds
  static const Color softBlue = Color(0xFF7ED7D0);

  /// Sky Blue - Very light blue
  ///
  /// Usage: Light backgrounds, subtle highlights
  static const Color skyBlue = Color(0xFFB8E6F0);

  // ============================================================================
  // BACKGROUND & SURFACE COLORS
  // ============================================================================

  /// App Background - Light blue-gray
  ///
  /// Usage: Main background color for all screens
  static const Color background = Color(0xFFF3F8FA);

  /// Card White - Pure white
  ///
  /// Usage: Card backgrounds, elevated surfaces
  static const Color cardWhite = Color(0xFFFFFFFF);

  /// Surface Gray - Alternative surface color
  ///
  /// Usage: Input fields, secondary surfaces, disabled states
  static const Color surfaceGray = Color(0xFFF7F9FC);

  // ============================================================================
  // ACCENT COLORS (PASTEL)
  // ============================================================================

  /// Pastel Pink - Gentle pink
  ///
  /// Usage: Events category, gentle highlights, decorative elements
  static const Color pastelPink = Color(0xFFF7C8D8);

  /// Pastel Yellow - Soft yellow
  ///
  /// Usage: News category, warnings, attention elements
  static const Color pastelYellow = Color(0xFFFFF0C2);

  /// Pastel Purple - Light purple
  ///
  /// Usage: Education category, creative elements
  static const Color pastelPurple = Color(0xFFE7D7FF);

  /// Pastel Green - Mint green
  ///
  /// Usage: Feedback category, success states, positive actions
  static const Color pastelGreen = Color(0xFFD4F4DD);

  // ============================================================================
  // TEXT COLORS
  // ============================================================================

  /// Text Dark - Headings and emphasis
  ///
  /// Usage: H1-H6 headings, emphasized text, important labels
  static const Color textDark = Color(0xFF1B1D21);

  /// Text Medium - Body text
  ///
  /// Usage: Body text, paragraphs, general content
  static const Color textMedium = Color(0xFF6D6D6D);

  /// Text Light - Captions and hints
  ///
  /// Usage: Captions, hints, secondary information, timestamps
  static const Color textLight = Color(0xFF9E9E9E);

  // ============================================================================
  // SEMANTIC COLORS (SOFTER VERSIONS)
  // ============================================================================

  /// Success - Soft green
  ///
  /// Usage: Success messages, completed states, positive feedback
  static const Color success = Color(0xFF7FD99E);

  /// Warning - Soft orange
  ///
  /// Usage: Warning messages, caution states, important notices
  static const Color warning = Color(0xFFFFD88A);

  /// Error - Soft red
  ///
  /// Usage: Error messages, failed states, destructive actions
  static const Color error = Color(0xFFFFB3B3);

  /// Info - Soft blue
  ///
  /// Usage: Informational messages, tips, helpful hints
  static const Color info = Color(0xFF9DD4F7);

  // ============================================================================
  // SHADOWS
  // ============================================================================

  /// Card Shadow - 13% black opacity
  ///
  /// Usage: Box shadows for cards and elevated components
  static const Color cardShadow = Color(0x22000000);

  // ============================================================================
  // CATEGORY-SPECIFIC COLORS
  // ============================================================================

  /// Get color for specific feature category
  static Color getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'education':
        return pastelPurple;
      case 'events':
      case 'event':
        return pastelPink;
      case 'news':
        return pastelYellow;
      case 'feedback':
        return pastelGreen;
      default:
        return unicefBlue;
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get text color based on background brightness
  ///
  /// Returns dark text for light backgrounds and light text for dark backgrounds
  static Color getTextColorForBackground(Color backgroundColor) {
    final luminance = backgroundColor.computeLuminance();
    return luminance > 0.5 ? textDark : cardWhite;
  }

  /// Lighten a color by a given percentage (0.0 - 1.0)
  static Color lighten(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness + amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Darken a color by a given percentage (0.0 - 1.0)
  static Color darken(Color color, [double amount = 0.1]) {
    assert(amount >= 0 && amount <= 1, 'Amount must be between 0 and 1');

    final hsl = HSLColor.fromColor(color);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);

    return hsl.withLightness(lightness).toColor();
  }

  /// Create a shadow color with custom opacity
  static Color shadow([double opacity = 0.13]) {
    return Color.fromRGBO(0, 0, 0, opacity);
  }
}
