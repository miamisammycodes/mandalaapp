import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// App Button Widget
///
/// Reusable button component following the design system.
/// Supports multiple variants, loading states, and disabled styling.
///
/// Variants:
/// - Primary: Filled button with UNICEF blue background
/// - Secondary: Outlined button with UNICEF blue border
/// - Text: Text-only button without background
/// - Icon: Icon button with optional background
///
/// Features:
/// - Loading state with spinner
/// - Disabled state with reduced opacity
/// - Consistent sizing from design system
/// - Customizable colors and styles
///
/// Example:
/// ```dart
/// AppButton(
///   text: 'Submit',
///   onPressed: () => print('Pressed'),
///   variant: AppButtonVariant.primary,
///   isLoading: false,
/// )
/// ```
class AppButton extends StatelessWidget {
  /// Button text label
  final String? text;

  /// Button icon
  final IconData? icon;

  /// Custom child widget (overrides text and icon)
  final Widget? child;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button variant style
  final AppButtonVariant variant;

  /// Show loading spinner
  final bool isLoading;

  /// Button width (null for flexible width)
  final double? width;

  /// Button height (defaults to design system height)
  final double? height;

  /// Icon position (for buttons with both text and icon)
  final IconPosition iconPosition;

  /// Custom background color (overrides variant color)
  final Color? backgroundColor;

  /// Custom text color (overrides variant color)
  final Color? textColor;

  /// Custom border color (for secondary variant)
  final Color? borderColor;

  /// Button size (affects padding and text size)
  final AppButtonSize size;

  const AppButton({
    super.key,
    this.text,
    this.icon,
    this.child,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.isLoading = false,
    this.width,
    this.height,
    this.iconPosition = IconPosition.left,
    this.backgroundColor,
    this.textColor,
    this.borderColor,
    this.size = AppButtonSize.medium,
  }) : assert(
          text != null || icon != null || child != null,
          'Button must have text, icon, or child widget',
        );

  /// Create a primary button (most common use case)
  factory AppButton.primary({
    Key? key,
    String? text,
    IconData? icon,
    Widget? child,
    required VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: AppButtonVariant.primary,
      isLoading: isLoading,
      width: width,
      size: size,
      child: child,
    );
  }

  /// Create a secondary button
  factory AppButton.secondary({
    Key? key,
    String? text,
    IconData? icon,
    Widget? child,
    required VoidCallback? onPressed,
    bool isLoading = false,
    double? width,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: AppButtonVariant.secondary,
      isLoading: isLoading,
      width: width,
      size: size,
      child: child,
    );
  }

  /// Create a text button
  factory AppButton.text({
    Key? key,
    String? text,
    IconData? icon,
    Widget? child,
    required VoidCallback? onPressed,
    bool isLoading = false,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      key: key,
      text: text,
      icon: icon,
      onPressed: onPressed,
      variant: AppButtonVariant.text,
      isLoading: isLoading,
      size: size,
      child: child,
    );
  }

