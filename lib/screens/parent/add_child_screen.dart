import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/auth/date_of_birth_picker.dart';
import '../../widgets/auth/pin_input_field.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Add Child Screen
///
/// Form to add a new child profile.
/// Includes name, date of birth, and PIN setup.
class AddChildScreen extends ConsumerStatefulWidget {
  const AddChildScreen({super.key});

  @override
  ConsumerState<AddChildScreen> createState() => _AddChildScreenState();
}

class _AddChildScreenState extends ConsumerState<AddChildScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _pinController = TextEditingController();
  final _confirmPinController = TextEditingController();
  DateTime? _dateOfBirth;
  bool _isLoading = false;
  bool _isExpecting = false;
  String? _dateError;
  String? _pinError;

  @override
  void dispose() {
    _nameController.dispose();
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    return _nameController.text.trim().isNotEmpty &&
        _dateOfBirth != null &&
        _pinController.text.length >= 4 &&
        _confirmPinController.text == _pinController.text;
  }

  Future<void> _addChild() async {
    // Validate form
    if (!_formKey.currentState!.validate()) return;

    if (_dateOfBirth == null) {
      setState(() {
        _dateError = 'Please select a date of birth';
      });
      return;
    }

    if (_pinController.text.length < 4) {
      setState(() {
        _pinError = 'PIN must be at least 4 digits';
      });
      return;
    }

    if (_pinController.text != _confirmPinController.text) {
      setState(() {
        _pinError = 'PINs do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _dateError = null;
      _pinError = null;
    });

    final success = await ref.read(authStateProvider.notifier).addChild(
      name: _nameController.text.trim(),
      dateOfBirth: _dateOfBirth!,
      pin: _pinController.text,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_nameController.text} has been added'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to add child. Please try again.'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.unicefBlue,
        elevation: 0,
        title: Text(
          'Add Child',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.close, color: Colors.white),
          onPressed: () => context.pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Info card
              Container(
                padding: EdgeInsets.all(AppDimensions.spaceMd),
                decoration: BoxDecoration(
                  color: AppColors.pastelPurple.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.info_outline,
                      color: AppColors.textMedium,
                      size: 20,
                    ),
                    SizedBox(width: AppDimensions.spaceSm),
                    Expanded(
                      child: Text(
                        'Add your child to personalize their learning experience with age-appropriate content.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMedium,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spaceXl),

              // Name field
              AppTextField(
                controller: _nameController,
                label: "Child's Name",
                hintText: 'Enter name',
                textCapitalization: TextCapitalization.words,
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppDimensions.spaceLg),

              // Expecting toggle
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.surfaceGray),
                ),
                child: SwitchListTile(
                  title: Text(
                    'Expecting a baby?',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color: AppColors.textDark,
                    ),
                  ),
                  subtitle: Text(
                    'Toggle on to enter expected due date',
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.textMedium,
                    ),
                  ),
                  value: _isExpecting,
                  onChanged: (value) {
                    setState(() {
                      _isExpecting = value;
                      _dateOfBirth = null; // Reset date when toggling
                    });
                  },
                  activeColor: AppColors.unicefBlue,
                  secondary: Icon(
                    Icons.pregnant_woman,
                    color: _isExpecting ? AppColors.unicefBlue : AppColors.textLight,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spaceLg),

              // Date of birth picker
              DateOfBirthPicker(
                label: _isExpecting ? 'Expected Due Date' : 'Date of Birth',
                hintText: _isExpecting
                    ? 'Select expected due date'
                    : 'Select date of birth',
                initialDate: _dateOfBirth,
                allowFutureDates: _isExpecting,
                errorText: _dateError,
                onDateSelected: (date) {
                  setState(() {
                    _dateOfBirth = date;
                    _dateError = null;
                  });
                },
              ),
              SizedBox(height: AppDimensions.spaceXl),

              // PIN section
              Text(
                'Set a PIN',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
              ),
              SizedBox(height: AppDimensions.spaceXs),
              Text(
                'Your child will use this PIN to log in',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: AppColors.textMedium,
                    ),
              ),
              SizedBox(height: AppDimensions.spaceMd),

              // PIN field
              PinTextField(
                label: '4-digit PIN',
                length: 4,
                onCompleted: (pin) {},
                onChanged: (pin) {
                  _pinController.text = pin;
                  setState(() {
                    _pinError = null;
                  });
                },
                errorText: _pinError,
              ),
              SizedBox(height: AppDimensions.spaceMd),

              // Confirm PIN field
              PinTextField(
                label: 'Confirm PIN',
                length: 4,
                onCompleted: (pin) {},
                onChanged: (pin) {
                  _confirmPinController.text = pin;
                  setState(() {
                    if (_pinController.text.isNotEmpty &&
                        pin.length == 4 &&
                        pin != _pinController.text) {
                      _pinError = 'PINs do not match';
                    } else {
                      _pinError = null;
                    }
                  });
                },
              ),
              SizedBox(height: AppDimensions.spaceXl * 2),

              // Add button
              AppButton(
                text: 'Add Child',
                onPressed: _isFormValid && !_isLoading ? _addChild : null,
                isLoading: _isLoading,
                width: double.infinity,
              ),
              SizedBox(height: AppDimensions.spaceMd),

              // Cancel button
              AppButton.secondary(
                text: 'Cancel',
                onPressed: _isLoading ? null : () => context.pop(),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
