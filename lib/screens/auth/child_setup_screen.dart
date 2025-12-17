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

/// Child Setup Screen
///
/// Form for adding a new child profile.
/// Includes name, date of birth, and PIN setup.
class ChildSetupScreen extends ConsumerStatefulWidget {
  /// Whether this is the first child (onboarding flow)
  final bool isFirstChild;

  const ChildSetupScreen({
    super.key,
    this.isFirstChild = true,
  });

  @override
  ConsumerState<ChildSetupScreen> createState() => _ChildSetupScreenState();
}

class _ChildSetupScreenState extends ConsumerState<ChildSetupScreen> {
  final _nameController = TextEditingController();
  DateTime? _dateOfBirth;
  String _pin = '';
  String _confirmPin = '';
  bool _isLoading = false;
  String? _errorText;
  int _currentStep = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _canProceedStep1 => _nameController.text.trim().isNotEmpty;
  bool get _canProceedStep2 => _dateOfBirth != null;
  bool get _canProceedStep3 => _pin.length >= 4;
  bool get _canComplete => _confirmPin.length >= 4 && _pin == _confirmPin;

  Future<void> _addChild() async {
    if (_pin != _confirmPin) {
      setState(() {
        _errorText = 'PINs do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final success = await ref.read(authStateProvider.notifier).addChild(
      name: _nameController.text.trim(),
      dateOfBirth: _dateOfBirth!,
      pin: _pin,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Navigate to profile selection or home
        if (widget.isFirstChild) {
          context.go('/auth/select-profile');
        } else {
          context.pop();
        }
      } else {
        setState(() {
          _errorText = 'Failed to add child. Please try again.';
        });
      }
    }
  }

  void _nextStep() {
    if (_currentStep < 3) {
      setState(() {
        _currentStep++;
      });
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      setState(() {
        _currentStep--;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: Icon(Icons.arrow_back, color: AppColors.textDark),
                onPressed: _previousStep,
              )
            : (widget.isFirstChild
                ? null
                : IconButton(
                    icon: Icon(Icons.close, color: AppColors.textDark),
                    onPressed: () => context.pop(),
                  )),
        title: Text(
          widget.isFirstChild ? 'Add Your Child' : 'Add Child',
          style: TextStyle(
            color: AppColors.textDark,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _StepIndicator(
              currentStep: _currentStep,
              totalSteps: 4,
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(AppDimensions.spaceXl),
                child: _buildStepContent(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case 0:
        return _buildStep1Name();
      case 1:
        return _buildStep2DateOfBirth();
      case 2:
        return _buildStep3Pin();
      case 3:
        return _buildStep4ConfirmPin();
      default:
        return const SizedBox();
    }
  }

  /// Step 1: Child's name
  Widget _buildStep1Name() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.pastelPurple,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.child_care,
              size: 40,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spaceLg),

        Text(
          "What's your child's name?",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        Text(
          'This will be used to personalize their experience',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceXl * 2),

        AppTextField(
          controller: _nameController,
          label: "Child's Name",
          hintText: 'Enter name',
          textCapitalization: TextCapitalization.words,
          autofocus: true,
          onChanged: (_) => setState(() {}),
        ),
        SizedBox(height: AppDimensions.spaceXl),

        AppButton(
          text: 'Continue',
          onPressed: _canProceedStep1 ? _nextStep : null,
          width: double.infinity,
        ),

        if (widget.isFirstChild) ...[
          SizedBox(height: AppDimensions.spaceLg),
          TextButton(
            onPressed: () {
              // Skip adding child and go to home
              context.go('/');
            },
            child: Text(
              'Skip for now',
              style: TextStyle(color: AppColors.textMedium),
            ),
          ),
        ],
      ],
    );
  }

  /// Step 2: Date of birth
  Widget _buildStep2DateOfBirth() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.pastelYellow,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.cake_outlined,
              size: 40,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spaceLg),

        Text(
          "When was ${_nameController.text.split(' ').first} born?",
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        Text(
          'We use this to show age-appropriate content',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceXl * 2),

        DateOfBirthPicker(
          label: 'Date of Birth',
          hintText: 'Select date of birth',
          initialDate: _dateOfBirth,
          allowFutureDates: true, // Allow due dates for expecting parents
          onDateSelected: (date) {
            setState(() {
              _dateOfBirth = date;
            });
          },
        ),
        SizedBox(height: AppDimensions.spaceMd),

        // Info about future dates
        Container(
          padding: EdgeInsets.all(AppDimensions.spaceMd),
          decoration: BoxDecoration(
            color: AppColors.pastelPink.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
          ),
          child: Row(
            children: [
              Icon(
                Icons.pregnant_woman,
                color: AppColors.textMedium,
                size: 20,
              ),
              SizedBox(width: AppDimensions.spaceSm),
              Expanded(
                child: Text(
                  'Expecting? Select the due date to get pregnancy-related content',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.textMedium,
                      ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppDimensions.spaceXl),

        AppButton(
          text: 'Continue',
          onPressed: _canProceedStep2 ? _nextStep : null,
          width: double.infinity,
        ),
      ],
    );
  }

  /// Step 3: Set PIN
  Widget _buildStep3Pin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.pastelGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.lock_outline,
              size: 40,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spaceLg),

        Text(
          'Create a PIN for ${_nameController.text.split(' ').first}',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        Text(
          'This PIN will be used when your child logs in',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceXl * 2),

        PinTextField(
          label: '4-digit PIN',
          length: 4,
          autofocus: true,
          onCompleted: (pin) {
            setState(() {
              _pin = pin;
            });
            _nextStep();
          },
          onChanged: (pin) {
            setState(() {
              _pin = pin;
            });
          },
        ),
        SizedBox(height: AppDimensions.spaceXl),

        AppButton(
          text: 'Continue',
          onPressed: _canProceedStep3 ? _nextStep : null,
          width: double.infinity,
        ),
      ],
    );
  }

  /// Step 4: Confirm PIN
  Widget _buildStep4ConfirmPin() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Icon
        Center(
          child: Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: AppColors.pastelGreen,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle_outline,
              size: 40,
              color: AppColors.textDark,
            ),
          ),
        ),
        SizedBox(height: AppDimensions.spaceLg),

        Text(
          'Confirm the PIN',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceSm),
        Text(
          'Enter the PIN again to confirm',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textMedium,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceXl * 2),

        PinTextField(
          label: 'Confirm PIN',
          length: 4,
          autofocus: true,
          errorText: _errorText,
          onCompleted: (pin) {
            setState(() {
              _confirmPin = pin;
            });
            if (_pin == pin) {
              _addChild();
            } else {
              setState(() {
                _errorText = 'PINs do not match';
              });
            }
          },
          onChanged: (pin) {
            setState(() {
              _confirmPin = pin;
              if (_errorText != null) {
                _errorText = null;
              }
            });
          },
        ),
        SizedBox(height: AppDimensions.spaceXl),

        AppButton(
          text: 'Add Child',
          onPressed: _canComplete && !_isLoading ? _addChild : null,
          isLoading: _isLoading,
          width: double.infinity,
        ),
      ],
    );
  }
}

/// Step progress indicator
class _StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const _StepIndicator({
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceXl,
        vertical: AppDimensions.spaceMd,
      ),
      child: Row(
        children: List.generate(totalSteps, (index) {
          final isCompleted = index < currentStep;
          final isCurrent = index == currentStep;

          return Expanded(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 2),
              height: 4,
              decoration: BoxDecoration(
                color: isCompleted || isCurrent
                    ? AppColors.unicefBlue
                    : AppColors.surfaceGray,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }
}
