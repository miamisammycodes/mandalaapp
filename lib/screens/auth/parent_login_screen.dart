import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/shared/app_button.dart';

/// Parent Login Screen
///
/// Phone number input for parent authentication.
/// Sends OTP to the entered phone number.
class ParentLoginScreen extends ConsumerStatefulWidget {
  const ParentLoginScreen({super.key});

  @override
  ConsumerState<ParentLoginScreen> createState() => _ParentLoginScreenState();
}

class _ParentLoginScreenState extends ConsumerState<ParentLoginScreen> {
  final _phoneController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  String? _errorText;

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _sendOtp() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final phone = _phoneController.text.trim();
    final success = await ref.read(otpStateProvider.notifier).sendOtp(phone);

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        context.push('/auth/otp', extra: phone);
      } else {
        final otpState = ref.read(otpStateProvider);
        setState(() {
          _errorText = otpState.error ?? 'Failed to send OTP';
        });
      }
    }
  }

  String? _validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    }
    // Remove any non-digit characters for validation
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');
    if (digits.length < 8) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spaceXl),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppDimensions.spaceXl),

                // Logo/Icon
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.unicefBlue.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.phone_android,
                      size: 48,
                      color: AppColors.unicefBlue,
                    ),
                  ),
                ),
                SizedBox(height: AppDimensions.spaceXl),

                // Title
                Text(
                  'Welcome',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spaceSm),
                Text(
                  'Enter your phone number to get started',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textMedium,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spaceXl * 2),

                // Phone input
                _PhoneInputField(
                  controller: _phoneController,
                  errorText: _errorText,
                  onSubmitted: (_) => _sendOtp(),
                  validator: _validatePhone,
                ),
                SizedBox(height: AppDimensions.spaceXl),

                // Continue button
                AppButton(
                  text: 'Continue',
                  onPressed: _isLoading ? null : _sendOtp,
                  isLoading: _isLoading,
                  width: double.infinity,
                ),
                SizedBox(height: AppDimensions.spaceLg),

                // Demo hint
                Container(
                  padding: EdgeInsets.all(AppDimensions.spaceMd),
                  decoration: BoxDecoration(
                    color: AppColors.pastelYellow.withValues(alpha: 0.5),
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
                          'Demo: Enter any phone number and use code 123456',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMedium,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppDimensions.spaceXl * 2),

                // Back to language selection
                TextButton.icon(
                  onPressed: () => context.go('/language'),
                  icon: Icon(Icons.arrow_back, size: 18),
                  label: Text('Change language'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Phone input field with country code
class _PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final FormFieldValidator<String>? validator;

  const _PhoneInputField({
    required this.controller,
    this.errorText,
    this.onSubmitted,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Phone Number',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
            fontSize: 14,
          ),
        ),
        SizedBox(height: AppDimensions.spaceSm),
        TextFormField(
          controller: controller,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.done,
          autofocus: true,
          style: TextStyle(
            fontSize: 18,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            hintText: 'Enter phone number',
            hintStyle: TextStyle(
              color: AppColors.textLight,
              fontSize: 18,
            ),
            errorText: errorText,
            prefixIcon: Container(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceMd),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '🇧🇹',
                    style: TextStyle(fontSize: 24),
                  ),
                  SizedBox(width: AppDimensions.spaceSm),
                  Text(
                    '+975',
                    style: TextStyle(
                      fontSize: 18,
                      color: AppColors.textDark,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(width: AppDimensions.spaceSm),
                  Container(
                    height: 24,
                    width: 1,
                    color: AppColors.surfaceGray,
                  ),
                ],
              ),
            ),
            filled: true,
            fillColor: AppColors.cardWhite,
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceMd,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: AppColors.surfaceGray,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.error : AppColors.surfaceGray,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: errorText != null ? AppColors.error : AppColors.unicefBlue,
                width: 2,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: AppColors.error,
                width: 1.5,
              ),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(15),
          ],
          validator: validator,
          onFieldSubmitted: onSubmitted,
        ),
      ],
    );
  }
}
