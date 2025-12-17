import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/content/icap_chapter.dart';

/// Card widget for displaying a chapter in the list
class ChapterCard extends StatelessWidget {
  final IcapChapter chapter;
  final VoidCallback? onTap;
  final bool isChildFriendly;

  const ChapterCard({
    super.key,
    required this.chapter,
    this.onTap,
    this.isChildFriendly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isChildFriendly ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isChildFriendly ? AppDimensions.radiusXl : AppDimensions.radiusLg,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          isChildFriendly ? AppDimensions.radiusXl : AppDimensions.radiusLg,
        ),
        child: Container(
          padding: EdgeInsets.all(
            isChildFriendly ? AppDimensions.spaceLg : AppDimensions.spaceMd,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              isChildFriendly ? AppDimensions.radiusXl : AppDimensions.radiusLg,
            ),
            gradient: isChildFriendly
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      _getChapterColor(chapter.chapterNumber).withValues(alpha: 0.3),
                      _getChapterColor(chapter.chapterNumber).withValues(alpha: 0.1),
                    ],
                  )
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Icon and chapter number
              Row(
                children: [
                  Container(
                    width: isChildFriendly ? 56 : 48,
                    height: isChildFriendly ? 56 : 48,
                    decoration: BoxDecoration(
                      color: _getChapterColor(chapter.chapterNumber),
                      borderRadius: BorderRadius.circular(
                        isChildFriendly
                            ? AppDimensions.radiusMd
                            : AppDimensions.radiusSm,
                      ),
                    ),
                    child: Center(
                      child: Icon(
                        _getIconData(chapter.icon),
                        color: Colors.white,
                        size: isChildFriendly ? 28 : 24,
                      ),
                    ),
                  ),
                  const SizedBox(width: AppDimensions.spaceSm),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceXs,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceGray,
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      'Chapter ${chapter.chapterNumber}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: AppColors.textMedium,
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ),
                  const Spacer(),
                  // Age badge if applicable
                  if (chapter.isForAllAges)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.unicefBlue.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        'All Ages',
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: AppColors.unicefBlue,
                              fontWeight: FontWeight.w500,
                            ),
                      ),
                    ),
                ],
              ),
              SizedBox(
                  height:
                      isChildFriendly ? AppDimensions.spaceMd : AppDimensions.spaceSm),
              // Title
              Text(
                chapter.title,
                style: isChildFriendly
                    ? Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        )
                    : Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              // Description
              Text(
                chapter.description,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              SizedBox(
                  height:
                      isChildFriendly ? AppDimensions.spaceMd : AppDimensions.spaceSm),
              // Topics count
              Row(
                children: [
                  Icon(
                    Icons.article_outlined,
                    size: 16,
                    color: AppColors.textLight,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${chapter.topics.length} topics',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  if (chapter.youtubeVideoId != null) ...[
                    const SizedBox(width: AppDimensions.spaceSm),
                    Icon(
                      Icons.play_circle_outline,
                      size: 16,
                      color: Colors.red,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Video',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                  ],
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: AppColors.textLight,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getChapterColor(int chapterNumber) {
    final colors = [
      AppColors.unicefBlue,
      AppColors.pastelPink,
      AppColors.pastelYellow,
      AppColors.pastelGreen,
      AppColors.pastelPurple,
      AppColors.skyBlue,
      AppColors.softBlue,
      AppColors.success,
      AppColors.warning,
    ];
    return colors[(chapterNumber - 1) % colors.length];
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'child_care': Icons.child_care,
      'pregnant_woman': Icons.pregnant_woman,
      'child_friendly': Icons.child_friendly,
      'school': Icons.school,
      'person': Icons.person,
      'hub': Icons.hub,
      'self_improvement': Icons.self_improvement,
      'support_agent': Icons.support_agent,
    };
    return iconMap[iconName] ?? Icons.article;
  }
}

/// Compact variant of ChapterCard for grids
class ChapterCardCompact extends StatelessWidget {
  final IcapChapter chapter;
  final VoidCallback? onTap;
  final bool isChildFriendly;

  const ChapterCardCompact({
    super.key,
    required this.chapter,
    this.onTap,
    this.isChildFriendly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isChildFriendly ? 4 : 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          isChildFriendly ? AppDimensions.radiusXl : AppDimensions.radiusLg,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(
          isChildFriendly ? AppDimensions.radiusXl : AppDimensions.radiusLg,
        ),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(
              isChildFriendly ? AppDimensions.radiusXl : AppDimensions.radiusLg,
            ),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                _getChapterColor(chapter.chapterNumber),
                _getChapterColor(chapter.chapterNumber).withValues(alpha: 0.8),
              ],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _getIconData(chapter.icon),
                color: Colors.white,
                size: isChildFriendly ? 40 : 32,
              ),
              SizedBox(height: AppDimensions.spaceSm),
              Text(
                chapter.title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getChapterColor(int chapterNumber) {
    final colors = [
      AppColors.unicefBlue,
      AppColors.pastelPink,
      AppColors.pastelYellow,
      AppColors.pastelGreen,
      AppColors.pastelPurple,
      AppColors.skyBlue,
      AppColors.softBlue,
      AppColors.success,
      AppColors.warning,
    ];
    return colors[(chapterNumber - 1) % colors.length];
  }

  IconData _getIconData(String iconName) {
    final iconMap = {
      'child_care': Icons.child_care,
      'pregnant_woman': Icons.pregnant_woman,
      'child_friendly': Icons.child_friendly,
      'school': Icons.school,
      'person': Icons.person,
      'hub': Icons.hub,
      'self_improvement': Icons.self_improvement,
      'support_agent': Icons.support_agent,
    };
    return iconMap[iconName] ?? Icons.article;
  }
}
