import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// Skeleton Loader Widget
///
/// Animated shimmer skeleton loaders for better perceived performance.
/// Displays placeholder content while actual data is loading.
///
/// Features:
/// - Shimmer animation effect
/// - Pre-built skeleton components (card, list, text)
/// - Customizable shapes and sizes
/// - Design system integration
///
/// Example:
/// ```dart
/// // Basic skeleton box
/// SkeletonLoader(
///   width: 100,
///   height: 100,
/// )
///
/// // Skeleton card
/// SkeletonCard()
///
/// // Skeleton list
/// SkeletonList(itemCount: 5)
/// ```
class SkeletonLoader extends StatefulWidget {
  /// Width of the skeleton
  final double? width;

  /// Height of the skeleton
  final double height;

  /// Border radius
  final double? borderRadius;

  /// Whether to animate
  final bool animate;

  const SkeletonLoader({
    super.key,
    this.width,
    required this.height,
    this.borderRadius,
    this.animate = true,
  });

  @override
  State<SkeletonLoader> createState() => _SkeletonLoaderState();
}

class _SkeletonLoaderState extends State<SkeletonLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _animation = Tween<double>(begin: -2, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          width: widget.width,
          height: widget.height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              widget.borderRadius ?? AppDimensions.radiusSm,
            ),
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: const [
                AppColors.surfaceGray,
                Color(0xFFE8EDF2), // Lighter gray
                AppColors.surfaceGray,
              ],
              stops: [
                0.0,
                0.5 + (_animation.value * 0.25),
                1.0,
              ],
            ),
          ),
        );
      },
    );
  }
}

// ==============================================================================
// SKELETON COMPONENTS
// ==============================================================================

/// Skeleton text line
///
/// Displays a skeleton placeholder for text content
class SkeletonText extends StatelessWidget {
  /// Width of the text line
  final double? width;

  /// Height of the text line
  final double height;

  const SkeletonText({
    super.key,
    this.width,
    this.height = 16,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: width,
      height: height,
      borderRadius: AppDimensions.radiusSm / 2,
    );
  }
}

/// Skeleton circle (for avatars)
///
/// Displays a circular skeleton placeholder
class SkeletonCircle extends StatelessWidget {
  /// Diameter of the circle
  final double size;

  const SkeletonCircle({
    super.key,
    this.size = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SkeletonLoader(
      width: size,
      height: size,
      borderRadius: size / 2,
    );
  }
}

/// Skeleton card
///
/// Pre-built skeleton for card-style content (news, articles, etc.)
class SkeletonCard extends StatelessWidget {
  /// Card margin
  final EdgeInsets? margin;

  /// Whether to include image placeholder
  final bool showImage;

  /// Image height
  final double imageHeight;

  const SkeletonCard({
    super.key,
    this.margin,
    this.showImage = true,
    this.imageHeight = 200,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        boxShadow: const [
          BoxShadow(
            color: AppColors.cardShadow,
            offset: Offset(0, 4),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder
          if (showImage)
            SkeletonLoader(
              height: imageHeight,
              borderRadius: AppDimensions.radiusXl,
            ),

          // Content area
          Padding(
            padding: const EdgeInsets.all(AppDimensions.cardPadding),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                const SkeletonText(width: double.infinity, height: 20),
                const SizedBox(height: AppDimensions.spaceSm),

                // Subtitle line 1
                const SkeletonText(width: double.infinity, height: 14),
                const SizedBox(height: AppDimensions.spaceXs),

                // Subtitle line 2
                const SkeletonText(width: 200, height: 14),
                const SizedBox(height: AppDimensions.spaceMd),

                // Footer (avatar + metadata)
                Row(
                  children: [
                    const SkeletonCircle(size: 32),
                    const SizedBox(width: AppDimensions.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SkeletonText(width: 100, height: 12),
                          SizedBox(height: AppDimensions.spaceXs),
                          SkeletonText(width: 80, height: 10),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton list item
///
/// Pre-built skeleton for list items with leading icon/avatar
class SkeletonListItem extends StatelessWidget {
  /// Show leading circle (avatar)
  final bool showLeading;

  /// Leading circle size
  final double leadingSize;

  /// Number of text lines
  final int lines;

  const SkeletonListItem({
    super.key,
    this.showLeading = true,
    this.leadingSize = 40,
    this.lines = 2,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceSm,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Leading avatar/icon
          if (showLeading) ...[
            SkeletonCircle(size: leadingSize),
            const SizedBox(width: AppDimensions.spaceMd),
          ],

          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < lines; i++) ...[
                  SkeletonText(
                    width: i == lines - 1 ? 150 : double.infinity,
                    height: i == 0 ? 16 : 14,
                  ),
                  if (i < lines - 1)
                    const SizedBox(height: AppDimensions.spaceXs),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Skeleton list
///
/// Pre-built skeleton for list views
class SkeletonList extends StatelessWidget {
  /// Number of skeleton items
  final int itemCount;

  /// Show leading circles
  final bool showLeading;

  /// Number of lines per item
  final int linesPerItem;

  const SkeletonList({
    super.key,
    this.itemCount = 5,
    this.showLeading = true,
    this.linesPerItem = 2,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itemCount,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return SkeletonListItem(
          showLeading: showLeading,
          lines: linesPerItem,
        );
      },
    );
  }
}

/// Skeleton grid
///
/// Pre-built skeleton for grid views
class SkeletonGrid extends StatelessWidget {
  /// Number of skeleton items
  final int itemCount;

  /// Number of columns
  final int crossAxisCount;

  /// Aspect ratio of items
  final double childAspectRatio;

  const SkeletonGrid({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: AppDimensions.spaceMd,
        mainAxisSpacing: AppDimensions.spaceMd,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return const SkeletonLoader(height: 200);
      },
    );
  }
}

/// Skeleton content block
///
/// Pre-built skeleton for content detail pages
class SkeletonContentBlock extends StatelessWidget {
  const SkeletonContentBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Hero image
          const SkeletonLoader(height: 250),
          const SizedBox(height: AppDimensions.spaceLg),

          // Title
          const SkeletonText(width: double.infinity, height: 24),
          const SizedBox(height: AppDimensions.spaceSm),
          const SkeletonText(width: 200, height: 24),
          const SizedBox(height: AppDimensions.spaceMd),

          // Metadata row
          Row(
            children: const [
              SkeletonCircle(size: 32),
              SizedBox(width: AppDimensions.spaceSm),
              SkeletonText(width: 120, height: 14),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Content paragraphs
          const SkeletonText(width: double.infinity, height: 14),
          const SizedBox(height: AppDimensions.spaceXs),
          const SkeletonText(width: double.infinity, height: 14),
          const SizedBox(height: AppDimensions.spaceXs),
          const SkeletonText(width: double.infinity, height: 14),
          const SizedBox(height: AppDimensions.spaceXs),
          const SkeletonText(width: 250, height: 14),
          const SizedBox(height: AppDimensions.spaceMd),

          const SkeletonText(width: double.infinity, height: 14),
          const SizedBox(height: AppDimensions.spaceXs),
          const SkeletonText(width: double.infinity, height: 14),
          const SizedBox(height: AppDimensions.spaceXs),
          const SkeletonText(width: 180, height: 14),
        ],
      ),
    );
  }
}
