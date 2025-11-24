import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Application shadow styles
///
/// Defines consistent box shadows for elevation and depth effects
/// according to CHILD_PROTECTION_DESIGN.md specifications.
///
/// Design Principle: Soft, subtle shadows for a gentle, child-friendly aesthetic
class AppShadows {
  // Private constructor to prevent instantiation
  AppShadows._();

  // ============================================================================
  // SHADOW COLORS
  // ============================================================================

  /// Standard shadow color - 13% black opacity
  ///
  /// Usage: Most shadows throughout the app
  static const Color shadowColor = AppColors.cardShadow;

  /// Light shadow color - 8% black opacity
  ///
  /// Usage: Very subtle shadows, hover states
  static const Color shadowColorLight = Color(0x14000000);

  /// Medium shadow color - 18% black opacity
  ///
  /// Usage: More prominent shadows, focused elements
  static const Color shadowColorMedium = Color(0x2E000000);

  /// Dark shadow color - 25% black opacity
  ///
  /// Usage: Strong shadows, modals, drawers
  static const Color shadowColorDark = Color(0x40000000);

  // ============================================================================
  // STANDARD SHADOWS (BoxShadow Lists)
  // ============================================================================

  /// No shadow - Empty list
  ///
  /// Usage: Flat elements without elevation
  static const List<BoxShadow> none = [];

  /// Extra small shadow - Very subtle
  ///
  /// Usage: Hover states, minimal elevation
  /// Offset: (0, 1), Blur: 4, Color: 8% black
  static final List<BoxShadow> xs = [
    BoxShadow(
      color: shadowColorLight,
      blurRadius: 4,
      offset: const Offset(0, 1),
      spreadRadius: 0,
    ),
  ];

