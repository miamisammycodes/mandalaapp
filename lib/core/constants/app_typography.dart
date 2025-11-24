import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Application typography system
///
/// All text styles are defined according to the CHILD_PROTECTION_DESIGN.md
/// specifications using Google Fonts.
///
/// Font Families:
/// - Poppins: Headings (friendly, rounded)
/// - Nunito Sans: Body text (clean, readable)
class AppTypography {
  // Private constructor to prevent instantiation
  AppTypography._();

  // ============================================================================
  // HEADINGS (Poppins)
  // ============================================================================

  /// Heading 1 - Largest heading
  ///
  /// Usage: Page titles, main headings
  /// Size: 28px, Weight: 700 (Bold)
  static TextStyle h1 = GoogleFonts.poppins(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.textDark,
    height: 1.3,
  );

  /// Heading 2 - Section heading
  ///
  /// Usage: Section titles, important headings
  /// Size: 22px, Weight: 600 (SemiBold)
  static TextStyle h2 = GoogleFonts.poppins(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.3,
  );

  /// Heading 3 - Subsection heading
  ///
  /// Usage: Subsection titles, card titles
  /// Size: 18px, Weight: 600 (SemiBold)
  static TextStyle h3 = GoogleFonts.poppins(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.textDark,
    height: 1.4,
  );

  /// Heading 4 - Small heading
  ///
  /// Usage: Small titles, list item headers
  /// Size: 16px, Weight: 500 (Medium)
  static TextStyle h4 = GoogleFonts.poppins(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.4,
  );

  /// Heading 5 - Extra small heading
  ///
  /// Usage: Small labels, category names
  /// Size: 14px, Weight: 500 (Medium)
  static TextStyle h5 = GoogleFonts.poppins(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.4,
  );

  /// Heading 6 - Smallest heading
  ///
  /// Usage: Tiny labels, badges
  /// Size: 12px, Weight: 500 (Medium)
  static TextStyle h6 = GoogleFonts.poppins(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.textDark,
    height: 1.4,
  );

  // ============================================================================
  // BODY TEXT (Nunito Sans)
  // ============================================================================

  /// Body 1 - Primary body text
  ///
  /// Usage: Paragraphs, main content, descriptions
  /// Size: 16px, Weight: 400 (Regular), Line Height: 1.5
  static TextStyle body1 = GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 1.5,
  );

  /// Body 2 - Secondary body text
  ///
  /// Usage: Secondary content, smaller paragraphs
  /// Size: 14px, Weight: 400 (Regular), Line Height: 1.5
  static TextStyle body2 = GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.textMedium,
    height: 1.5,
  );

  /// Caption - Small text
  ///
  /// Usage: Captions, timestamps, metadata, hints
  /// Size: 12px, Weight: 400 (Regular)
  static TextStyle caption = GoogleFonts.nunitoSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.4,
  );

  /// Overline - Uppercase small text
  ///
  /// Usage: Labels, categories, tags
  /// Size: 10px, Weight: 500 (Medium), Uppercase
  static TextStyle overline = GoogleFonts.nunitoSans(
    fontSize: 10,
    fontWeight: FontWeight.w500,
    color: AppColors.textLight,
    height: 1.4,
    letterSpacing: 0.5,
  );

  // ============================================================================
  // BUTTON TEXT
  // ============================================================================

  /// Button text - Primary button style
  ///
  /// Usage: Button labels, CTAs
  /// Size: 16px, Weight: 600 (SemiBold)
  static TextStyle button = GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.cardWhite,
    height: 1.2,
  );

  /// Button text - Small button style
  ///
  /// Usage: Small buttons, compact CTAs
  /// Size: 14px, Weight: 600 (SemiBold)
  static TextStyle buttonSmall = GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.cardWhite,
    height: 1.2,
  );

  // ============================================================================
  // INPUT TEXT
  // ============================================================================

  /// Input text - Text field content
  ///
  /// Usage: Text input fields, form fields
  /// Size: 16px, Weight: 400 (Regular)
  static TextStyle input = GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textDark,
    height: 1.5,
  );

  /// Input hint - Text field placeholder
  ///
  /// Usage: Placeholder text, hints
  /// Size: 16px, Weight: 400 (Regular)
  static TextStyle inputHint = GoogleFonts.nunitoSans(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.textLight,
    height: 1.5,
  );

  /// Input label - Text field label
  ///
  /// Usage: Form labels, field names
  /// Size: 14px, Weight: 500 (Medium)
  static TextStyle inputLabel = GoogleFonts.nunitoSans(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textMedium,
    height: 1.4,
  );

  /// Input error - Error message text
  ///
  /// Usage: Validation errors, error messages
  /// Size: 12px, Weight: 400 (Regular)
  static TextStyle inputError = GoogleFonts.nunitoSans(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.error,
    height: 1.4,
  );

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get a text style with custom color
  static TextStyle withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  /// Get a text style with custom weight
  static TextStyle withWeight(TextStyle style, FontWeight weight) {
    return style.copyWith(fontWeight: weight);
  }

  /// Get a text style with custom size
  static TextStyle withSize(TextStyle style, double size) {
    return style.copyWith(fontSize: size);
  }

  /// Get a text style with custom height
  static TextStyle withHeight(TextStyle style, double height) {
    return style.copyWith(height: height);
  }

  /// Make a text style bold
  static TextStyle bold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w700);
  }

  /// Make a text style semi-bold
  static TextStyle semiBold(TextStyle style) {
    return style.copyWith(fontWeight: FontWeight.w600);
  }

  /// Make a text style italic
  static TextStyle italic(TextStyle style) {
    return style.copyWith(fontStyle: FontStyle.italic);
  }

  /// Make a text style underlined
  static TextStyle underline(TextStyle style) {
    return style.copyWith(decoration: TextDecoration.underline);
  }

  /// Get text theme for MaterialApp
  ///
  /// Returns a complete TextTheme configured with app typography
  static TextTheme getTextTheme() {
    return TextTheme(
      displayLarge: h1,
      displayMedium: h2,
      displaySmall: h3,
      headlineMedium: h3,
      headlineSmall: h4,
      titleLarge: h3,
      titleMedium: h4,
      titleSmall: h5,
      bodyLarge: body1,
      bodyMedium: body2,
      bodySmall: caption,
      labelLarge: button,
      labelMedium: buttonSmall,
      labelSmall: caption,
    );
  }
}
