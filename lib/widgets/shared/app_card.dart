import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_shadows.dart';

/// App Card Widget
///
/// Reusable card container component following the design system.
/// Supports various card styles, shadows, and interactive features.
///
/// Features:
/// - Basic card with standard styling
/// - Featured card with larger radius and prominent styling
/// - Interactive card with tap feedback and ripple effects
/// - Customizable padding, margin, and shadows
/// - Optional header image support
/// - Design system integration
///
/// Example:
/// ```dart
/// AppCard(
///   child: Text('Card content'),
/// )
///
/// AppCard.featured(
///   child: Column(
///     children: [
///       Text('Featured content'),
///     ],
///   ),
/// )
///
/// AppCard.interactive(
///   onTap: () => print('Tapped'),
///   child: ListTile(
///     title: Text('Tap me'),
///   ),
/// )
/// ```
class AppCard extends StatelessWidget {
  /// Card content
  final Widget child;

  /// Card variant style
  final AppCardVariant variant;

  /// Tap callback (makes card interactive)
  final VoidCallback? onTap;

  /// Long press callback
  final VoidCallback? onLongPress;

  /// Card padding
  final EdgeInsets? padding;

  /// Card margin
  final EdgeInsets? margin;

  /// Card width
  final double? width;

  /// Card height
  final double? height;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final double? borderRadius;

  /// Shadow elevation
  final AppCardElevation elevation;

  /// Border color (optional)
  final Color? borderColor;

  /// Border width
  final double? borderWidth;

  /// Clip behavior
  final Clip clipBehavior;

  const AppCard({
    super.key,
    required this.child,
    this.variant = AppCardVariant.basic,
    this.onTap,
    this.onLongPress,
    this.padding,
    this.margin,
    this.width,
    this.height,
    this.backgroundColor,
    this.borderRadius,
    this.elevation = AppCardElevation.medium,
    this.borderColor,
    this.borderWidth,
    this.clipBehavior = Clip.antiAlias,
  });

  /// Create a basic card with standard styling
  factory AppCard.basic({
    Key? key,
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    Color? backgroundColor,
    AppCardElevation elevation = AppCardElevation.medium,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.basic,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      elevation: elevation,
      child: child,
    );
  }

  /// Create a featured card with prominent styling
  factory AppCard.featured({
    Key? key,
    required Widget child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    Color? backgroundColor,
    AppCardElevation elevation = AppCardElevation.high,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.featured,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      elevation: elevation,
      child: child,
    );
  }

  /// Create an interactive card with tap feedback
  factory AppCard.interactive({
    Key? key,
    required Widget child,
    required VoidCallback onTap,
    VoidCallback? onLongPress,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    Color? backgroundColor,
    AppCardElevation elevation = AppCardElevation.medium,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.interactive,
      onTap: onTap,
      onLongPress: onLongPress,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      elevation: elevation,
      child: child,
    );
  }

  /// Create an outlined card with border
  factory AppCard.outlined({
    Key? key,
    required Widget child,
    VoidCallback? onTap,
    EdgeInsets? padding,
    EdgeInsets? margin,
    double? width,
    double? height,
    Color? backgroundColor,
    Color? borderColor,
    double borderWidth = 1.5,
  }) {
    return AppCard(
      key: key,
      variant: AppCardVariant.outlined,
      onTap: onTap,
      padding: padding,
      margin: margin,
      width: width,
      height: height,
      backgroundColor: backgroundColor,
      borderColor: borderColor,
      borderWidth: borderWidth,
      elevation: AppCardElevation.none,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // Get styling based on variant
    final cardStyle = _getCardStyle();

    // Determine if card is interactive
    final bool isInteractive = onTap != null || onLongPress != null;

    // Build card content
    Widget cardContent = Container(
      width: width,
      height: height,
      padding: padding ?? cardStyle.padding,
      decoration: BoxDecoration(
        color: backgroundColor ?? cardStyle.backgroundColor,
        borderRadius: BorderRadius.circular(
          borderRadius ?? cardStyle.borderRadius,
        ),
        boxShadow: _getShadows(),
        border: borderColor != null
            ? Border.all(
                color: borderColor!,
                width: borderWidth ?? 1.5,
              )
            : null,
      ),
      child: child,
    );

    // Wrap with Material for interactive cards
    if (isInteractive) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          onLongPress: onLongPress,
          borderRadius: BorderRadius.circular(
            borderRadius ?? cardStyle.borderRadius,
          ),
          child: cardContent,
        ),
      );
    }

    // Apply margin if provided
    if (margin != null) {
      cardContent = Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    // Apply clip behavior
    return ClipRRect(
      borderRadius: BorderRadius.circular(
        borderRadius ?? cardStyle.borderRadius,
      ),
      clipBehavior: clipBehavior,
      child: cardContent,
    );
  }

  /// Get card styling based on variant
  _CardStyle _getCardStyle() {
    switch (variant) {
      case AppCardVariant.basic:
        return _CardStyle(
          backgroundColor: AppColors.cardWhite,
          borderRadius: AppDimensions.radiusMd,
          padding: EdgeInsets.all(AppDimensions.cardPadding),
        );

      case AppCardVariant.featured:
        return _CardStyle(
          backgroundColor: AppColors.cardWhite,
          borderRadius: AppDimensions.radiusXl,
          padding: EdgeInsets.all(AppDimensions.cardPaddingLarge),
        );

      case AppCardVariant.interactive:
        return _CardStyle(
          backgroundColor: AppColors.cardWhite,
          borderRadius: AppDimensions.radiusMd,
          padding: EdgeInsets.all(AppDimensions.cardPadding),
        );

      case AppCardVariant.outlined:
        return _CardStyle(
          backgroundColor: AppColors.cardWhite,
          borderRadius: AppDimensions.radiusMd,
          padding: EdgeInsets.all(AppDimensions.cardPadding),
        );
    }
  }

  /// Get shadows based on elevation
  List<BoxShadow>? _getShadows() {
    switch (elevation) {
      case AppCardElevation.none:
        return null;
      case AppCardElevation.low:
        return AppShadows.sm;
      case AppCardElevation.medium:
        return AppShadows.md;
      case AppCardElevation.high:
        return AppShadows.lg;
    }
  }
}

