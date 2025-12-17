import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../models/events/event.dart';
import '../../providers/events/events_provider.dart';
import '../../widgets/navigation/app_drawer.dart';

/// Screen displaying list of events with filters
class EventsListScreen extends ConsumerWidget {
  const EventsListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(eventFilterProvider);
    final events = ref.watch(filteredEventsProvider);
    final featuredEvents = ref.watch(featuredEventsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: const Color(0xFFE91E63),
        title: const Text(
          'Events',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list, color: Colors.white),
            onPressed: () => _showFilterSheet(context, ref),
          ),
        ],
      ),
      drawer: const AppDrawer(),
      body: CustomScrollView(
        slivers: [
          // Toggle past/upcoming
          SliverToBoxAdapter(
            child: _buildToggle(context, ref, filterState),
          ),

          // Featured events (only show for upcoming)
          if (!filterState.showPast && featuredEvents.isNotEmpty)
            SliverToBoxAdapter(
              child: _buildFeaturedSection(context, featuredEvents),
            ),

          // Active filters
          if (filterState.category != null || filterState.audience != null)
            SliverToBoxAdapter(
              child: _buildActiveFilters(context, ref, filterState),
            ),

          // Events count
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceMd,
                vertical: AppDimensions.spaceXs,
              ),
              child: Text(
                '${events.length} ${filterState.showPast ? 'past' : 'upcoming'} event${events.length == 1 ? '' : 's'}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
              ),
            ),
          ),

          // Events list
          events.isEmpty
              ? SliverFillRemaining(
                  child: _buildEmptyState(context, filterState.showPast),
                )
              : SliverPadding(
                  padding: const EdgeInsets.all(AppDimensions.spaceMd),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final event = events[index];
                        return _buildEventCard(context, event);
                      },
                      childCount: events.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildToggle(
      BuildContext context, WidgetRef ref, EventFilterState filterState) {
    return Container(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Row(
        children: [
          Expanded(
            child: _buildToggleButton(
              context,
              label: 'Upcoming',
              isSelected: !filterState.showPast,
              onTap: () {
                if (filterState.showPast) {
                  ref.read(eventFilterProvider.notifier).toggleShowPast();
                }
              },
            ),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          Expanded(
            child: _buildToggleButton(
              context,
              label: 'Past',
              isSelected: filterState.showPast,
              onTap: () {
                if (!filterState.showPast) {
                  ref.read(eventFilterProvider.notifier).toggleShowPast();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButton(
    BuildContext context, {
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: AppDimensions.spaceSm),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFE91E63) : AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          border: Border.all(
            color: isSelected
                ? const Color(0xFFE91E63)
                : AppColors.textLight.withValues(alpha: 0.3),
          ),
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: isSelected ? Colors.white : AppColors.textMedium,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
        ),
      ),
    );
  }

  Widget _buildFeaturedSection(BuildContext context, List<Event> featured) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
          child: Text(
            'Featured Events',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
          ),
        ),
        const SizedBox(height: AppDimensions.spaceXs),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding:
                const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
            itemCount: featured.length,
            itemBuilder: (context, index) {
              final event = featured[index];
              return _buildFeaturedCard(context, event);
            },
          ),
        ),
        const SizedBox(height: AppDimensions.spaceMd),
        const Divider(),
      ],
    );
  }

  Widget _buildFeaturedCard(BuildContext context, Event event) {
    final color = _getCategoryColor(event.category);

    return GestureDetector(
      onTap: () => context.pushNamed(
        AppRoutes.eventDetail,
        pathParameters: {'eventId': event.id},
      ),
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: AppDimensions.spaceSm),
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background image or gradient fallback
            if (event.imageUrl != null)
              Image.network(
                event.imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [color, color.withValues(alpha: 0.8)],
                    ),
                  ),
                ),
              )
            else
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [color, color.withValues(alpha: 0.8)],
                  ),
                ),
              ),
            // Dark gradient overlay for text readability
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.2),
                    Colors.black.withValues(alpha: 0.7),
                  ],
                ),
              ),
            ),
            // Content
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceXs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.25),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: Text(
                          event.category.label,
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                      ),
                      const Spacer(),
                      const Icon(Icons.star, color: Colors.amber, size: 18),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Text(
                    event.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today,
                          size: 14, color: Colors.white70),
                      const SizedBox(width: 4),
                      Text(
                        event.formattedDate,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white70,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        event.isVirtual ? Icons.videocam : Icons.location_on,
                        size: 14,
                        color: Colors.white70,
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Text(
                          event.location,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.white70,
                              ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveFilters(
      BuildContext context, WidgetRef ref, EventFilterState filterState) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: AppDimensions.spaceXs,
      ),
      child: Row(
        children: [
          Text(
            'Filters:',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textMedium,
                ),
          ),
          const SizedBox(width: AppDimensions.spaceXs),
          if (filterState.category != null)
            _buildFilterChip(
              context,
              label: filterState.category!.label,
              onRemove: () =>
                  ref.read(eventFilterProvider.notifier).setCategory(null),
            ),
          if (filterState.audience != null)
            _buildFilterChip(
              context,
              label: filterState.audience!.label,
              onRemove: () =>
                  ref.read(eventFilterProvider.notifier).setAudience(null),
            ),
          const Spacer(),
          TextButton(
            onPressed: () =>
                ref.read(eventFilterProvider.notifier).clearFilters(),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(
    BuildContext context, {
    required String label,
    required VoidCallback onRemove,
  }) {
    return Container(
      margin: const EdgeInsets.only(right: AppDimensions.spaceXs),
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceXs,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE91E63).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: const Color(0xFFE91E63),
                ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onRemove,
            child: const Icon(
              Icons.close,
              size: 14,
              color: Color(0xFFE91E63),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEventCard(BuildContext context, Event event) {
    final color = _getCategoryColor(event.category);

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.eventDetail,
          pathParameters: {'eventId': event.id},
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Date badge
              Container(
                width: 56,
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: event.isPast
                      ? AppColors.textLight.withValues(alpha: 0.2)
                      : color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Column(
                  children: [
                    Text(
                      event.eventDate.day.toString(),
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: event.isPast ? AppColors.textLight : color,
                          ),
                    ),
                    Text(
                      _getMonthAbbr(event.eventDate.month),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: event.isPast ? AppColors.textLight : color,
                          ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              // Event details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Text(
                            event.category.label,
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: color,
                                      fontWeight: FontWeight.w600,
                                    ),
                          ),
                        ),
                        if (event.isVirtual) ...[
                          const SizedBox(width: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.unicefBlue.withValues(alpha: 0.1),
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.radiusSm),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.videocam,
                                    size: 12, color: AppColors.unicefBlue),
                                const SizedBox(width: 2),
                                Text(
                                  'Virtual',
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: AppColors.unicefBlue,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: AppDimensions.spaceXs),
                    Text(
                      event.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(
                          event.isVirtual ? Icons.videocam : Icons.location_on,
                          size: 14,
                          color: AppColors.textLight,
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            event.location,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMedium,
                                    ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    if (event.formattedTime != null) ...[
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          const Icon(Icons.access_time,
                              size: 14, color: AppColors.textLight),
                          const SizedBox(width: 4),
                          Text(
                            event.formattedTime!,
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMedium,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: AppColors.textLight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isPast) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            isPast ? Icons.history : Icons.event_available,
            size: 64,
            color: AppColors.textLight,
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            isPast ? 'No past events' : 'No upcoming events',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textMedium,
                ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            isPast
                ? 'Past events will appear here'
                : 'Check back soon for new events!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                ),
          ),
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => _FilterSheet(ref: ref),
    );
  }

  Color _getCategoryColor(EventCategory category) {
    switch (category) {
      case EventCategory.seminar:
        return const Color(0xFF9C27B0);
      case EventCategory.training:
        return const Color(0xFF2196F3);
      case EventCategory.workshop:
        return const Color(0xFFFF9800);
      case EventCategory.awareness:
        return const Color(0xFF4CAF50);
      case EventCategory.community:
        return const Color(0xFFE91E63);
      case EventCategory.health:
        return const Color(0xFF00BCD4);
      case EventCategory.other:
        return AppColors.textMedium;
    }
  }

  String _getMonthAbbr(int month) {
    const months = [
      'JAN', 'FEB', 'MAR', 'APR', 'MAY', 'JUN',
      'JUL', 'AUG', 'SEP', 'OCT', 'NOV', 'DEC'
    ];
    return months[month - 1];
  }
}

class _FilterSheet extends ConsumerWidget {
  final WidgetRef ref;

  const _FilterSheet({required this.ref});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(eventFilterProvider);

    return Padding(
      padding: const EdgeInsets.all(AppDimensions.spaceMd),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'Filter Events',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const Spacer(),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Category filter
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Wrap(
            spacing: AppDimensions.spaceXs,
            runSpacing: AppDimensions.spaceXs,
            children: EventCategory.values.map((category) {
              final isSelected = filterState.category == category;
              return ChoiceChip(
                label: Text(category.label),
                selected: isSelected,
                onSelected: (selected) {
                  ref.read(eventFilterProvider.notifier).setCategory(
                        selected ? category : null,
                      );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spaceMd),

          // Audience filter
          Text(
            'Audience',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Wrap(
            spacing: AppDimensions.spaceXs,
            runSpacing: AppDimensions.spaceXs,
            children: EventAudience.values.map((audience) {
              final isSelected = filterState.audience == audience;
              return ChoiceChip(
                label: Text(audience.label),
                selected: isSelected,
                onSelected: (selected) {
                  ref.read(eventFilterProvider.notifier).setAudience(
                        selected ? audience : null,
                      );
                },
              );
            }).toList(),
          ),
          const SizedBox(height: AppDimensions.spaceLg),

          // Apply button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFE91E63),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
              ),
              child: const Text('Apply Filters'),
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
        ],
      ),
    );
  }
}
