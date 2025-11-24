import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';
import '../constants/app_typography.dart';
import '../constants/app_dimensions.dart';

/// Application theme configuration
///
/// Centralizes all theme settings using Material 3 design system
/// and integrates our custom design constants (colors, typography, dimensions).
class AppTheme {
  // Private constructor to prevent instantiation
  AppTheme._();

  // ============================================================================
  // LIGHT THEME
  // ============================================================================

  /// Get the light theme configuration
  static ThemeData get lightTheme {
    return ThemeData(
      // ========================================================================
      // Material 3
      // ========================================================================
      useMaterial3: true,

      // ========================================================================
      // Color Scheme
      // ========================================================================
      colorScheme: ColorScheme.light(
        primary: AppColors.unicefBlue,
        onPrimary: AppColors.cardWhite,
        secondary: AppColors.softBlue,
        onSecondary: AppColors.textDark,
        tertiary: AppColors.pastelPurple,
        onTertiary: AppColors.textDark,
        error: AppColors.error,
        onError: AppColors.cardWhite,
        surface: AppColors.cardWhite,
        onSurface: AppColors.textDark,
        surfaceContainerHighest: AppColors.surfaceGray,
        outline: AppColors.textLight,
        outlineVariant: AppColors.textLight,
      ),

      // ========================================================================
      // Scaffold
      // ========================================================================
      scaffoldBackgroundColor: AppColors.background,

      // ========================================================================
      // App Bar
      // ========================================================================
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.unicefBlue,
        foregroundColor: AppColors.cardWhite,
        elevation: AppDimensions.elevationMd,
        centerTitle: false,
        titleTextStyle: AppTypography.h3.copyWith(
          color: AppColors.cardWhite,
        ),
        iconTheme: const IconThemeData(
          color: AppColors.cardWhite,
          size: AppDimensions.iconMd,
        ),
        systemOverlayStyle: SystemUiOverlayStyle.light,
      ),

      // ========================================================================
      // Text Theme
      // ========================================================================
      textTheme: AppTypography.getTextTheme(),

      // ========================================================================
      // Card Theme
      // ========================================================================
      cardTheme: CardThemeData(
        color: AppColors.cardWhite,
        elevation: AppDimensions.elevationMd,
        shadowColor: AppColors.cardShadow,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusExtraLarge,
        ),
        margin: AppDimensions.all(AppDimensions.spaceMd),
      ),