  /// Small shadow - Soft and subtle
  ///
  /// Usage: Small cards, chips, raised buttons
  /// Offset: (0, 2), Blur: 8, Color: 13% black
  static final List<BoxShadow> sm = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 8,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
  ];

  /// Medium shadow - Standard cards
  ///
  /// Usage: Cards, news articles, content items
  /// Offset: (0, 4), Blur: 8, Color: 13% black (from design spec)
  static final List<BoxShadow> md = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Large shadow - Elevated elements
  ///
  /// Usage: Elevated cards, dropdowns, floating elements
  /// Offset: (0, 4), Blur: 12, Color: 18% black
  static final List<BoxShadow> lg = [
    BoxShadow(
      color: shadowColorMedium,
      blurRadius: 12,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
  ];

  /// Extra large shadow - Prominent elements
  ///
  /// Usage: Modals, dialogs, navigation drawers
  /// Offset: (0, 8), Blur: 16, Color: 25% black
  static final List<BoxShadow> xl = [
    BoxShadow(
      color: shadowColorDark,
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: 0,
    ),
  ];

  /// Extra extra large shadow - Maximum elevation
  ///
  /// Usage: Large modals, full-screen overlays
  /// Offset: (0, 12), Blur: 24, Color: 25% black
  static final List<BoxShadow> xxl = [
    BoxShadow(
      color: shadowColorDark,
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: 0,
    ),
  ];

  // ============================================================================
  // SEMANTIC SHADOWS
  // ============================================================================

  /// Card shadow - Standard card elevation
  ///
  /// Usage: News cards, education content cards, feedback items
  /// Matches design specification: offset (0, 4), blur 8
  static final List<BoxShadow> card = md;

  /// Button shadow - Elevated button
  ///
  /// Usage: Primary buttons, FABs
  static final List<BoxShadow> button = sm;

  /// Modal shadow - Dialog and bottom sheet
  ///
  /// Usage: Dialogs, bottom sheets, overlays
  static final List<BoxShadow> modal = xl;

  /// Dropdown shadow - Menu elevation
  ///
  /// Usage: Dropdown menus, autocomplete popups
  static final List<BoxShadow> dropdown = lg;

  /// App bar shadow - Top navigation
  ///
  /// Usage: App bar, persistent headers
  static final List<BoxShadow> appBar = sm;

  /// Floating shadow - Floating elements
  ///
  /// Usage: FAB, snackbar, tooltip
  static final List<BoxShadow> floating = lg;

  // ============================================================================
  // LAYERED SHADOWS (Multiple shadows for depth)
  // ============================================================================

  /// Layered card shadow - Two-layer shadow for depth
  ///
  /// Usage: Featured cards, hero elements
  static final List<BoxShadow> cardLayered = [
    BoxShadow(
      color: shadowColorLight,
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowColor,
      blurRadius: 12,
      offset: const Offset(0, 6),
      spreadRadius: -2,
    ),
  ];

  /// Layered modal shadow - Three-layer shadow for maximum depth
  ///
  /// Usage: Large modals, full-screen dialogs
  static final List<BoxShadow> modalLayered = [
    BoxShadow(
      color: shadowColorLight,
      blurRadius: 8,
      offset: const Offset(0, 4),
      spreadRadius: 0,
    ),
    BoxShadow(
      color: shadowColorMedium,
      blurRadius: 16,
      offset: const Offset(0, 8),
      spreadRadius: -2,
    ),
    BoxShadow(
      color: shadowColorDark,
      blurRadius: 24,
      offset: const Offset(0, 12),
      spreadRadius: -4,
    ),
  ];

  // ============================================================================
  // INNER SHADOWS (Using negative spread for inset effect)
  // ============================================================================

  /// Inner shadow - Subtle inset effect
  ///
  /// Usage: Pressed buttons, input fields (focus state)
  /// Note: Flutter doesn't natively support inset shadows like CSS,
  /// but we can approximate with negative spread and careful positioning
  static final List<BoxShadow> inner = [
    BoxShadow(
      color: shadowColor,
      blurRadius: 4,
      offset: const Offset(0, 2),
      spreadRadius: -2,
    ),
  ];

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Create a custom shadow with specific parameters
  static List<BoxShadow> custom({
    required double offsetY,
    required double blur,
    Color? color,
    double offsetX = 0,
    double spread = 0,
  }) {
    return [
      BoxShadow(
        color: color ?? shadowColor,
        blurRadius: blur,
        offset: Offset(offsetX, offsetY),
        spreadRadius: spread,
      ),
    ];
  }

  /// Create a shadow with custom opacity
  static List<BoxShadow> withOpacity({
    required List<BoxShadow> shadows,
    required double opacity,
  }) {
    assert(opacity >= 0 && opacity <= 1, 'Opacity must be between 0 and 1');

    return shadows.map((shadow) {
      return BoxShadow(
        color: shadow.color.withOpacity(shadow.color.opacity * opacity),
        blurRadius: shadow.blurRadius,
        offset: shadow.offset,
        spreadRadius: shadow.spreadRadius,
      );
    }).toList();
  }

  /// Scale a shadow (increase or decrease size)
  static List<BoxShadow> scale({
    required List<BoxShadow> shadows,
    required double factor,
  }) {
    assert(factor > 0, 'Scale factor must be positive');

    return shadows.map((shadow) {
      return BoxShadow(
        color: shadow.color,
        blurRadius: shadow.blurRadius * factor,
        offset: shadow.offset * factor,
        spreadRadius: shadow.spreadRadius * factor,
      );
    }).toList();
  }

  /// Combine multiple shadow lists
  static List<BoxShadow> combine(List<List<BoxShadow>> shadowLists) {
    return shadowLists.expand((list) => list).toList();
  }

  // ============================================================================
  // MATERIAL ELEVATION MAPPING
  // ============================================================================

  /// Get shadow for Material elevation level (0-24)
  ///
  /// Maps Material Design elevation values to our shadow system
  static List<BoxShadow> fromElevation(double elevation) {
    if (elevation <= 0) return none;
    if (elevation <= 1) return xs;
    if (elevation <= 2) return sm;
    if (elevation <= 4) return md;
    if (elevation <= 8) return lg;
    if (elevation <= 16) return xl;
    return xxl;
  }
}
