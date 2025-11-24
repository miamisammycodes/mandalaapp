import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// App Loading Indicator Widget
///
/// Reusable loading indicator components following the design system.
/// Supports circular and linear progress indicators with UNICEF blue color.
///
/// Features:
/// - Circular progress indicator
/// - Linear progress indicator
/// - Customizable sizes
/// - Overlay loading (full screen with backdrop)
/// - Design system color integration
///
/// Example:
/// ```dart
/// // Circular indicator
/// AppLoadingIndicator()
///
/// // Linear indicator
/// AppLoadingIndicator.linear()
///
/// // Custom size
/// AppLoadingIndicator(size: 32)
///
/// // Full screen overlay
/// AppLoadingIndicator.overlay(message: 'Loading...')
/// ```
class AppLoadingIndicator extends StatelessWidget {
  /// Loading indicator variant
  final LoadingVariant variant;

  /// Size of the indicator (for circular)
  final double? size;

  /// Stroke width
  final double? strokeWidth;

  /// Color of the indicator
  final Color? color;

  /// Message to display below indicator
  final String? message;

  const AppLoadingIndicator({
    super.key,
    this.variant = LoadingVariant.circular,
    this.size,
    this.strokeWidth,
    this.color,
    this.message,
  });

  /// Create a circular loading indicator
  factory AppLoadingIndicator.circular({
    Key? key,
    double? size,
    double? strokeWidth,
    Color? color,
    String? message,
  }) {
    return AppLoadingIndicator(
      key: key,
      variant: LoadingVariant.circular,
      size: size,
      strokeWidth: strokeWidth,
      color: color,
      message: message,
    );
  }

  /// Create a linear loading indicator
  factory AppLoadingIndicator.linear({
    Key? key,
    Color? color,
    String? message,
  }) {
    return AppLoadingIndicator(
      key: key,
      variant: LoadingVariant.linear,
      color: color,
      message: message,
    );
  }

  /// Create a full-screen overlay loading indicator
  factory AppLoadingIndicator.overlay({
    Key? key,
    String? message,
  }) {
    return AppLoadingIndicator(
      key: key,
      variant: LoadingVariant.overlay,
      message: message,
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (variant) {
      case LoadingVariant.circular:
        return _buildCircularIndicator();
      case LoadingVariant.linear:
        return _buildLinearIndicator();
      case LoadingVariant.overlay:
        return _buildOverlayIndicator();
    }
  }

  /// Build circular progress indicator
  Widget _buildCircularIndicator() {
    Widget indicator = SizedBox(
      width: size ?? 40,
      height: size ?? 40,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth ?? 3,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.unicefBlue,
        ),
      ),
    );

    // Add message if provided
    if (message != null) {
      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            message!,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Center(child: indicator);
  }

  /// Build linear progress indicator
  Widget _buildLinearIndicator() {
    Widget indicator = LinearProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(
        color ?? AppColors.unicefBlue,
      ),
      backgroundColor: AppColors.surfaceGray,
    );

    // Add message if provided
    if (message != null) {
      indicator = Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          indicator,
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            message!,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return indicator;
  }

  /// Build full-screen overlay indicator
  Widget _buildOverlayIndicator() {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Container(
          padding: const EdgeInsets.all(AppDimensions.spaceLg),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(
                width: 48,
                height: 48,
                child: CircularProgressIndicator(
                  strokeWidth: 4,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    AppColors.unicefBlue,
                  ),
                ),
              ),
              if (message != null) ...[
                const SizedBox(height: AppDimensions.spaceMd),
                Text(
                  message!,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Centered loading indicator
///
/// Convenience widget for displaying a centered loading indicator
/// with optional message. Useful for loading states in lists or screens.
class CenteredLoading extends StatelessWidget {
  /// Loading message
  final String? message;

  /// Indicator size
  final double? size;

  const CenteredLoading({
    super.key,
    this.message,
    this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AppLoadingIndicator.circular(
        size: size,
        message: message,
      ),
    );
  }
}

/// Loading overlay widget
///
/// Shows a full-screen loading overlay that blocks user interaction.
/// Use with Navigator or Stack to display over other content.
///
/// Example:
/// ```dart
/// // Show overlay
/// showDialog(
///   context: context,
///   barrierDismissible: false,
///   builder: (context) => LoadingOverlay(message: 'Submitting...'),
/// );
///
/// // Hide overlay
/// Navigator.pop(context);
/// ```
class LoadingOverlay extends StatelessWidget {
  /// Loading message
  final String? message;

  const LoadingOverlay({
    super.key,
    this.message,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // Prevent back button dismiss
      child: AppLoadingIndicator.overlay(message: message),
    );
  }

  /// Show loading overlay
  static void show(BuildContext context, {String? message}) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => LoadingOverlay(message: message),
    );
  }

  /// Hide loading overlay
  static void hide(BuildContext context) {
    Navigator.of(context).pop();
  }
}

// ==============================================================================
// ENUMS
// ==============================================================================

/// Loading indicator variants
enum LoadingVariant {
  /// Circular progress indicator
  circular,

  /// Linear progress indicator
  linear,

  /// Full-screen overlay
  overlay,
}
