import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/safety/safety_topic.dart';
import '../../providers/content/chapters_provider.dart';
import '../../providers/safety/safety_provider.dart';

/// Screen showing quick safety tips for parents and children
class SafetyTipsScreen extends ConsumerWidget {
  const SafetyTipsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChildMode = ref.watch(isChildFriendlyModeProvider);
    final parentTips = ref.watch(safetyTipsForParentsProvider);
    final childTips = ref.watch(safetyTipsForChildrenProvider);

    return DefaultTabController(
      length: isChildMode ? 1 : 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.warning,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => context.pop(),
          ),
          title: const Text(
            'Safety Tips',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          bottom: isChildMode
              ? null
              : TabBar(
                  indicatorColor: Colors.white,
                  labelColor: Colors.white,
                  unselectedLabelColor: Colors.white70,
                  tabs: const [
                    Tab(text: 'For Parents'),
                    Tab(text: 'For Children'),
                  ],
                ),
        ),
        body: isChildMode
            ? _buildTipsList(context, childTips, isForChildren: true)
            : TabBarView(
                children: [
                  _buildTipsList(context, parentTips, isForChildren: false),
                  _buildTipsList(context, childTips, isForChildren: true),
                ],
              ),
      ),
    );
  }

  Widget _buildTipsList(
    BuildContext context,
    List<SafetyTip> tips, {
    required bool isForChildren,
  }) {
    if (tips.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb_outline,
              size: 64,
              color: AppColors.textLight,
            ),
            const SizedBox(height: AppDimensions.spaceMd),
            Text(
              'No tips available',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      itemCount: tips.length + 1, // +1 for header
      itemBuilder: (context, index) {
        if (index == 0) {
          return _buildHeader(context, isForChildren);
        }

        final tip = tips[index - 1];
        return _buildTipCard(context, tip, index - 1);
      },
    );
  }

  Widget _buildHeader(BuildContext context, bool isForChildren) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.spaceMd),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(AppDimensions.spaceMd),
            decoration: BoxDecoration(
              color: AppColors.warning.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isForChildren ? Icons.child_care : Icons.family_restroom,
              size: 48,
              color: AppColors.warning,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            isForChildren
                ? 'Stay Safe Online!'
                : 'Tips for Keeping Your Children Safe',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            isForChildren
                ? 'Remember these important rules when using the internet'
                : 'Simple actions you can take to protect your children online',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMedium,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          const Divider(),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, SafetyTip tip, int index) {
    final colors = [
      AppColors.unicefBlue,
      const Color(0xFF9C27B0),
      const Color(0xFFFF9800),
      const Color(0xFFE91E63),
      AppColors.success,
    ];

    final color = colors[index % colors.length];

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                ),
              ),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tip.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    tip.content,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                          height: 1.4,
                        ),
                  ),
                  if (tip.category != null) ...[
                    const SizedBox(height: AppDimensions.spaceXs),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDimensions.spaceXs,
                        vertical: 2,
                      ),
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.1),
                        borderRadius:
                            BorderRadius.circular(AppDimensions.radiusSm),
                      ),
                      child: Text(
                        tip.category!.title,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                              color: color,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
