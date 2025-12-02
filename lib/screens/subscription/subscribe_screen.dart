import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/dummy_data_service.dart';
import '../../widgets/shared/app_scaffold.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Subscribe screen for email newsletter subscription
class SubscribeScreen extends StatefulWidget {
  const SubscribeScreen({super.key});

  @override
  State<SubscribeScreen> createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _dummyData = DummyDataService();

  bool _isSubmitting = false;
  bool _isSubscribed = false;
  Map<String, dynamic>? _response;

  // Subscription preferences
  bool _newsUpdates = true;
  bool _educationalContent = true;
  bool _eventNotifications = false;
  bool _monthlyNewsletter = true;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubscribe() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final response = _dummyData.generateSubscriptionResponse(_emailController.text);

    setState(() {
      _isSubmitting = false;
      _isSubscribed = true;
      _response = response;
    });
  }

  void _resetForm() {
    setState(() {
      _isSubscribed = false;
      _response = null;
      _emailController.clear();
      _newsUpdates = true;
      _educationalContent = true;
      _eventNotifications = false;
      _monthlyNewsletter = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Subscribe',
      body: _isSubscribed ? _buildSuccessView() : _buildFormView(),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spaceMd),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero section
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(AppDimensions.spaceLg),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.unicefBlue.withValues(alpha: 0.2),
                    AppColors.unicefBlue.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
              ),
              child: Column(
                children: [
                  Icon(
                    Icons.mail_outline,
                    size: 64,
                    color: AppColors.unicefBlue,
                  ),
                  SizedBox(height: AppDimensions.spaceMd),
                  Text(
                    'Stay Informed',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  SizedBox(height: AppDimensions.spaceSm),
                  Text(
                    'Subscribe to receive updates about child rights, news, and events from UNICEF.',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spaceLg),

            // Email field
            AppTextField.email(
              controller: _emailController,
              label: 'Email Address',
              hintText: 'Enter your email',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spaceLg),

            // Subscription preferences
            Text(
              'Subscription Preferences',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceSm),
            Text(
              'Choose what updates you would like to receive',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textMedium,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Preference checkboxes
            _buildPreferenceItem(
              'News Updates',
              'Latest news and announcements',
              _newsUpdates,
              (value) => setState(() => _newsUpdates = value!),
            ),
            _buildPreferenceItem(
              'Educational Content',
              'New educational resources and materials',
              _educationalContent,
              (value) => setState(() => _educationalContent = value!),
            ),
            _buildPreferenceItem(
              'Event Notifications',
              'Upcoming events and campaigns',
              _eventNotifications,
              (value) => setState(() => _eventNotifications = value!),
            ),
            _buildPreferenceItem(
              'Monthly Newsletter',
              'Monthly digest of all activities',
              _monthlyNewsletter,
              (value) => setState(() => _monthlyNewsletter = value!),
            ),

            SizedBox(height: AppDimensions.spaceLg),

            // Privacy note
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 20,
                    color: AppColors.textLight,
                  ),
                  SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    child: Text(
                      'We respect your privacy. You can unsubscribe anytime.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textLight,
                          ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spaceLg),

            // Subscribe button
            AppButton(
              text: 'Subscribe',
              onPressed: _handleSubscribe,
              isLoading: _isSubmitting,
              icon: Icons.notifications_active,
            ),
            SizedBox(height: AppDimensions.spaceLg),
          ],
        ),
      ),
    );
  }

  Widget _buildPreferenceItem(
    String title,
    String subtitle,
    bool value,
    ValueChanged<bool?> onChanged,
  ) {
    return Card(
      margin: EdgeInsets.only(bottom: AppDimensions.spaceSm),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: CheckboxListTile(
        title: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: TextStyle(
            fontSize: 12,
            color: AppColors.textMedium,
          ),
        ),
        value: value,
        onChanged: onChanged,
        activeColor: AppColors.unicefBlue,
        controlAffinity: ListTileControlAffinity.trailing,
      ),
    );
  }

  Widget _buildSuccessView() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceLg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                size: 60,
                color: AppColors.success,
              ),
            ),
            SizedBox(height: AppDimensions.spaceLg),
            Text(
              'Subscription Successful!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceMd),
            Text(
              _response?['message'] ?? 'Thank you for subscribing!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spaceMd),
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.email, color: AppColors.unicefBlue),
                  SizedBox(width: AppDimensions.spaceSm),
                  Text(
                    _response?['email'] ?? _emailController.text,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spaceLg),
            Text(
              'Please check your email to confirm your subscription.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textLight,
                  ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppDimensions.spaceLg),
            AppButton(
              text: 'Subscribe Another Email',
              onPressed: _resetForm,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
