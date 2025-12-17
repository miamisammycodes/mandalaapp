import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/events/event.dart';
import '../../providers/events/events_provider.dart';

/// Screen displaying detailed information about a single event
class EventDetailScreen extends ConsumerWidget {
  final String eventId;

  const EventDetailScreen({
    super.key,
    required this.eventId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final event = ref.watch(eventByIdProvider(eventId));

    if (event == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Event Not Found')),
        body: const Center(child: Text('The requested event could not be found.')),
      );
    }

    final color = _getCategoryColor(event.category);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // App bar with event header
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            backgroundColor: color,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => context.pop(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
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
                  // Dark overlay for text readability
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.3),
                          Colors.black.withValues(alpha: 0.6),
                        ],
                      ),
                    ),
                  ),
                  // Content
                  SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(AppDimensions.spaceMd),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppDimensions.spaceXs,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius:
                                    BorderRadius.circular(AppDimensions.radiusSm),
                              ),
                              child: Text(
                                event.category.label,
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(color: Colors.white),
                              ),
                            ),
                            if (event.isFeatured) ...[
                              const SizedBox(width: AppDimensions.spaceXs),
                              const Icon(Icons.star, color: Colors.amber, size: 18),
                            ],
                            if (event.isVirtual) ...[
                              const SizedBox(width: AppDimensions.spaceXs),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppDimensions.spaceXs,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.2),
                                  borderRadius:
                                      BorderRadius.circular(AppDimensions.radiusSm),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(Icons.videocam,
                                        size: 14, color: Colors.white),
                                    const SizedBox(width: 4),
                                    Text(
                                      'Virtual',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelSmall
                                          ?.copyWith(color: Colors.white),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: AppDimensions.spaceSm),
                        Text(
                          event.title,
                          style:
                              Theme.of(context).textTheme.headlineSmall?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                ),
                ],
              ),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Date & Time card
                  _buildInfoCard(
                    context,
                    icon: Icons.calendar_today,
                    title: 'Date & Time',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.formattedDate,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        if (event.formattedTime != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            event.formattedTime!,
                            style:
                                Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      color: AppColors.textMedium,
                                    ),
                          ),
                        ],
                        if (event.isPast)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spaceXs,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.textLight.withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.radiusSm),
                            ),
                            child: Text(
                              'This event has ended',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.textMedium),
                            ),
                          ),
                        if (event.isToday && !event.isPast)
                          Container(
                            margin: const EdgeInsets.only(top: 8),
                            padding: const EdgeInsets.symmetric(
                              horizontal: AppDimensions.spaceXs,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.success.withValues(alpha: 0.2),
                              borderRadius:
                                  BorderRadius.circular(AppDimensions.radiusSm),
                            ),
                            child: Text(
                              'Happening today!',
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(color: AppColors.success),
                            ),
                          ),
                      ],
                    ),
                    color: color,
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // Location card
                  _buildInfoCard(
                    context,
                    icon: event.isVirtual ? Icons.videocam : Icons.location_on,
                    title: event.isVirtual ? 'Virtual Event' : 'Location',
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          event.location,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: AppColors.textDark,
                                  ),
                        ),
                        if (event.isVirtual && event.virtualLink != null) ...[
                          const SizedBox(height: 8),
                          TextButton.icon(
                            onPressed: () => _launchUrl(event.virtualLink!),
                            icon: const Icon(Icons.open_in_new, size: 18),
                            label: const Text('Join Online'),
                            style: TextButton.styleFrom(
                              foregroundColor: color,
                              padding: EdgeInsets.zero,
                            ),
                          ),
                        ],
                      ],
                    ),
                    color: color,
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // Organizer card
                  _buildInfoCard(
                    context,
                    icon: Icons.business,
                    title: 'Organized by',
                    content: Text(
                      event.agency.name,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textDark,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    color: color,
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // Target audience
                  _buildInfoCard(
                    context,
                    icon: Icons.people,
                    title: 'For',
                    content: Wrap(
                      spacing: AppDimensions.spaceXs,
                      runSpacing: AppDimensions.spaceXs,
                      children: event.targetAudience.map((audience) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDimensions.spaceXs,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.1),
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusSm),
                          ),
                          child: Text(
                            audience.label,
                            style:
                                Theme.of(context).textTheme.labelSmall?.copyWith(
                                      color: color,
                                    ),
                          ),
                        );
                      }).toList(),
                    ),
                    color: color,
                  ),
                  const SizedBox(height: AppDimensions.spaceLg),

                  // Description
                  Text(
                    'About this event',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    event.description,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                          height: 1.6,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXl),

                  // Registration button
                  if (event.registrationUrl != null && !event.isPast)
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _launchUrl(event.registrationUrl!),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: color,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(AppDimensions.radiusMd),
                          ),
                        ),
                        child: const Text(
                          'Register Now',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  const SizedBox(height: AppDimensions.spaceXl),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Widget content,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(AppDimensions.spaceXs),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  const SizedBox(height: 4),
                  content,
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
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
}
