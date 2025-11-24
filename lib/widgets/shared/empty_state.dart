import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';
import 'app_button.dart';

/// Empty State Widget
///
/// Reusable empty state component for displaying when no data is available.
/// Provides a user-friendly message with optional action button.
///
/// Features:
/// - Icon or illustration
/// - Headline and description text
/// - Optional action button
/// - Pre-built variants for common scenarios
/// - Customizable styling
/// - Design system integration
///
/// Example:
/// ```dart
/// EmptyState(
///   icon: Icons.inbox_outlined,
///   headline: 'No messages',
///   description: 'You don\'t have any messages yet',
/// )
///
/// EmptyState.noData(
///   onAction: () => loadData(),
/// )
/// ```
class EmptyState extends StatelessWidget {
  /// Icon to display
  final IconData? icon;

  /// Custom widget (overrides icon)
  final Widget? customIcon;

  /// Headline text
  final String headline;

  /// Description text
  final String? description;

  /// Action button text
  final String? actionText;

  /// Action button callback
  final VoidCallback? onAction;

  /// Icon size
  final double iconSize;

  /// Icon color
  final Color? iconColor;

  /// Background color for icon circle
  final Color? iconBackgroundColor;

  /// Padding around the empty state
  final EdgeInsets? padding;

  /// Maximum width for text content
  final double? maxWidth;

  const EmptyState({
    super.key,
    this.icon,
    this.customIcon,
    required this.headline,
    this.description,
    this.actionText,
    this.onAction,
    this.iconSize = 64,
    this.iconColor,
    this.iconBackgroundColor,
    this.padding,
    this.maxWidth = 320,
  }) : assert(
          icon != null || customIcon != null,
          'Either icon or customIcon must be provided',
        );

  /// Create a "no data" empty state
  factory EmptyState.noData({
    Key? key,
    String? headline,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.inbox_outlined,
      headline: headline ?? 'No Data Available',
      description: description ?? 'There is no data to display at the moment.',
      actionText: actionText,
      onAction: onAction,
      iconColor: AppColors.textLight,
      iconBackgroundColor: AppColors.surfaceGray,
    );
  }

  /// Create a "no results" empty state (for search/filters)
  factory EmptyState.noResults({
    Key? key,
    String? headline,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.search_off_outlined,
      headline: headline ?? 'No Results Found',
      description: description ??
          'We couldn\'t find any results matching your criteria. Try adjusting your filters.',
      actionText: actionText ?? 'Clear Filters',
      onAction: onAction,
      iconColor: AppColors.textLight,
      iconBackgroundColor: AppColors.surfaceGray,
    );
  }

  /// Create an "error" empty state
  factory EmptyState.error({
    Key? key,
    String? headline,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.error_outline,
      headline: headline ?? 'Something Went Wrong',
      description:
          description ?? 'An error occurred while loading data. Please try again.',
      actionText: actionText ?? 'Retry',
      onAction: onAction,
      iconColor: AppColors.error,
      iconBackgroundColor: AppColors.error.withValues(alpha: 0.1),
    );
  }

  /// Create a "no connection" empty state
  factory EmptyState.noConnection({
    Key? key,
    String? headline,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.wifi_off_outlined,
      headline: headline ?? 'No Internet Connection',
      description: description ??
          'Please check your internet connection and try again.',
      actionText: actionText ?? 'Retry',
      onAction: onAction,
      iconColor: AppColors.warning,
      iconBackgroundColor: AppColors.warning.withValues(alpha: 0.1),
    );
  }

  /// Create a "coming soon" empty state
  factory EmptyState.comingSoon({
    Key? key,
    String? headline,
    String? description,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.schedule_outlined,
      headline: headline ?? 'Coming Soon',
      description:
          description ?? 'This feature is under development and will be available soon.',
      iconColor: AppColors.info,
      iconBackgroundColor: AppColors.info.withValues(alpha: 0.1),
    );
  }

