import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../models/safety/safety_topic.dart';
import '../../providers/content/chapters_provider.dart';
import '../../providers/safety/safety_provider.dart';
import '../../widgets/navigation/app_drawer.dart';

/// Main hub screen for online safety content
class OnlineSafetyScreen extends ConsumerWidget {
  const OnlineSafetyScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isChildMode = ref.watch(isChildFriendlyModeProvider);
    final emergencyContacts = ref.watch(emergencyContactsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.unicefBlue,
        title: const Text(
          'Online Safety',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            _buildHeader(context, isChildMode),

            // 4 C's Categories
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'The 4 C\'s of Online Safety',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceXs),
                  Text(
                    'Learn about the main online risks and how to stay safe',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceMd),

                  // Category cards
                  ...SafetyCategory.values.map(
                    (category) => _buildCategoryCard(context, category),
                  ),
                ],
              ),
            ),

            // Quick Actions
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Quick Actions',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceSm),
                  Row(
                    children: [
                      Expanded(
                        child: _buildActionCard(
                          context,
                          icon: Icons.lightbulb_outline,
                          title: 'Safety Tips',
                          color: AppColors.warning,
                          onTap: () => context.pushNamed(AppRoutes.safetyTips),
                        ),
                      ),
                      const SizedBox(width: AppDimensions.spaceSm),
                      Expanded(
                        child: _buildActionCard(
                          context,
                          icon: Icons.report_outlined,
                          title: 'Report Concern',
                          color: AppColors.error,
                          onTap: () =>
                              context.pushNamed(AppRoutes.reportConcern),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spaceLg),

            // Emergency Contacts
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Emergency Contacts',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  const SizedBox(height: AppDimensions.spaceSm),
                  ...emergencyContacts.map(
                    (contact) => _buildEmergencyContact(context, contact),
                  ),
                ],
              ),
            ),

            const SizedBox(height: AppDimensions.spaceXl),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, bool isChildMode) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppDimensions.spaceLg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.unicefBlue,
            AppColors.unicefBlue.withValues(alpha: 0),
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
              Icons.security,
              size: isChildMode ? 56 : 48,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceMd),
          Text(
            isChildMode ? 'Stay Safe Online!' : 'Protecting Children Online',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            isChildMode
                ? 'Learn how to be smart and safe on the internet'
                : 'Essential knowledge to keep your children safe in the digital world',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, SafetyCategory category) {
    final color = _getCategoryColor(category);
    final icon = _getCategoryIcon(category);

    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: () => context.pushNamed(
          AppRoutes.safetyTopic,
          pathParameters: {'categoryId': category.name},
        ),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceSm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(width: AppDimensions.spaceMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: color,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      category.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMedium,
                          ),
                    ),
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

  Widget _buildActionCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.spaceMd),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceSm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 28),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                title,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmergencyContact(
      BuildContext context, EmergencyContact contact) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppDimensions.spaceXs),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: contact.isEmergency
                ? AppColors.error.withValues(alpha: 0.15)
                : AppColors.unicefBlue.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            contact.isEmergency ? Icons.emergency : Icons.phone,
            color: contact.isEmergency ? AppColors.error : AppColors.unicefBlue,
            size: 20,
          ),
        ),
        title: Text(
          contact.name,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w600,
              ),
        ),
        subtitle: Text(
          contact.description,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textMedium,
              ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimensions.spaceSm,
            vertical: AppDimensions.spaceXs,
          ),
          decoration: BoxDecoration(
            color: contact.isEmergency
                ? AppColors.error
                : AppColors.unicefBlue.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
          ),
          child: Text(
            contact.phone,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color:
                      contact.isEmergency ? Colors.white : AppColors.unicefBlue,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ),
      ),
    );
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
