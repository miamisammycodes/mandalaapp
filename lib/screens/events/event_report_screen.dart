import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/services/dummy_data_service.dart';
import '../../widgets/shared/app_scaffold.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Event/Incident report screen for reporting child protection concerns
class EventReportScreen extends StatefulWidget {
  const EventReportScreen({super.key});

  @override
  State<EventReportScreen> createState() => _EventReportScreenState();
}

class _EventReportScreenState extends State<EventReportScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _dummyData = DummyDataService();

  String _selectedCategory = 'General Concern';
  String _selectedUrgency = 'Medium';
  bool _isAnonymous = false;
  bool _isSubmitting = false;
  bool _isSubmitted = false;
  Map<String, dynamic>? _response;

  final List<String> _categories = [
    'General Concern',
    'Child Abuse',
    'Child Labor',
    'Child Marriage',
    'Trafficking',
    'Neglect',
    'Violence',
    'Other',
  ];

  final List<String> _urgencyLevels = ['Low', 'Medium', 'High', 'Critical'];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    final response = _dummyData.generateEventReportResponse();

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
      _titleController.clear();
      _descriptionController.clear();
      _locationController.clear();
      _selectedCategory = 'General Concern';
      _selectedUrgency = 'Medium';
      _isAnonymous = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      title: 'Report Event',
      body: _isSubmitted ? _buildSuccessView() : _buildFormView(),
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
                      'Your report will be handled confidentially. You can choose to remain anonymous.',
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
              initialValue: _selectedCategory,
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

            // Title
            AppTextField(
              controller: _titleController,
              label: 'Title',
              hintText: 'Brief title of the incident',
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter a title';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Description
            AppTextField.multiline(
              controller: _descriptionController,
              label: 'Description',
              hintText: 'Describe the incident in detail',
              minLines: 4,
              maxLines: 8,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide a description';
                }
                if (value.length < 20) {
                  return 'Please provide more details (at least 20 characters)';
                }
                return null;
              },
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Location
            AppTextField(
              controller: _locationController,
              label: 'Location (Optional)',
              hintText: 'Where did this happen?',
              prefixIcon: Icons.location_on_outlined,
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Urgency
            Text(
              'Urgency Level',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceSm),
            Row(
              children: _urgencyLevels.map((level) {
                final isSelected = level == _selectedUrgency;
                return Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(
                      right: level != _urgencyLevels.last ? 8 : 0,
                    ),
                    child: ChoiceChip(
                      label: Text(level),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() => _selectedUrgency = level);
                      },
                      selectedColor: _getUrgencyColor(level),
                      labelStyle: TextStyle(
                        color: isSelected ? Colors.white : AppColors.textMedium,
                        fontSize: 12,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Anonymous toggle
            SwitchListTile(
              title: const Text('Submit Anonymously'),
              subtitle: const Text('Your identity will not be shared'),
              value: _isAnonymous,
              onChanged: (value) {
                setState(() => _isAnonymous = value);
              },
              activeThumbColor: AppColors.unicefBlue,
              contentPadding: EdgeInsets.zero,
            ),
            SizedBox(height: AppDimensions.spaceLg),

            // Submit button
            AppButton(
              text: 'Submit Report',
              onPressed: _handleSubmit,
              isLoading: _isSubmitting,
              icon: Icons.send,
            ),
            SizedBox(height: AppDimensions.spaceLg),
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
              'Report Submitted',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
            ),
            SizedBox(height: AppDimensions.spaceMd),
            Text(
              _response?['message'] ?? 'Your report has been submitted successfully.',
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
              text: 'Submit Another Report',
              onPressed: _resetForm,
              variant: AppButtonVariant.secondary,
            ),
          ],
        ),
      ),
    );
  }

  Color _getUrgencyColor(String level) {
    switch (level) {
      case 'Low':
        return AppColors.success;
      case 'Medium':
        return AppColors.warning;
      case 'High':
        return Colors.orange;
      case 'Critical':
        return AppColors.error;
      default:
        return AppColors.unicefBlue;
    }
  }
}
