import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/auth/child_profile.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/auth/pin_input_field.dart';

/// Child Login Screen
///
/// PIN entry screen for child authentication.
/// Features large, colorful buttons for child-friendly interaction.
class ChildLoginScreen extends ConsumerStatefulWidget {
  final ChildProfile child;

  const ChildLoginScreen({
    super.key,
    required this.child,
  });

  @override
  ConsumerState<ChildLoginScreen> createState() => _ChildLoginScreenState();
}

class _ChildLoginScreenState extends ConsumerState<ChildLoginScreen> {
  final _pinKey = GlobalKey<PinInputFieldState>();
  bool _isLoading = false;
  String? _errorText;

  Color get _avatarColor {
    switch (widget.child.ageGroup.label) {
      case 'Expecting':
        return AppColors.pastelPink;
      case '0-3 Years':
        return AppColors.pastelYellow;
      case '3-5 Years':
        return AppColors.pastelGreen;
      case '6-12 Years':
        return AppColors.pastelPurple;
      case '13-17 Years':
        return AppColors.skyBlue;
      default:
        return AppColors.softBlue;
    }
  }

  Future<void> _verifyPin(String pin) async {
    setState(() {
      _isLoading = true;
      _errorText = null;
    });

    final success = await ref.read(authStateProvider.notifier).switchToChild(
      childId: widget.child.id,
      pin: pin,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        // Navigate to home in child mode
        context.go('/');
      } else {
        setState(() {
          _errorText = 'Wrong PIN. Please try again.';
        });
        _pinKey.currentState?.clear();
      }
    }
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
              SizedBox(height: AppDimensions.spaceMd),

              // Avatar
              Center(
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: _avatarColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: _avatarColor.withValues(alpha: 0.5),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      widget.child.name.isNotEmpty
                          ? widget.child.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: AppDimensions.spaceLg),

              // Name
              Text(
                'Hi, ${widget.child.name}!',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spaceSm),
              Text(
                'Enter your PIN to continue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textMedium,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spaceXl * 2),

              // PIN Input with number pad (child-friendly)
              PinInputField(
                key: _pinKey,
                length: 4,
                showNumberPad: true,
                errorText: _errorText,
                enabled: !_isLoading,
                onCompleted: _verifyPin,
                onChanged: (_) {
                  if (_errorText != null) {
                    setState(() {
                      _errorText = null;
                    });
                  }
                },
              ),

              if (_isLoading) ...[
                SizedBox(height: AppDimensions.spaceXl),
                Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(_avatarColor),
                  ),
                ),
              ],

              SizedBox(height: AppDimensions.spaceXl * 2),

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
                        'Demo: Use PIN 1234 or the PIN you set',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: AppColors.textMedium,
                            ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
