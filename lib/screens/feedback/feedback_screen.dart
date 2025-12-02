import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/dummy_data_service.dart';
import '../../widgets/shared/app_scaffold.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Feedback screen for viewing and submitting feedback
class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final _dummyData = DummyDataService();
  late List<Map<String, dynamic>> _feedbackList;

  // Form state
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  String _selectedCategory = 'General';
  bool _isSubmitting = false;

  final List<String> _categories = [
    'General',
    'Bug Report',
    'Feature Request',
    'Complaint',
    'Praise',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _loadFeedback();
  }

  void _loadFeedback() {
    _feedbackList = _dummyData.generateFeedbackList(count: 10);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    setState(() => _isSubmitting = false);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Feedback submitted successfully!'),
          backgroundColor: AppColors.success,
        ),
      );

      // Clear form
      _subjectController.clear();
      _messageController.clear();
      setState(() => _selectedCategory = 'General');

      // Switch to list tab
      _tabController.animateTo(0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Feedback',
      bottom: TabBar(
        controller: _tabController,
        labelColor: Colors.white,
        unselectedLabelColor: Colors.white70,
        indicatorColor: Colors.white,
        tabs: const [
          Tab(text: 'My Feedback'),
          Tab(text: 'Submit New'),
        ],
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildFeedbackList(),
          _buildSubmitForm(),
        ],
      ),
    );
  }

  Widget _buildFeedbackList() {
    if (_feedbackList.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.feedback_outlined,
              size: 64,
              color: AppColors.textLight,
            ),
            SizedBox(height: AppDimensions.spaceMd),
            Text(
              'No feedback yet',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceSm),
            Text(
              'Submit your first feedback to see it here',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        setState(() => _loadFeedback());
      },
      child: ListView.builder(
        padding: EdgeInsets.all(AppDimensions.spaceMd),
        itemCount: _feedbackList.length,
        itemBuilder: (context, index) {
          return _buildFeedbackCard(_feedbackList[index]);
        },
      ),
    );
  }

  Widget _buildFeedbackCard(Map<String, dynamic> feedback) {
    final status = feedback['status'] as String;
    final hasResponse = feedback['response'] != null;

    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceMd),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: AppDimensions.spaceSm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getCategoryColor(feedback['category'])
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  child: Text(
                    feedback['category'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
                const Spacer(),
                _buildStatusChip(status),
              ],
            ),
            SizedBox(height: AppDimensions.spaceSm),

            // Subject
            Text(
              feedback['subject'],
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceSm),

            // Message
            Text(
              feedback['message'],
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            // Response
            if (hasResponse) ...[
              SizedBox(height: AppDimensions.spaceMd),
              Container(
                padding: EdgeInsets.all(AppDimensions.spaceSm),
                decoration: BoxDecoration(
                  color: AppColors.surfaceGray,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.reply,
                          size: 16,
                          color: AppColors.unicefBlue,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Response',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.unicefBlue,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      feedback['response'],
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMedium,
                          ),
                    ),
                  ],
                ),
              ),
            ],

            SizedBox(height: AppDimensions.spaceSm),

            // Date
            Text(
              _formatDate(feedback['createdAt']),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    final statusColors = {
      'pending': AppColors.warning,
      'in_review': AppColors.info,
      'responded': AppColors.success,
      'closed': AppColors.textLight,
    };

    final statusLabels = {
      'pending': 'Pending',
      'in_review': 'In Review',
      'responded': 'Responded',
      'closed': 'Closed',
    };

    final color = statusColors[status] ?? AppColors.textLight;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        statusLabels[status] ?? status,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }

  Widget _buildSubmitForm() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spaceMd),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Info card
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.info.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                border: Border.all(color: AppColors.info.withValues(alpha: 0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: AppColors.unicefBlue),
                  SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    child: Text(
                      'We value your feedback. It helps us improve our services.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textMedium,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spaceLg),

            // Category dropdown
            Text(
              'Category',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceSm),
            DropdownButtonFormField<String>(
              value: _selectedCategory,
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                filled: true,
                fillColor: AppColors.cardWhite,
              ),
              items: _categories.map((category) {
                return DropdownMenuItem(value: category, child: Text(category));
              }).toList(),
              onChanged: (value) {
                setState(() => _selectedCategory = value!);
              },
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Subject
            AppTextField(
              controller: _subjectController,
              label: 'Subject',
              hintText: 'Brief subject of your feedback',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a subject';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Message
            AppTextField.multiline(
              controller: _messageController,
              label: 'Message',
              hintText: 'Describe your feedback in detail',
              minLines: 4,
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide your feedback';
                }
                if (value.length < 10) {
                  return 'Please provide more details (at least 10 characters)';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spaceLg),

            // Submit button
            AppButton(
              text: 'Submit Feedback',
              onPressed: _handleSubmit,
              isLoading: _isSubmitting,
              icon: Icons.send,
            ),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Bug Report':
        return AppColors.error;
      case 'Feature Request':
        return AppColors.info;
      case 'Complaint':
        return AppColors.warning;
      case 'Praise':
        return AppColors.success;
      default:
        return AppColors.unicefBlue;
    }
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