      // ========================================================================
      // Elevated Button Theme
      // ========================================================================
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.unicefBlue,
          foregroundColor: AppColors.cardWhite,
          elevation: AppDimensions.elevationSm,
          padding: AppDimensions.buttonPadding,
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.buttonHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.radiusMedium,
          ),
          textStyle: AppTypography.button,
        ),
      ),

      // ========================================================================
      // Outlined Button Theme
      // ========================================================================
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.unicefBlue,
          side: const BorderSide(
            color: AppColors.unicefBlue,
            width: AppDimensions.borderWidth,
          ),
          padding: AppDimensions.buttonPadding,
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.buttonHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.radiusMedium,
          ),
          textStyle: AppTypography.button.copyWith(
            color: AppColors.unicefBlue,
          ),
        ),
      ),

      // ========================================================================
      // Text Button Theme
      // ========================================================================
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.unicefBlue,
          padding: AppDimensions.buttonPadding,
          minimumSize: const Size(
            AppDimensions.minTouchTarget,
            AppDimensions.buttonHeight,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppDimensions.radiusMedium,
          ),
          textStyle: AppTypography.button.copyWith(
            color: AppColors.unicefBlue,
          ),
        ),
      ),

      // ========================================================================
      // Floating Action Button Theme
      // ========================================================================
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.unicefBlue,
        foregroundColor: AppColors.cardWhite,
        elevation: AppDimensions.elevationLg,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusMedium,
        ),
      ),

      // ========================================================================
      // Input Decoration Theme
      // ========================================================================
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceGray,
        contentPadding: AppDimensions.inputPaddingInsets,
        // Border when not focused
        border: OutlineInputBorder(
          borderRadius: AppDimensions.radiusMedium,
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppDimensions.radiusMedium,
          borderSide: BorderSide.none,
        ),
        // Border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: AppDimensions.radiusMedium,
          borderSide: const BorderSide(
            color: AppColors.unicefBlue,
            width: AppDimensions.borderWidth,
          ),
        ),
        // Border when error
        errorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.radiusMedium,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidth,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppDimensions.radiusMedium,
          borderSide: const BorderSide(
            color: AppColors.error,
            width: AppDimensions.borderWidth,
          ),
        ),
        // Text styles
        hintStyle: AppTypography.inputHint,
        labelStyle: AppTypography.inputLabel,
        errorStyle: AppTypography.inputError,
        // Constraints
        constraints: const BoxConstraints(
          minHeight: AppDimensions.inputHeight,
        ),
      ),

      // ========================================================================
      // Icon Theme
      // ========================================================================
      iconTheme: const IconThemeData(
        color: AppColors.textDark,
        size: AppDimensions.iconMd,
      ),

      // ========================================================================
      // Divider Theme
      // ========================================================================
      dividerTheme: const DividerThemeData(
        color: AppColors.textLight,
        thickness: AppDimensions.dividerThickness,
        space: AppDimensions.spaceMd,
      ),

      // ========================================================================
      // Chip Theme
      // ========================================================================
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceGray,
        selectedColor: AppColors.unicefBlue,
        disabledColor: AppColors.textLight,
        labelStyle: AppTypography.body2,
        padding: AppDimensions.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusSmall,
        ),
      ),

      // ========================================================================
      // Dialog Theme
      // ========================================================================
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.cardWhite,
        elevation: AppDimensions.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusLarge,
        ),
        titleTextStyle: AppTypography.h3,
        contentTextStyle: AppTypography.body1,
      ),

      // ========================================================================
      // Bottom Sheet Theme
      // ========================================================================
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: AppColors.cardWhite,
        elevation: AppDimensions.elevationXl,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppDimensions.radiusXl),
          ),
        ),
      ),

      // ========================================================================
      // Snackbar Theme
      // ========================================================================
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.textDark,
        contentTextStyle: AppTypography.body2.copyWith(
          color: AppColors.cardWhite,
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusSmall,
        ),
      ),

      // ========================================================================
      // List Tile Theme
      // ========================================================================
      listTileTheme: ListTileThemeData(
        contentPadding: AppDimensions.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        iconColor: AppColors.textMedium,
        textColor: AppColors.textDark,
        titleTextStyle: AppTypography.body1,
        subtitleTextStyle: AppTypography.body2,
        minLeadingWidth: AppDimensions.iconLg,
      ),

      // ========================================================================
      // Switch Theme
      // ========================================================================
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.cardWhite;
          }
          return AppColors.textLight;
        }),
        trackColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.unicefBlue;
          }
          return AppColors.surfaceGray;
        }),
      ),

      // ========================================================================
      // Checkbox Theme
      // ========================================================================
      checkboxTheme: CheckboxThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.unicefBlue;
          }
          return AppColors.cardWhite;
        }),
        checkColor: WidgetStateProperty.all(AppColors.cardWhite),
        shape: RoundedRectangleBorder(
          borderRadius: AppDimensions.radiusSmall,
        ),
      ),

      // ========================================================================
      // Radio Theme
      // ========================================================================
      radioTheme: RadioThemeData(
        fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppColors.unicefBlue;
          }
          return AppColors.textLight;
        }),
      ),

      // ========================================================================
      // Progress Indicator Theme
      // ========================================================================
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.unicefBlue,
        circularTrackColor: AppColors.surfaceGray,
        linearTrackColor: AppColors.surfaceGray,
      ),
    );
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Get a BoxShadow for cards
  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];

  /// Get a BoxShadow for elevated elements
  static List<BoxShadow> get elevatedShadow => [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 12,
          offset: const Offset(0, 6),
        ),
      ];

  /// Get a BoxShadow for large modals
  static List<BoxShadow> get modalShadow => [
        BoxShadow(
          color: AppColors.cardShadow,
          blurRadius: 16,
          offset: const Offset(0, 8),
        ),
      ];
}