  /// Create an icon button
  factory AppButton.icon({
    Key? key,
    required IconData icon,
    required VoidCallback? onPressed,
    bool isLoading = false,
    Color? backgroundColor,
    Color? iconColor,
    AppButtonSize size = AppButtonSize.medium,
  }) {
    return AppButton(
      key: key,
      icon: icon,
      onPressed: onPressed,
      variant: AppButtonVariant.icon,
      isLoading: isLoading,
      backgroundColor: backgroundColor,
      textColor: iconColor,
      size: size,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine if button is disabled
    final bool isDisabled = onPressed == null || isLoading;

    // Get colors based on variant
    final ButtonColors colors = _getColors(isDisabled);

    // Get sizing based on size
    final ButtonSizing sizing = _getSizing();

    return SizedBox(
      width: width,
      height: height ?? sizing.height,
      child: variant == AppButtonVariant.text
          ? _buildTextButton(colors, sizing, isDisabled)
          : variant == AppButtonVariant.secondary
              ? _buildSecondaryButton(colors, sizing, isDisabled)
              : _buildPrimaryButton(colors, sizing, isDisabled),
    );
  }

  /// Build primary/filled button
  Widget _buildPrimaryButton(
    ButtonColors colors,
    ButtonSizing sizing,
    bool isDisabled,
  ) {
    return ElevatedButton(
      onPressed: isDisabled ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.background,
        foregroundColor: colors.foreground,
        disabledBackgroundColor: colors.disabledBackground,
        disabledForegroundColor: colors.disabledForeground,
        elevation: 0,
        shadowColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizing.borderRadius),
        ),
        padding: sizing.padding,
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(colors, sizing),
    );
  }

  /// Build secondary/outlined button
  Widget _buildSecondaryButton(
    ButtonColors colors,
    ButtonSizing sizing,
    bool isDisabled,
  ) {
    return OutlinedButton(
      onPressed: isDisabled ? null : onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: colors.foreground,
        disabledForegroundColor: colors.disabledForeground,
        side: BorderSide(
          color: isDisabled
              ? colors.disabledBorder ?? AppColors.textLight.withValues(alpha: 0.3)
              : colors.border ?? AppColors.unicefBlue,
          width: 1.5,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizing.borderRadius),
        ),
        padding: sizing.padding,
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(colors, sizing),
    );
  }

  /// Build text button
  Widget _buildTextButton(
    ButtonColors colors,
    ButtonSizing sizing,
    bool isDisabled,
  ) {
    return TextButton(
      onPressed: isDisabled ? null : onPressed,
      style: TextButton.styleFrom(
        foregroundColor: colors.foreground,
        disabledForegroundColor: colors.disabledForeground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(sizing.borderRadius),
        ),
        padding: sizing.padding,
        minimumSize: Size.zero,
      ),
      child: _buildButtonContent(colors, sizing),
    );
  }

  /// Build button content (text, icon, loading spinner, or custom child)
  Widget _buildButtonContent(ButtonColors colors, ButtonSizing sizing) {
    // Show loading spinner if isLoading is true
    if (isLoading) {
      return SizedBox(
        width: sizing.loadingIndicatorSize,
        height: sizing.loadingIndicatorSize,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(colors.foreground),
        ),
      );
    }

    // Use custom child if provided
    if (child != null) {
      return child!;
    }

    // Build icon-only button
    if (text == null && icon != null) {
      return Icon(icon, size: sizing.iconSize, color: colors.foreground);
    }

    // Build text-only button
    if (text != null && icon == null) {
      return Text(
        text!,
        style: TextStyle(
          fontSize: sizing.fontSize,
          fontWeight: FontWeight.w600,
          color: colors.foreground,
        ),
      );
    }

    // Build button with both text and icon
    if (text != null && icon != null) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (iconPosition == IconPosition.left) ...[
            Icon(icon, size: sizing.iconSize, color: colors.foreground),
            SizedBox(width: sizing.iconTextSpacing),
          ],
          Text(
            text!,
            style: TextStyle(
              fontSize: sizing.fontSize,
              fontWeight: FontWeight.w600,
              color: colors.foreground,
            ),
          ),
          if (iconPosition == IconPosition.right) ...[
            SizedBox(width: sizing.iconTextSpacing),
            Icon(icon, size: sizing.iconSize, color: colors.foreground),
          ],
        ],
      );
    }

    // Fallback (should not reach here due to assertion)
    return const SizedBox.shrink();
  }

  /// Get colors based on variant and disabled state
  ButtonColors _getColors(bool isDisabled) {
    switch (variant) {
      case AppButtonVariant.primary:
      case AppButtonVariant.icon:
        // When loading, keep the original background color with slight opacity
        final bgColor = backgroundColor ?? AppColors.unicefBlue;
        return ButtonColors(
          background: bgColor,
          foreground: textColor ?? Colors.white,
          disabledBackground: isLoading 
              ? bgColor.withValues(alpha: 0.8) // Keep visible during loading
              : backgroundColor?.withValues(alpha: 0.5) ?? AppColors.surfaceGray,
          disabledForeground: Colors.white,
        );

      case AppButtonVariant.secondary:
        final fgColor = textColor ?? AppColors.unicefBlue;
        final bdColor = borderColor ?? AppColors.unicefBlue;
        return ButtonColors(
          background: Colors.transparent,
          foreground: fgColor,
          border: bdColor,
          disabledForeground: isLoading ? fgColor : AppColors.textLight,
          disabledBorder: isLoading 
              ? bdColor.withValues(alpha: 0.8) 
              : AppColors.textLight.withValues(alpha: 0.3),
        );

      case AppButtonVariant.text:
        final fgColor = textColor ?? AppColors.unicefBlue;
        return ButtonColors(
          background: Colors.transparent,
          foreground: fgColor,
          disabledForeground: isLoading ? fgColor : AppColors.textLight,
        );
    }
  }

  /// Get sizing based on button size
  ButtonSizing _getSizing() {
    switch (size) {
      case AppButtonSize.small:
        return ButtonSizing(
          height: 36,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceMd,
            vertical: AppDimensions.spaceSm,
          ),
          fontSize: 14,
          iconSize: 18,
          borderRadius: AppDimensions.radiusSm,
          iconTextSpacing: AppDimensions.spaceSm,
          loadingIndicatorSize: 16,
        );

      case AppButtonSize.medium:
        return ButtonSizing(
          height: AppDimensions.buttonHeight,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceLg,
            vertical: AppDimensions.spaceMd,
          ),
          fontSize: 16,
          iconSize: 20,
          borderRadius: AppDimensions.radiusMd,
          iconTextSpacing: AppDimensions.spaceSm,
          loadingIndicatorSize: 20,
        );

      case AppButtonSize.large:
        return ButtonSizing(
          height: 56,
          padding: EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceXl,
            vertical: AppDimensions.spaceLg,
          ),
          fontSize: 18,
          iconSize: 24,
          borderRadius: AppDimensions.radiusMd,
          iconTextSpacing: AppDimensions.spaceMd,
          loadingIndicatorSize: 24,
        );
    }
  }
}

