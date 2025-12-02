import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/dummy_data_service.dart';
import '../../widgets/shared/app_scaffold.dart';

/// News detail screen displaying full article
class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  final _dummyData = DummyDataService();
  late Map<String, dynamic> _news;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _news = _dummyData.generateNewsDetail(widget.newsId);
    _isLiked = _news['isLikedByUser'] ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'News',
      showBackButton: true,
      actions: [
        IconButton(
          icon: Icon(
            _isLiked ? Icons.favorite : Icons.favorite_border,
            color: _isLiked ? Colors.red : Colors.white,
          ),
          onPressed: () {
            setState(() => _isLiked = !_isLiked);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(_isLiked ? 'Added to favorites' : 'Removed from favorites'),
                duration: const Duration(seconds: 1),
              ),
            );
          },
        ),
        IconButton(
          icon: const Icon(Icons.share, color: Colors.white),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share functionality coming soon')),
            );
          },
        ),
      ],
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero image
            CachedNetworkImage(
              imageUrl: _news['image'],
              height: 250,
              width: double.infinity,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                height: 250,
                color: AppColors.surfaceGray,
                child: const Center(child: CircularProgressIndicator()),
              ),
              errorWidget: (context, url, error) => Container(
                height: 250,
                color: AppColors.surfaceGray,
                child: const Icon(Icons.image_not_supported, size: 48),
              ),
            ),

            Padding(
              padding: EdgeInsets.all(AppDimensions.spaceMd),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and read time
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: AppDimensions.spaceSm,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.getCategoryColor(_news['category'])
                              .withValues(alpha: 0.2),
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusSm),
                        ),
                        child: Text(
                          _news['category'],
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: AppColors.textLight,
                      ),
                      SizedBox(width: 4),
                      Text(
                        _news['readTime'],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textLight,
                            ),
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spaceMd),

                  // Title
                  Text(
                    _news['title'],
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  SizedBox(height: AppDimensions.spaceMd),

                  // Author info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundImage:
                            CachedNetworkImageProvider(_news['authorAvatar']),
                      ),
                      SizedBox(width: AppDimensions.spaceSm),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _news['author'],
                            style: Theme.of(context)
                                .textTheme
                                .bodyMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textDark,
                                ),
                          ),
                          Text(
                            _formatDate(_news['publishedAt']),
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textLight,
                                    ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spaceMd),

                  // Divider
                  const Divider(),
                  SizedBox(height: AppDimensions.spaceMd),

                  // Content
                  Html(
                    data: _news['content'],
                    style: {
                      'p': Style(
                        fontSize: FontSize(16),
                        lineHeight: LineHeight(1.6),
                        color: AppColors.textMedium,
                      ),
                      'h3': Style(
                        fontSize: FontSize(20),
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      'strong': Style(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                      'em': Style(
                        fontStyle: FontStyle.italic,
                      ),
                    },
                  ),
                  SizedBox(height: AppDimensions.spaceMd),

                  // Tags
                  Wrap(
                    spacing: AppDimensions.spaceSm,
                    runSpacing: AppDimensions.spaceSm,
                    children: (_news['tags'] as List<dynamic>).map((tag) {
                      return Chip(
                        label: Text(
                          '#$tag',
                          style: const TextStyle(fontSize: 12),
                        ),
                        backgroundColor: AppColors.surfaceGray,
                      );
                    }).toList(),
                  ),
                  SizedBox(height: AppDimensions.spaceLg),

                  // Engagement stats
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatItem(
                        Icons.favorite,
                        '${_news['likeCount']}',
                        'Likes',
                      ),
                    ],
                  ),
                  SizedBox(height: AppDimensions.spaceLg),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: AppColors.unicefBlue, size: 24),
        SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.textDark,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textLight,
          ),
        ),
      ],
    );
  }

  String _formatDate(String isoDate) {
    final date = DateTime.parse(isoDate);
    final months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[date.month - 1]} ${date.day}, ${date.year}';
  }
}
