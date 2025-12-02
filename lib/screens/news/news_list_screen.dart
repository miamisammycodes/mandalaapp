import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../core/services/dummy_data_service.dart';
import '../../widgets/shared/app_scaffold.dart';

/// News list screen displaying all news articles
class NewsListScreen extends StatefulWidget {
  const NewsListScreen({super.key});

  @override
  State<NewsListScreen> createState() => _NewsListScreenState();
}

class _NewsListScreenState extends State<NewsListScreen> {
  final _dummyData = DummyDataService();
  late List<Map<String, dynamic>> _newsList;
  String _selectedCategory = 'All';

  final List<String> _categories = [
    'All',
    'Health',
    'Education',
    'Protection',
    'Advocacy',
    'Emergency'
  ];

  @override
  void initState() {
    super.initState();
    _loadNews();
  }

  void _loadNews() {
    if (_selectedCategory == 'All') {
      _newsList = _dummyData.generateNewsList(15);
    } else {
      _newsList = _dummyData.generateNewsList(15, category: _selectedCategory);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'News',
      body: Column(
        children: [
          // Category filter
          _buildCategoryFilter(),
          // News list
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                setState(() => _loadNews());
              },
              child: ListView.builder(
                padding: EdgeInsets.all(AppDimensions.spaceMd),
                itemCount: _newsList.length,
                itemBuilder: (context, index) {
                  return _buildNewsCard(_newsList[index]);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 50,
      color: AppColors.cardWhite,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(
          horizontal: AppDimensions.spaceMd,
          vertical: AppDimensions.spaceSm,
        ),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final category = _categories[index];
          final isSelected = category == _selectedCategory;
          return Padding(
            padding: EdgeInsets.only(right: AppDimensions.spaceSm),
            child: FilterChip(
              label: Text(category),
              selected: isSelected,
              onSelected: (selected) {
                setState(() {
                  _selectedCategory = category;
                  _loadNews();
                });
              },
              selectedColor: AppColors.unicefBlue.withValues(alpha: 0.2),
              checkmarkColor: AppColors.unicefBlue,
              labelStyle: TextStyle(
                color: isSelected ? AppColors.unicefBlue : AppColors.textMedium,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildNewsCard(Map<String, dynamic> news) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceMd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      elevation: 2,
      child: InkWell(
        onTap: () {
          context.goNamed(
            AppRoutes.newsDetail,
            pathParameters: {'id': news['id']},
          );
        },
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image
            ClipRRect(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppDimensions.radiusXl),
              ),
              child: CachedNetworkImage(
                imageUrl: news['image'],
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
                placeholder: (context, url) => Container(
                  height: 180,
                  color: AppColors.surfaceGray,
                  child: const Center(child: CircularProgressIndicator()),
                ),
                errorWidget: (context, url, error) => Container(
                  height: 180,
                  color: AppColors.surfaceGray,
                  child: const Icon(Icons.image_not_supported),
                ),
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category chip
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppDimensions.spaceSm,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.getCategoryColor(news['category'])
                          .withValues(alpha: 0.2),
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusSm),
                    ),
                    child: Text(
                      news['category'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                  SizedBox(height: AppDimensions.spaceSm),
                  // Title
                  Text(
                    news['title'],
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.spaceSm),
                  // Excerpt
                  Text(
                    news['excerpt'],
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: AppDimensions.spaceMd),
                  // Footer
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage:
                            CachedNetworkImageProvider(news['authorAvatar']),
                      ),
                      SizedBox(width: AppDimensions.spaceSm),
                      Expanded(
                        child: Text(
                          news['author'],
                          style:
                              Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppColors.textMedium,
                                  ),
                        ),
                      ),
                      Icon(
                        Icons.access_time,
                        size: 14,
                        color: AppColors.textLight,
                      ),
                      SizedBox(width: 4),
                      Text(
                        news['readTime'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
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
}
