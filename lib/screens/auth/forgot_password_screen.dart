import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Forgot password screen for password reset requests
class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _isSubmitted = false;
  String? _successMessage;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authNotifier = ref.read(authStateProvider.notifier);

    final message = await authNotifier.forgotPassword(
      email: _emailController.text.trim(),
    );

    if (message != null && mounted) {
      setState(() {
        _isSubmitted = true;
        _successMessage = message;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.goNamed(AppRoutes.login),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spaceLg),
          child:
              _isSubmitted ? _buildSuccessState() : _buildFormState(authState),
        ),
      ),
    );
  }

  Widget _buildFormState(authState) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: AppDimensions.spaceXl),

          // Icon
          const Icon(
            Icons.lock_reset,
            size: 80,
            color: AppColors.unicefBlue,
          ),
          SizedBox(height: AppDimensions.spaceLg),

          // Title
          Text(
            'Forgot Password?',
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: AppColors.textDark,
                  fontWeight: FontWeight.bold,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spaceSm),

          // Subtitle
          Text(
            "Enter your email address and we'll send you instructions to reset your password.",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.textMedium,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spaceXl),

          // Error message
          if (authState.error != null) ...[
            Container(
              padding: EdgeInsets.all(AppDimensions.spaceMd),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
                border: Border.all(
                  color: AppColors.error.withValues(alpha: 0.3),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.error_outline,
                    color: AppColors.error,
                    size: 20,
                  ),
                  SizedBox(width: AppDimensions.spaceSm),
                  Expanded(
                    child: Text(
                      authState.error!,
                      style: const TextStyle(color: AppColors.error),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: AppDimensions.spaceMd),
          ],

          // Email field
          AppTextField.email(
            controller: _emailController,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required';
              }
              if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
                return 'Please enter a valid email';
              }
              return null;
            },
          ),
          SizedBox(height: AppDimensions.spaceLg),

          // Submit button
          AppButton(
            text: 'Send Reset Instructions',
            onPressed: _handleSubmit,
            isLoading: authState.isLoading,
          ),
          SizedBox(height: AppDimensions.spaceLg),

          // Back to login
          TextButton(
            onPressed: () => context.goNamed(AppRoutes.login),
            child: const Text('Back to Login'),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: AppDimensions.spaceXl * 2),

        // Success icon
        Center(
          child: Container(
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
        ),
        SizedBox(height: AppDimensions.spaceLg),

        // Title
        Text(
          'Check Your Email',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceMd),

        // Success message
        Text(
          _successMessage ?? 'Password reset instructions have been sent.',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.textMedium,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceSm),

        // Additional info
        Text(
          "If you don't receive an email within a few minutes, check your spam folder.",
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.textLight,
              ),
          textAlign: TextAlign.center,
        ),
        SizedBox(height: AppDimensions.spaceXl),

        // Back to login button
        AppButton(
          text: 'Back to Login',
          onPressed: () => context.goNamed(AppRoutes.login),
        ),
        SizedBox(height: AppDimensions.spaceMd),

        // Resend link
        TextButton(
          onPressed: () {
            setState(() {
              _isSubmitted = false;
              _successMessage = null;
            });
          },
          child: const Text("Didn't receive email? Try again"),
        ),
      ],
    );
  }
}
