import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/auth/otp_input_field.dart';

/// OTP Verification Screen
///
/// 6-digit OTP input for verifying phone number.
/// Includes resend functionality with countdown timer.
class OtpVerificationScreen extends ConsumerStatefulWidget {
  final String phoneNumber;

  const OtpVerificationScreen({
    super.key,
    required this.phoneNumber,
  });

  @override
  ConsumerState<OtpVerificationScreen> createState() =>
      _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends ConsumerState<OtpVerificationScreen> {
  final _otpKey = GlobalKey<OtpInputFieldState>();
  bool _isLoading = false;
  String? _errorText;
  int _resendCountdown = 60;
  Timer? _resendTimer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendCountdown = 60;
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          if (_resendCountdown > 0) {
            _resendCountdown--;
          } else {
            timer.cancel();
          }
        });
      }
    });
  }

  Future<void> _verifyOtp(String otp) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final otpNotifier = ref.read(otpStateProvider.notifier);
    final parent = await otpNotifier.verifyOtp(otp);

    if (mounted) {
      if (parent != null) {
        // Login successful, create session
        final authNotifier = ref.read(authStateProvider.notifier);
        final success = await authNotifier.loginWithOtp(parent);

        if (mounted && success) {
          // Check if parent has children
          final hasChildren = ref.read(hasChildrenProvider);
          if (hasChildren) {
            // Go to profile selection
            context.go('/auth/select-profile');
          } else {
            // Go to child setup (first child)
            context.go('/auth/child-setup');
          }
        }
      } else {
        final otpState = ref.read(otpStateProvider);
        setState(() {
          _isLoading = false;
          _errorText = otpState.error ?? 'Invalid OTP code';
        });
        _otpKey.currentState?.clear();
      }
    }
  }

  Future<void> _resendOtp() async {
    if (_resendCountdown > 0) return;

    setState(() {
      _errorText = null;
    });

    final success = await ref.read(otpStateProvider.notifier).resendOtp();

    if (mounted) {
      if (success) {
        _startResendTimer();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('OTP sent successfully'),
            backgroundColor: AppColors.success,
          ),
        );
      } else {
        final otpState = ref.read(otpStateProvider);
        setState(() {
          _errorText = otpState.error ?? 'Failed to resend OTP';
        });
      }
    }
  }

  String _formatPhone(String phone) {
    // Format phone for display: +975 XX XXX XXX
    if (phone.length >= 8) {
      return '+975 ${phone.substring(0, 2)} ${phone.substring(2, 5)} ${phone.substring(5)}';
    }
    return '+975 $phone';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.textDark),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(AppDimensions.spaceXl),
          child: Column(
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
                    Icons.sms_outlined,
                    size: 40,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spaceLg),

              // Title
              Text(
                'Verify Your Number',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spaceSm),
              Text(
                'Enter the 6-digit code sent to',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textMedium,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spaceXs),
              Text(
                _formatPhone(widget.phoneNumber),
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.unicefBlue,
                      fontWeight: FontWeight.w600,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spaceXl * 2),

              // OTP Input
              OtpInputField(
                key: _otpKey,
                onCompleted: _verifyOtp,
                enabled: !_isLoading,
                errorText: _errorText,
              ),
              SizedBox(height: AppDimensions.spaceXl),

              // Loading indicator or verify button
              if (_isLoading)
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.unicefBlue),
                      ),
                      SizedBox(height: AppDimensions.spaceMd),
                      Text(
                        'Verifying...',
                        style: TextStyle(
                          color: AppColors.textMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              SizedBox(height: AppDimensions.spaceXl),

              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive the code? ",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.textMedium,
                        ),
                  ),
                  if (_resendCountdown > 0)
                    Text(
                      'Resend in ${_resendCountdown}s',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppColors.textLight,
                          ),
                    )
                  else
                    GestureDetector(
                      onTap: _resendOtp,
                      child: Text(
                        'Resend',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppColors.unicefBlue,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
