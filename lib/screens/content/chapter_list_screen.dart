import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth/auth_provider.dart';
import '../../providers/content/chapters_provider.dart';
import '../../widgets/content/chapter_card.dart';
import '../../widgets/navigation/app_drawer.dart';

/// Chapter list screen - displays all available chapters
/// Filtered by age group when in child mode
class ChapterListScreen extends ConsumerWidget {
  const ChapterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chapters = ref.watch(ageFilteredChaptersProvider);
    final isChildMode = ref.watch(isChildFriendlyModeProvider);
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.unicefBlue,
        elevation: 0,
        title: Row(
          children: [
            Text(
              'Learning',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (isChildMode && authState.activeChild != null) ...[
              const SizedBox(width: AppDimensions.spaceXs),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.spaceXs,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Text(
                  authState.activeChild!.name,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white,
                      ),
                ),
              ),
            ],
          ],
        ),
      ),
      drawer: const AppDrawer(),
      body: chapters.isEmpty
          ? _buildEmptyState(context)
          : _buildChapterList(context, ref, chapters, isChildMode),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu_book_outlined,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            'No chapters available',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textMedium,
                ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            'Check back later for new content',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterList(
    BuildContext context,
    WidgetRef ref,
    List chapters,
    bool isChildMode,
  ) {
    return CustomScrollView(
      slivers: [
        // Header info
        SliverToBoxAdapter(
          child: Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.unicefBlue,
                  AppColors.unicefBlue.withValues(alpha: 0),
                ],
                stops: const [0, 1],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isChildMode
                      ? 'Content just for you!'
                      : 'Parenting Education',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: AppDimensions.spaceXs),
                Text(
                  isChildMode
                      ? 'Learn about growing up healthy and happy'
                      : 'ICAP - Integrated Care for Parents and Children',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
                const SizedBox(height: AppDimensions.spaceSm),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSm,
                    vertical: AppDimensions.spaceXs,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Text(
                    '${chapters.length} chapters available',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ),

        // Chapter list
        SliverPadding(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final chapter = chapters[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
                  child: ChapterCard(
                    chapter: chapter,
                    isChildFriendly: isChildMode,
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.chapterDetail,
                        pathParameters: {'chapterId': chapter.id},
                      );
                    },
                  ),
                );
              },
              childCount: chapters.length,
            ),
          ),
        ),

        // Bottom padding
        const SliverToBoxAdapter(
          child: SizedBox(height: AppDimensions.spaceXl),
        ),
      ],
    );
  }
}
