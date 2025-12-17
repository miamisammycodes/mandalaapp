import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// OTP Input Field Widget
///
/// A 6-digit OTP input with individual boxes for each digit.
/// Features auto-focus navigation between boxes and paste support.
class OtpInputField extends StatefulWidget {
  /// Callback when OTP is complete (6 digits entered)
  final ValueChanged<String> onCompleted;

  /// Callback when OTP changes
  final ValueChanged<String>? onChanged;

  /// Number of digits (default 6)
  final int length;

  /// Whether the field is enabled
  final bool enabled;

  /// Error message to display
  final String? errorText;

  /// Auto-focus first field on mount
  final bool autofocus;

  const OtpInputField({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 6,
    this.enabled = true,
    this.errorText,
    this.autofocus = true,
  });

  @override
  State<OtpInputField> createState() => OtpInputFieldState();
}

class OtpInputFieldState extends State<OtpInputField> {
  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      widget.length,
      (_) => TextEditingController(),
    );
    _focusNodes = List.generate(
      widget.length,
      (_) => FocusNode(),
    );

    // Auto-focus first field
    if (widget.autofocus) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && widget.enabled) {
          _focusNodes[0].requestFocus();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    for (final focusNode in _focusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  /// Get the current OTP value
  String get otp => _controllers.map((c) => c.text).join();

  /// Clear all fields
  void clear() {
    for (final controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _onChanged(int index, String value) {
    // Handle paste (multi-character input)
    if (value.length > 1) {
      _handlePaste(value);
      return;
    }

    // Move to next field if a digit was entered
    if (value.isNotEmpty && index < widget.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    // Notify callback
    final currentOtp = otp;
    widget.onChanged?.call(currentOtp);

    // Check if complete
    if (currentOtp.length == widget.length) {
      widget.onCompleted(currentOtp);
    }
  }

  void _handlePaste(String value) {
    // Extract only digits
    final digits = value.replaceAll(RegExp(r'[^0-9]'), '');

    // Fill the fields with pasted digits
    for (int i = 0; i < widget.length && i < digits.length; i++) {
      _controllers[i].text = digits[i];
    }

    // Focus the next empty field or last field
    final nextEmptyIndex = _controllers.indexWhere((c) => c.text.isEmpty);
    if (nextEmptyIndex != -1) {
      _focusNodes[nextEmptyIndex].requestFocus();
    } else {
      _focusNodes[widget.length - 1].requestFocus();
    }

    // Notify callbacks
    final currentOtp = otp;
    widget.onChanged?.call(currentOtp);

    if (currentOtp.length == widget.length) {
      widget.onCompleted(currentOtp);
    }
  }

  void _onKeyDown(int index, RawKeyEvent event) {
    // Handle backspace on empty field - move to previous
    if (event is RawKeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.backspace &&
        _controllers[index].text.isEmpty &&
        index > 0) {
      _focusNodes[index - 1].requestFocus();
      _controllers[index - 1].clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(widget.length, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 3,
              ),
              child: _OtpBox(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                enabled: widget.enabled,
                hasError: hasError,
                onChanged: (value) => _onChanged(index, value),
                onKeyEvent: (event) => _onKeyDown(index, event),
              ),
            );
          }),
        ),
        if (hasError) ...[
          SizedBox(height: AppDimensions.spaceSm),
          Center(
            child: Text(
              widget.errorText!,
              style: TextStyle(
                color: AppColors.error,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _OtpBox extends StatelessWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final bool enabled;
  final bool hasError;
  final ValueChanged<String> onChanged;
  final ValueChanged<RawKeyEvent> onKeyEvent;

  const _OtpBox({
    required this.controller,
    required this.focusNode,
    required this.enabled,
    required this.hasError,
    required this.onChanged,
    required this.onKeyEvent,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 44,
      height: 52,
      child: RawKeyboardListener(
        focusNode: FocusNode(),
        onKey: onKeyEvent,
        child: TextField(
          controller: controller,
          focusNode: focusNode,
          enabled: enabled,
          textAlign: TextAlign.center,
          keyboardType: TextInputType.number,
          maxLength: 1,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            counterText: '',
            filled: true,
            fillColor: enabled ? AppColors.cardWhite : AppColors.surfaceGray,
            contentPadding: EdgeInsets.zero,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.surfaceGray,
                width: 1.5,
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.surfaceGray,
                width: 1.5,
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: hasError ? AppColors.error : AppColors.unicefBlue,
                width: 2,
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              borderSide: BorderSide(
                color: AppColors.surfaceGray.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          onChanged: onChanged,
        ),
      ),
    );
  }
}