// ==============================================================================
// IMAGE CARD (Card with header image)
// ==============================================================================

/// Card with header image
///
/// Displays an image at the top of the card with content below.
/// Useful for news articles, content cards, etc.
class AppImageCard extends StatelessWidget {
  /// Header image URL or asset path
  final String imageUrl;

  /// Image height
  final double imageHeight;

  /// Image fit
  final BoxFit imageFit;

  /// Card content below image
  final Widget child;

  /// Tap callback
  final VoidCallback? onTap;

  /// Card padding (for content area)
  final EdgeInsets? padding;

  /// Card margin
  final EdgeInsets? margin;

  /// Card width
  final double? width;

  /// Background color
  final Color? backgroundColor;

  /// Border radius
  final double borderRadius;

  /// Shadow elevation
  final AppCardElevation elevation;

  const AppImageCard({
    super.key,
    required this.imageUrl,
    required this.child,
    this.imageHeight = 200,
    this.imageFit = BoxFit.cover,
    this.onTap,
    this.padding,
    this.margin,
    this.width,
    this.backgroundColor,
    this.borderRadius = AppDimensions.radiusXl,
    this.elevation = AppCardElevation.medium,
  });

  @override
  Widget build(BuildContext context) {
    Widget cardContent = Container(
      width: width,
      decoration: BoxDecoration(
        color: backgroundColor ?? AppColors.cardWhite,
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: _getShadows(),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header image
          ClipRRect(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(borderRadius),
              topRight: Radius.circular(borderRadius),
            ),
            child: Image.network(
              imageUrl,
              height: imageHeight,
              width: double.infinity,
              fit: imageFit,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: imageHeight,
                  color: AppColors.surfaceGray,
                  child: const Center(
                    child: Icon(
                      Icons.image_outlined,
                      size: 48,
                      color: AppColors.textLight,
                    ),
                  ),
                );
              },
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return Container(
                  height: imageHeight,
                  color: AppColors.surfaceGray,
                  child: const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.unicefBlue,
                    ),
                  ),
                );
              },
            ),
          ),

          // Content area
          Padding(
            padding: padding ?? EdgeInsets.all(AppDimensions.cardPadding),
            child: child,
          ),
        ],
      ),
    );

    // Wrap with InkWell if interactive
    if (onTap != null) {
      cardContent = Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(borderRadius),
          child: cardContent,
        ),
      );
    }

    // Apply margin
    if (margin != null) {
      cardContent = Padding(
        padding: margin!,
        child: cardContent,
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      clipBehavior: Clip.antiAlias,
      child: cardContent,
    );
  }

  /// Get shadows based on elevation
  List<BoxShadow>? _getShadows() {
    switch (elevation) {
      case AppCardElevation.none:
        return null;
      case AppCardElevation.low:
        return AppShadows.sm;
      case AppCardElevation.medium:
        return AppShadows.md;
      case AppCardElevation.high:
        return AppShadows.lg;
    }
  }
}

// ==============================================================================
// ENUMS & HELPER CLASSES
// ==============================================================================

/// Card style variants
enum AppCardVariant {
  /// Basic card with standard styling (12px radius)
  basic,

  /// Featured card with prominent styling (20px radius, larger padding)
  featured,

  /// Interactive card with tap feedback
  interactive,

  /// Outlined card with border, no shadow
  outlined,
}

/// Card elevation levels
enum AppCardElevation {
  /// No shadow
  none,

  /// Small shadow
  low,

  /// Medium shadow (default)
  medium,

  /// Large shadow
  high,
}

/// Internal card styling configuration
class _CardStyle {
  final Color backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;

  const _CardStyle({
    required this.backgroundColor,
    required this.borderRadius,
    required this.padding,
  });
}