  /// Create a "permission denied" empty state
  factory EmptyState.permissionDenied({
    Key? key,
    String? headline,
    String? description,
    String? actionText,
    VoidCallback? onAction,
  }) {
    return EmptyState(
      key: key,
      icon: Icons.lock_outline,
      headline: headline ?? 'Access Denied',
      description: description ??
          'You don\'t have permission to access this content.',
      actionText: actionText,
      onAction: onAction,
      iconColor: AppColors.warning,
      iconBackgroundColor: AppColors.warning.withValues(alpha: 0.1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLg,
              vertical: AppDimensions.spaceXl,
            ),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth ?? 320),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon or custom widget
              _buildIcon(),
              const SizedBox(height: AppDimensions.spaceLg),

              // Headline
              Text(
                headline,
                style: AppTypography.h3.copyWith(
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceSm),

              // Description
              if (description != null) ...[
                Text(
                  description!,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.textMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spaceLg),
              ],

              // Action button
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: AppDimensions.spaceMd),
                AppButton.primary(
                  text: actionText,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  /// Build icon widget
  Widget _buildIcon() {
    // Use custom widget if provided
    if (customIcon != null) {
      return customIcon!;
    }

    // Build icon with background circle
    return Container(
      width: iconSize + 48,
      height: iconSize + 48,
      decoration: BoxDecoration(
        color: iconBackgroundColor ?? AppColors.surfaceGray,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Icon(
          icon,
          size: iconSize,
          color: iconColor ?? AppColors.textLight,
        ),
      ),
    );
  }
}

/// Empty State with Image
///
/// Similar to EmptyState but displays an image instead of an icon.
/// Useful for more illustrative empty states.
class EmptyStateWithImage extends StatelessWidget {
  /// Image asset path or URL
  final String imagePath;

  /// Whether image is from network
  final bool isNetworkImage;

  /// Image width
  final double imageWidth;

  /// Image height
  final double imageHeight;

  /// Headline text
  final String headline;

  /// Description text
  final String? description;

  /// Action button text
  final String? actionText;

  /// Action button callback
  final VoidCallback? onAction;

  /// Padding around the empty state
  final EdgeInsets? padding;

  /// Maximum width for text content
  final double? maxWidth;

  const EmptyStateWithImage({
    super.key,
    required this.imagePath,
    this.isNetworkImage = false,
    this.imageWidth = 200,
    this.imageHeight = 200,
    required this.headline,
    this.description,
    this.actionText,
    this.onAction,
    this.padding,
    this.maxWidth = 320,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceLg,
              vertical: AppDimensions.spaceXl,
            ),
        child: Container(
          constraints: BoxConstraints(maxWidth: maxWidth ?? 320),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              // Image
              SizedBox(
                width: imageWidth,
                height: imageHeight,
                child: isNetworkImage
                    ? Image.network(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            size: 64,
                            color: AppColors.textLight,
                          );
                        },
                      )
                    : Image.asset(
                        imagePath,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.image_not_supported_outlined,
                            size: 64,
                            color: AppColors.textLight,
                          );
                        },
                      ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Headline
              Text(
                headline,
                style: AppTypography.h3.copyWith(
                  color: AppColors.textDark,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppDimensions.spaceSm),

              // Description
              if (description != null) ...[
                Text(
                  description!,
                  style: AppTypography.body1.copyWith(
                    color: AppColors.textMedium,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppDimensions.spaceLg),
              ],

              // Action button
              if (actionText != null && onAction != null) ...[
                const SizedBox(height: AppDimensions.spaceMd),
                AppButton.primary(
                  text: actionText,
                  onPressed: onAction,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact Empty State
///
/// Smaller empty state for use within cards or sections.
/// Shows only icon and text, no action button.
class CompactEmptyState extends StatelessWidget {
  /// Icon to display
  final IconData icon;

  /// Message text
  final String message;

  /// Icon size
  final double iconSize;

  /// Icon color
  final Color? iconColor;

  /// Padding
  final EdgeInsets? padding;

  const CompactEmptyState({
    super.key,
    required this.icon,
    required this.message,
    this.iconSize = 40,
    this.iconColor,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? const EdgeInsets.all(AppDimensions.spaceLg),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: iconSize,
            color: iconColor ?? AppColors.textLight,
          ),
          const SizedBox(height: AppDimensions.spaceSm),
          Text(
            message,
            style: AppTypography.body2.copyWith(
              color: AppColors.textLight,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
