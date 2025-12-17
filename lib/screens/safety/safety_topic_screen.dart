import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/safety/safety_topic.dart';
import '../../providers/safety/safety_provider.dart';
import '../../widgets/content/expandable_section.dart';
import '../../widgets/content/markdown_content.dart';

/// Screen showing topics for a specific safety category (4 C's)
class SafetyTopicScreen extends ConsumerWidget {
  final String categoryId;

  const SafetyTopicScreen({
    super.key,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final category = _getCategoryFromId(categoryId);

    if (category == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Not Found')),
        body: const Center(child: Text('Category not found')),
      );
    }

    final topics = ref.watch(safetyTopicsByCategoryProvider(category));
    final color = _getCategoryColor(category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar
          SliverAppBar(
            pinned: true,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            title: Text(
              category.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          // Header
          SliverToBoxAdapter(
            child: _buildHeader(context, category, color),
          ),

          // Topics list
          SliverPadding(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final topic = topics[index];
                  return _buildTopicCard(context, topic, color, index);
                },
                childCount: topics.length,
              ),
            ),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.spaceXl),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
      BuildContext context, SafetyCategory category, Color color) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            color,
            color.withValues(alpha: 0),
          ],
        ),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getCategoryIcon(category),
              size: 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            _getCategoryTitle(category),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            category.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildTopicCard(
    BuildContext context,
    SafetyTopic topic,
    Color color,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      child: ExpandableSection(
        title: topic.title,
        icon: Icons.article_outlined,
        initiallyExpanded: index == 0,
        isChildFriendly: false,
        headerColor: color,
        content: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Description
            Text(
              topic.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                    fontStyle: FontStyle.italic,
                  ),
            ),
            const SizedBox(height: AppDimensions.spaceMd),

            // Markdown content
            MarkdownContent(
              data: topic.content,
              isChildFriendly: false,
            ),

            // Tips if available
            if (topic.tips.isNotEmpty) ...[
              const SizedBox(height: AppDimensions.spaceMd),
              const Divider(),
              const SizedBox(height: AppDimensions.spaceSm),
              Text(
                'Quick Tips',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              ...topic.tips.map((tip) => _buildTipItem(context, tip, color)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTipItem(BuildContext context, SafetyTip tip, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceXs),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.lightbulb_outline,
            size: 18,
            color: color,
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tip.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Text(
                  tip.content,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMedium,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  SafetyCategory? _getCategoryFromId(String id) {
    try {
      return SafetyCategory.values.firstWhere((c) => c.name == id);
    } catch (_) {
      return null;
    }
  }

  String _getCategoryTitle(SafetyCategory category) {
    switch (category) {
      case SafetyCategory.content:
        return 'Content Risks';
      case SafetyCategory.conduct:
        return 'Conduct Risks';
      case SafetyCategory.contact:
        return 'Contact Risks';
      case SafetyCategory.contract:
        return 'Contract Risks';
    }
  }

  Color _getCategoryColor(SafetyCategory category) {
    switch (category) {
      case SafetyCategory.content:
        return const Color(0xFF9C27B0); // Purple
      case SafetyCategory.conduct:
        return const Color(0xFFFF9800); // Orange
      case SafetyCategory.contact:
        return const Color(0xFFE91E63); // Pink
      case SafetyCategory.contract:
        return AppColors.unicefBlue;
    }
  }

  IconData _getCategoryIcon(SafetyCategory category) {
    switch (category) {
      case SafetyCategory.content:
        return Icons.block;
      case SafetyCategory.conduct:
        return Icons.people;
      case SafetyCategory.contact:
        return Icons.person_off;
      case SafetyCategory.contract:
        return Icons.security;
    }
  }
}
