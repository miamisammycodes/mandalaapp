import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/safety/safety_topic.dart';
import '../../providers/safety/safety_provider.dart';

/// Screen for reporting online safety concerns
class ReportConcernScreen extends ConsumerStatefulWidget {
  const ReportConcernScreen({super.key});

  @override
  ConsumerState<ReportConcernScreen> createState() =>
      _ReportConcernScreenState();
}

class _ReportConcernScreenState extends ConsumerState<ReportConcernScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _childNameController = TextEditingController();
  final _phoneController = TextEditingController();

  SafetyCategory? _selectedCategory;
  bool _isUrgent = false;
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    _childNameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submitReport() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a concern category'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    // Simulate API call
    await Future.delayed(const Duration(seconds: 1));

    if (!mounted) return;

    setState(() => _isSubmitting = false);

    // Show success dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        ),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle,
                color: AppColors.success,
              ),
            ),
            const SizedBox(width: AppDimensions.spaceSm),
            const Text('Report Submitted'),
          ],
        ),
        content: const Text(
          'Thank you for your report. Our team will review it and take appropriate action. If you provided contact details, we may reach out for more information.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final emergencyContacts = ref.watch(emergencyContactsProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.error,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        title: const Text(
          'Report a Concern',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppDimensions.spaceMd),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Emergency notice
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(
                    color: AppColors.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                    ),
                    const SizedBox(width: AppDimensions.spaceSm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'For Immediate Danger',
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.error,
                                ),
                          ),
                          Text(
                            'If a child is in immediate danger, call ${emergencyContacts.firstWhere((c) => c.isEmergency).phone} now',
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: AppColors.textMedium,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Category selection
              Text(
                'Type of Concern',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Select the category that best describes your concern',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              Wrap(
                spacing: AppDimensions.spaceXs,
                runSpacing: AppDimensions.spaceXs,
                children: SafetyCategory.values.map((category) {
                  final isSelected = _selectedCategory == category;
                  final color = _getCategoryColor(category);

                  return ChoiceChip(
                    label: Text(category.title),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = selected ? category : null;
                      });
                    },
                    selectedColor: color.withValues(alpha: 0.2),
                    labelStyle: TextStyle(
                      color: isSelected ? color : AppColors.textMedium,
                      fontWeight: isSelected ? FontWeight.w600 : null,
                    ),
                    avatar: isSelected
                        ? Icon(_getCategoryIcon(category),
                            size: 18, color: color)
                        : null,
                    side: BorderSide(
                      color: isSelected ? color : AppColors.textLight,
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Description
              Text(
                'Description',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              TextFormField(
                controller: _descriptionController,
                maxLines: 5,
                decoration: InputDecoration(
                  hintText: 'Please describe the concern in detail...',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                    borderSide: BorderSide(color: AppColors.textLight),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                    borderSide: BorderSide(color: AppColors.textLight),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                    borderSide: const BorderSide(color: AppColors.unicefBlue),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please describe the concern';
                  }
                  if (value.trim().length < 20) {
                    return 'Please provide more detail (at least 20 characters)';
                  }
                  return null;
                },
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Urgency toggle
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: SwitchListTile(
                  title: const Text('This is urgent'),
                  subtitle: const Text(
                    'Mark if this requires immediate attention',
                  ),
                  value: _isUrgent,
                  onChanged: (value) => setState(() => _isUrgent = value),
                  activeTrackColor: AppColors.error.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.error,
                  secondary: Icon(
                    _isUrgent ? Icons.priority_high : Icons.schedule,
                    color: _isUrgent ? AppColors.error : AppColors.textLight,
                  ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceLg),

              // Optional contact info
              Text(
                'Contact Information (Optional)',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Provide if you would like us to follow up with you',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              TextFormField(
                controller: _childNameController,
                decoration: InputDecoration(
                  labelText: 'Child\'s Name',
                  hintText: 'Optional',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  prefixIcon: const Icon(Icons.child_care),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceSm),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: 'Your Phone Number',
                  hintText: 'Optional',
                  filled: true,
                  fillColor: AppColors.cardWhite,
                  border: OutlineInputBorder(
                    borderRadius:
                        BorderRadius.circular(AppDimensions.radiusSm),
                  ),
                  prefixIcon: const Icon(Icons.phone),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),

              // Submit button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submitReport,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.error,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppDimensions.spaceMd,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(AppDimensions.radiusMd),
                    ),
                  ),
                  child: _isSubmitting
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Text(
                          'Submit Report',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: AppDimensions.spaceMd),

              // Privacy note
              Container(
                padding: const EdgeInsets.all(AppDimensions.spaceSm),
                decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.lock_outline,
                      size: 18,
                      color: AppColors.info,
                    ),
                    const SizedBox(width: AppDimensions.spaceXs),
                    Expanded(
                      child: Text(
                        'Your report is confidential and will be handled with care.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMedium,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppDimensions.spaceXl),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(SafetyCategory category) {
    switch (category) {
      case SafetyCategory.content:
        return const Color(0xFF9C27B0);
      case SafetyCategory.conduct:
        return const Color(0xFFFF9800);
      case SafetyCategory.contact:
        return const Color(0xFFE91E63);
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
