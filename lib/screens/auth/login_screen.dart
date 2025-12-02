import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/router/app_router.dart';
import '../../main.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Login screen for user authentication
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final authNotifier = ref.read(authStateProvider.notifier);

    final success = await authNotifier.login(
      email: _emailController.text.trim(),
      password: _passwordController.text,
    );

    if (success && mounted) {
      // Show success snackbar - the router will handle navigation via redirect
      rootScaffoldMessengerKey.currentState?.showSnackBar(
        const SnackBar(
          content: Text('Logged in successfully!'),
          backgroundColor: Colors.green,
          duration: Duration(seconds: 2),
        ),
      );
      
      // Check if there's a redirect URL, otherwise router redirect will handle it
      final redirectUrl =
          GoRouterState.of(context).uri.queryParameters['redirect'];
      if (redirectUrl != null) {
        context.go(Uri.decodeComponent(redirectUrl));
      }
      // Note: If no redirect URL, the router's redirect logic will automatically
      // navigate to home since authenticated users can't be on auth routes
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
          onPressed: () => context.goNamed(AppRoutes.home),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spaceLg),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: AppDimensions.spaceLg),

                // Logo/Icon
                const Icon(
                  Icons.account_circle,
                  size: 80,
                  color: AppColors.unicefBlue,
                ),
                SizedBox(height: AppDimensions.spaceMd),

                // Title
                Text(
                  'Welcome Back',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColors.textDark,
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppDimensions.spaceSm),

                // Subtitle
                Text(
                  'Sign in to continue',
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
                    if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                        .hasMatch(value)) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.spaceMd),

                // Password field
                AppTextField.password(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Password is required';
                    }
                    return null;
                  },
                ),
                SizedBox(height: AppDimensions.spaceSm),

                // Forgot password link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () => context.goNamed(AppRoutes.forgotPassword),
                    child: const Text('Forgot Password?'),
                  ),
                ),
                SizedBox(height: AppDimensions.spaceLg),

                // Login button
                if (authState.isLoading)
                  const Center(
                    child: CircularProgressIndicator(),
                  )
                else
                  AppButton(
                    text: 'Login',
                    onPressed: _handleLogin,
                  ),
                SizedBox(height: AppDimensions.spaceLg),

                // Sign up link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textMedium,
                          ),
                    ),
                    TextButton(
                      onPressed: () => context.goNamed(AppRoutes.signup),
                      child: const Text(
                        'Sign Up',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
