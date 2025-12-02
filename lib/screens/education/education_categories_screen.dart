import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../core/services/dummy_data_service.dart';
import '../../widgets/shared/app_scaffold.dart';

/// Education categories screen displaying the four main mandala sections
class EducationCategoriesScreen extends StatelessWidget {
  EducationCategoriesScreen({super.key});

  final _dummyData = DummyDataService();

  @override
  Widget build(BuildContext context) {
    final categories = _dummyData.generateCategories();

    return AppScaffold(
      title: 'Education',
      body: ListView(
        padding: EdgeInsets.all(AppDimensions.spaceMd),
        children: [
          // Header
          Text(
            'Child Rights Categories',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
          ),
          SizedBox(height: AppDimensions.spaceSm),
          Text(
            'Explore the four guiding principles of the Convention on the Rights of the Child',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMedium,
                ),
          ),
          SizedBox(height: AppDimensions.spaceLg),

          // Categories grid
          ...categories.map((category) => _buildCategoryCard(context, category)),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, Map<String, dynamic> category) {
    final color = _parseColor(category['color']);

    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceMd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.goNamed(
            AppRoutes.educationCategory,
            pathParameters: {'categoryId': category['id']},
          );
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: Container(
          padding: EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.3),
                color.withValues(alpha: 0.1),
              ],
            ),
          ),
          child: Row(
            children: [
              // Icon
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Icon(
                  _getIconForCategory(category['icon']),
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(width: AppDimensions.spaceMd),

              // Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category['name'],
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      category['description'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMedium,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (category['hasSubcategories'] == true) ...[
                      SizedBox(height: AppDimensions.spaceSm),
                      Wrap(
                        spacing: 4,
                        children: (category['subcategories'] as List)
                            .take(3)
                            .map((sub) => Chip(
                                  label: Text(
                                    sub['name'],
                                    style: const TextStyle(fontSize: 10),
                                  ),
                                  backgroundColor: color.withValues(alpha: 0.3),
                                  visualDensity: VisualDensity.compact,
                                  padding: EdgeInsets.zero,
                                ))
                            .toList(),
                      ),
                    ],
                  ],
                ),
              ),

              // Arrow
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.textLight,
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconForCategory(String? iconName) {
    switch (iconName) {
      case 'heart':
        return Icons.favorite;
      case 'people':
        return Icons.people;
      case 'star':
        return Icons.star;
      case 'chat':
        return Icons.chat_bubble;
      default:
        return Icons.category;
    }
  }

  Color _parseColor(String? hexColor) {
    if (hexColor == null) return AppColors.unicefBlue;
    final hex = hexColor.replaceFirst('#', '');
    return Color(int.parse('FF$hex', radix: 16));
  }
}
