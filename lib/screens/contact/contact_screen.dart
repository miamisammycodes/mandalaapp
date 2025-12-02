import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/dummy_data_service.dart';
import '../../widgets/shared/app_scaffold.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Contact screen for contacting UNICEF
class ContactScreen extends StatefulWidget {
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();
  final _dummyData = DummyDataService();

  String _selectedInquiryType = 'General Inquiry';
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  Map<String, dynamic>? _response;

  final List<String> _inquiryTypes = [
    'General Inquiry',
    'Partnership',
    'Donation',
    'Media',
    'Volunteering',
    'Other',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final response = _dummyData.generateContactResponse();

    setState(() {
      _isSubmitting = false;
      _isSubmitted = true;
      _response = response;
    });
  }

  void _resetForm() {
    setState(() {
      _isSubmitted = false;
      _response = null;
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _messageController.clear();
      _selectedInquiryType = 'General Inquiry';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Contact Us',
      body: _isSubmitted ? _buildSuccessView() : _buildFormView(),
    );
  }

  Widget _buildFormView() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(AppDimensions.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Contact info cards
          _buildContactInfoSection(),
          SizedBox(height: AppDimensions.spaceLg),

          // Form header
          Text(
            'Send us a Message',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
          ),
          SizedBox(height: AppDimensions.spaceSm),
          Text(
            'Fill out the form below and we\'ll get back to you.',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textMedium,
                ),
          ),
          SizedBox(height: AppDimensions.spaceLg),

          // Form
          Form(
            key: _formKey,
            child: Column(
              children: [
                // Name
                AppTextField(
                  controller: _nameController,
                  label: 'Full Name',
                  hintText: 'Enter your full name',
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.spaceMd),

                // Email
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
                SizedBox(height: AppDimensions.spaceMd),

                // Inquiry type
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Inquiry Type',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                    ),
                    SizedBox(height: AppDimensions.spaceSm),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedInquiryType,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius:
                              BorderRadius.circular(AppDimensions.radiusMd),
                        ),
                        filled: true,
                        fillColor: AppColors.cardWhite,
                        prefixIcon: Icon(Icons.category_outlined),
                      ),
                      items: _inquiryTypes.map((type) {
                        return DropdownMenuItem(value: type, child: Text(type));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => _selectedInquiryType = value!);
                      },
                    ),
                  ],
                ),
                SizedBox(height: AppDimensions.spaceMd),

                // Subject
                AppTextField(
                  controller: _subjectController,
                  label: 'Subject',
                  hintText: 'Brief subject of your message',
                  prefixIcon: Icons.subject,
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
                  hintText: 'Write your message here...',
                  minLines: 4,
                  maxLines: 8,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your message';
                    }
                    if (value.length < 20) {
                      return 'Please provide more details (at least 20 characters)';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.spaceLg),

                // Submit button
                AppButton(
                  text: 'Send Message',
                  onPressed: _handleSubmit,
                  isLoading: _isSubmitting,
                  icon: Icons.send,
                ),
                SizedBox(height: AppDimensions.spaceLg),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactInfoSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                icon: Icons.email_outlined,
                title: 'Email',
                subtitle: 'info@unicef.org',
                color: AppColors.unicefBlue,
              ),
            ),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: _buildContactCard(
                icon: Icons.phone_outlined,
                title: 'Phone',
                subtitle: '+1 (800) UNICEF',
                color: AppColors.success,
              ),
            ),
          ],
        ),
        SizedBox(height: AppDimensions.spaceMd),
        Row(
          children: [
            Expanded(
              child: _buildContactCard(
                icon: Icons.location_on_outlined,
                title: 'Address',
                subtitle: 'UNICEF House, NY',
                color: AppColors.warning,
              ),
            ),
            SizedBox(width: AppDimensions.spaceMd),
            Expanded(
              child: _buildContactCard(
                icon: Icons.access_time_outlined,
                title: 'Hours',
                subtitle: 'Mon-Fri, 9-5',
                color: AppColors.info,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactCard({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppDimensions.spaceMd),
        child: Column(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Icon(icon, color: color),
            ),
            SizedBox(height: AppDimensions.spaceSm),
            Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textLight,
              ),
            ),
            SizedBox(height: 2),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
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
              'Message Sent!',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceMd),
            Text(
              _response?['message'] ?? 'Thank you for contacting us.',
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
              child: Column(
                children: [
                  Text(
                    'Reference Number',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textLight,
                        ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    _response?['referenceNumber'] ?? 'N/A',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.unicefBlue,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spaceLg),
            AppButton(
              text: 'Send Another Message',
              onPressed: _resetForm,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }
}
