import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/content/icap_chapter.dart';
import '../../providers/content/chapters_provider.dart';
import '../../widgets/content/expandable_section.dart';
import '../../widgets/content/markdown_content.dart';
import '../../widgets/content/youtube_player.dart';

/// Chapter detail screen - displays a single chapter with video and topics
class ChapterDetailScreen extends ConsumerStatefulWidget {
  final String chapterId;

  const ChapterDetailScreen({
    super.key,
    required this.chapterId,
  });

  @override
  ConsumerState<ChapterDetailScreen> createState() =>
      _ChapterDetailScreenState();
}

class _ChapterDetailScreenState extends ConsumerState<ChapterDetailScreen> {
  bool _showVideoPlayer = false;
  final int _expandedTopicIndex = 0;

  @override
  Widget build(BuildContext context) {
    final chapter = ref.watch(chapterByIdProvider(widget.chapterId));
    final isChildMode = ref.watch(isChildFriendlyModeProvider);

    if (chapter == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Chapter Not Found'),
        ),
        body: const Center(
          child: Text('The requested chapter could not be found.'),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          _buildAppBar(context, chapter, isChildMode),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Video section
                  if (chapter.youtubeVideoId != null)
                    _buildVideoSection(chapter, isChildMode),

                  // Chapter info
                  _buildChapterInfo(context, chapter, isChildMode),

                  // Topics
                  _buildTopicsSection(context, chapter, isChildMode),

                  const SizedBox(height: AppDimensions.spaceXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(
      BuildContext context, IcapChapter chapter, bool isChildMode) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: _getChapterColor(chapter.chapterNumber),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.white),
        onPressed: () => context.pop(),
      ),
      title: Text(
        'Chapter ${chapter.chapterNumber}: ${chapter.title}',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  Widget _buildVideoSection(IcapChapter chapter, bool isChildMode) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (_showVideoPlayer)
          ChapterYoutubePlayer(
            videoId: chapter.youtubeVideoId!,
            isChildFriendly: isChildMode,
          )
        else
          VideoThumbnailPlaceholder(
            videoId: chapter.youtubeVideoId!,
            isChildFriendly: isChildMode,
            onTap: () {
              setState(() {
                _showVideoPlayer = true;
              });
            },
          ),
        const SizedBox(height: AppDimensions.spaceMd),
      ],
    );
  }

  Widget _buildChapterInfo(
      BuildContext context, IcapChapter chapter, bool isChildMode) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      decoration: BoxDecoration(
        color: AppColors.cardWhite,
        borderRadius: BorderRadius.circular(
          isChildMode ? AppDimensions.radiusLg : AppDimensions.radiusMd,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Description
          Text(
            chapter.description,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textDark,
                  height: 1.5,
                ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          // Info chips
          Wrap(
            spacing: AppDimensions.spaceXs,
            runSpacing: AppDimensions.spaceXs,
            children: [
              _buildInfoChip(
                context,
                Icons.article_outlined,
                '${chapter.topics.length} Topics',
                AppColors.unicefBlue,
              ),
              if (chapter.youtubeVideoId != null)
                _buildInfoChip(
                  context,
                  Icons.play_circle_outline,
                  'Video',
                  Colors.red,
                ),
              if (chapter.isForAllAges)
                _buildInfoChip(
                  context,
                  Icons.people_outline,
                  'All Ages',
                  AppColors.success,
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoChip(
      BuildContext context, IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceXs + 4,
        vertical: AppDimensions.spaceXs,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopicsSection(
      BuildContext context, IcapChapter chapter, bool isChildMode) {
    if (chapter.topics.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Topics',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
        ),
        const SizedBox(height: AppDimensions.spaceSm),
        ...chapter.topics.asMap().entries.map((entry) {
          final index = entry.key;
          final topic = entry.value;
          return _buildTopicSection(
            context,
            chapter,
            topic,
            index,
            isChildMode,
          );
        }),
      ],
    );
  }

  Widget _buildTopicSection(
    BuildContext context,
    IcapChapter chapter,
    ChapterTopic topic,
    int index,
    bool isChildMode,
  ) {
    final topicContentAsync = ref.watch(
      topicContentProvider(
        (chapterId: chapter.id, topicId: topic.id),
      ),
    );

    return ExpandableSection(
      title: topic.title,
      icon: _getTopicIcon(topic.icon),
      initiallyExpanded: index == _expandedTopicIndex,
      isChildFriendly: isChildMode,
      headerColor: _getChapterColor(chapter.chapterNumber),
      content: topicContentAsync.when(
        data: (content) => MarkdownContent(
          data: content,
          isChildFriendly: isChildMode,
        ),
        loading: () => const Padding(
          padding: EdgeInsets.all(AppDimensions.spaceMd),
          child: Center(
            child: CircularProgressIndicator(
              color: AppColors.unicefBlue,
            ),
          ),
        ),
        error: (error, stack) => Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          child: Text(
            'Failed to load content',
            style: TextStyle(color: AppColors.error),
          ),
        ),
      ),
    );
  }

  Color _getChapterColor(int chapterNumber) {
    final colors = [
      AppColors.unicefBlue,
      AppColors.pastelPink,
      const Color(0xFFF5C542), // Darker yellow for better contrast
      AppColors.pastelGreen,
      AppColors.pastelPurple,
      AppColors.skyBlue,
      AppColors.softBlue,
      AppColors.success,
      AppColors.warning,
    ];
    return colors[(chapterNumber - 1) % colors.length];
  }

  IconData _getTopicIcon(String? iconName) {
    if (iconName == null) return Icons.article_outlined;

    final iconMap = {
      'fitness_center': Icons.fitness_center,
      'psychology': Icons.psychology,
      'favorite': Icons.favorite,
      'chat': Icons.chat,
      'check_circle': Icons.check_circle,
      'cancel': Icons.cancel,
      'baby_changing_station': Icons.baby_changing_station,
      'child_care': Icons.child_care,
      'child_friendly': Icons.child_friendly,
      'trending_up': Icons.trending_up,
      'toys': Icons.toys,
      'school': Icons.school,
      'menu_book': Icons.menu_book,
      'groups': Icons.groups,
      'health_and_safety': Icons.health_and_safety,
      'accessibility_new': Icons.accessibility_new,
      'forum': Icons.forum,
      'restaurant': Icons.restaurant,
      'thumb_up': Icons.thumb_up,
      'security': Icons.security,
      'spa': Icons.spa,
      'group': Icons.group,
      'balance': Icons.balance,
      'phone': Icons.phone,
      'local_hospital': Icons.local_hospital,
    };
    return iconMap[iconName] ?? Icons.article_outlined;
  }
}