// ==============================================================================
// BUTTON VARIANTS
// ==============================================================================

/// Button style variants
enum AppButtonVariant {
  /// Filled button with UNICEF blue background (default)
  primary,

  /// Outlined button with UNICEF blue border
  secondary,

  /// Text-only button without background
  text,

  /// Icon button with optional background
  icon,
}

// ==============================================================================
// BUTTON SIZES
// ==============================================================================

/// Button size options
enum AppButtonSize {
  /// Small button (36px height)
  small,

  /// Medium button (48px height, default)
  medium,

  /// Large button (56px height)
  large,
}

// ==============================================================================
// ICON POSITION
// ==============================================================================

/// Icon position relative to text
enum IconPosition {
  /// Icon on the left side of text
  left,

  /// Icon on the right side of text
  right,
}

// ==============================================================================
// HELPER CLASSES
// ==============================================================================

/// Button color configuration
class ButtonColors {
  final Color background;
  final Color foreground;
  final Color? border;
  final Color? disabledBackground;
  final Color? disabledForeground;
  final Color? disabledBorder;

  const ButtonColors({
    required this.background,
    required this.foreground,
    this.border,
    this.disabledBackground,
    this.disabledForeground,
    this.disabledBorder,
  });
}

/// Button sizing configuration
class ButtonSizing {
  final double height;
  final EdgeInsets padding;
  final double fontSize;
  final double iconSize;
  final double borderRadius;
  final double iconTextSpacing;
  final double loadingIndicatorSize;

  const ButtonSizing({
    required this.height,
    required this.padding,
    required this.fontSize,
    required this.iconSize,
    required this.borderRadius,
    required this.iconTextSpacing,
    required this.loadingIndicatorSize,
  });
}
