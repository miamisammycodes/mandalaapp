import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';

/// PIN Input Field Widget
///
/// A numeric PIN input with dots/numbers display and optional number pad.
/// Used for child login and PIN setup.
class PinInputField extends StatefulWidget {
  /// Callback when PIN is complete
  final ValueChanged<String> onCompleted;

  /// Callback when PIN changes
  final ValueChanged<String>? onChanged;

  /// Number of digits (default 4)
  final int length;

  /// Whether the field is enabled
  final bool enabled;

  /// Error message to display
  final String? errorText;

  /// Whether to show the number pad (child-friendly mode)
  final bool showNumberPad;

  /// Whether to obscure the PIN (show dots instead of numbers)
  final bool obscure;

  /// Title text above the PIN display
  final String? title;

  /// Subtitle text below the title
  final String? subtitle;

  const PinInputField({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 4,
    this.enabled = true,
    this.errorText,
    this.showNumberPad = false,
    this.obscure = true,
    this.title,
    this.subtitle,
  });

  @override
  State<PinInputField> createState() => PinInputFieldState();
}

class PinInputFieldState extends State<PinInputField> {
  String _pin = '';

  /// Get the current PIN value
  String get pin => _pin;

  /// Clear the PIN
  void clear() {
    setState(() {
      _pin = '';
    });
    widget.onChanged?.call(_pin);
  }

  void _addDigit(String digit) {
    if (_pin.length >= widget.length || !widget.enabled) return;

    setState(() {
      _pin += digit;
    });

    widget.onChanged?.call(_pin);

    if (_pin.length == widget.length) {
      widget.onCompleted(_pin);
    }
  }

  void _removeDigit() {
    if (_pin.isEmpty || !widget.enabled) return;

    setState(() {
      _pin = _pin.substring(0, _pin.length - 1);
    });

    widget.onChanged?.call(_pin);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Title
        if (widget.title != null) ...[
          Text(
            widget.title!,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
            textAlign: TextAlign.center,
          ),
          if (widget.subtitle != null) ...[
            SizedBox(height: AppDimensions.spaceXs),
            Text(
              widget.subtitle!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textMedium,
                  ),
              textAlign: TextAlign.center,
            ),
          ],
          SizedBox(height: AppDimensions.spaceLg),
        ],

        // PIN Display
        _PinDisplay(
          length: widget.length,
          filledCount: _pin.length,
          obscure: widget.obscure,
          pin: _pin,
          hasError: hasError,
        ),

        // Error message
        if (hasError) ...[
          SizedBox(height: AppDimensions.spaceSm),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: AppColors.error,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],

        // Number pad (for child-friendly mode)
        if (widget.showNumberPad) ...[
          SizedBox(height: AppDimensions.spaceXl),
          _NumberPad(
            enabled: widget.enabled && _pin.length < widget.length,
            onDigitPressed: _addDigit,
            onBackspace: _removeDigit,
          ),
        ],
      ],
    );
  }
}

/// PIN dots/numbers display
class _PinDisplay extends StatelessWidget {
  final int length;
  final int filledCount;
  final bool obscure;
  final String pin;
  final bool hasError;

  const _PinDisplay({
    required this.length,
    required this.filledCount,
    required this.obscure,
    required this.pin,
    required this.hasError,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(length, (index) {
        final isFilled = index < filledCount;
        final digit = index < pin.length ? pin[index] : '';

        return Container(
          width: 48,
          height: 56,
          margin: EdgeInsets.symmetric(horizontal: AppDimensions.spaceXs),
          decoration: BoxDecoration(
            color: AppColors.cardWhite,
            borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
            border: Border.all(
              color: hasError
                  ? AppColors.error
                  : isFilled
                      ? AppColors.unicefBlue
                      : AppColors.surfaceGray,
              width: isFilled ? 2 : 1.5,
            ),
            boxShadow: isFilled
                ? [
                    BoxShadow(
                      color: AppColors.unicefBlue.withValues(alpha: 0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: isFilled
                ? (obscure
                    ? Container(
                        width: 12,
                        height: 12,
                        decoration: BoxDecoration(
                          color: hasError ? AppColors.error : AppColors.unicefBlue,
                          shape: BoxShape.circle,
                        ),
                      )
                    : Text(
                        digit,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                      ))
                : null,
          ),
        );
      }),
    );
  }
}

/// Number pad for child-friendly PIN entry
class _NumberPad extends StatelessWidget {
  final bool enabled;
  final ValueChanged<String> onDigitPressed;
  final VoidCallback onBackspace;

  const _NumberPad({
    required this.enabled,
    required this.onDigitPressed,
    required this.onBackspace,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Row 1: 1, 2, 3
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(digit: '1', onPressed: onDigitPressed, enabled: enabled),
            _NumberButton(digit: '2', onPressed: onDigitPressed, enabled: enabled),
            _NumberButton(digit: '3', onPressed: onDigitPressed, enabled: enabled),
          ],
        ),
        SizedBox(height: AppDimensions.spaceMd),
        // Row 2: 4, 5, 6
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(digit: '4', onPressed: onDigitPressed, enabled: enabled),
            _NumberButton(digit: '5', onPressed: onDigitPressed, enabled: enabled),
            _NumberButton(digit: '6', onPressed: onDigitPressed, enabled: enabled),
          ],
        ),
        SizedBox(height: AppDimensions.spaceMd),
        // Row 3: 7, 8, 9
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _NumberButton(digit: '7', onPressed: onDigitPressed, enabled: enabled),
            _NumberButton(digit: '8', onPressed: onDigitPressed, enabled: enabled),
            _NumberButton(digit: '9', onPressed: onDigitPressed, enabled: enabled),
          ],
        ),
        SizedBox(height: AppDimensions.spaceMd),
        // Row 4: empty, 0, backspace
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 72 + AppDimensions.spaceMd), // Empty space
            _NumberButton(digit: '0', onPressed: onDigitPressed, enabled: enabled),
            SizedBox(width: AppDimensions.spaceMd),
            _BackspaceButton(onPressed: onBackspace),
          ],
        ),
      ],
    );
  }
}

/// Individual number button
class _NumberButton extends StatelessWidget {
  final String digit;
  final ValueChanged<String> onPressed;
  final bool enabled;

  const _NumberButton({
    required this.digit,
    required this.onPressed,
    required this.enabled,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceSm),
      child: Material(
        color: enabled ? AppColors.cardWhite : AppColors.surfaceGray,
        borderRadius: BorderRadius.circular(36),
        child: InkWell(
          onTap: enabled ? () => onPressed(digit) : null,
          borderRadius: BorderRadius.circular(36),
          child: Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.surfaceGray,
                width: 1,
              ),
            ),
            child: Center(
              child: Text(
                digit,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w600,
                  color: enabled ? AppColors.textDark : AppColors.textLight,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Backspace button
class _BackspaceButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackspaceButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(36),
        child: Container(
          width: 72,
          height: 72,
          child: Center(
            child: Icon(
              Icons.backspace_outlined,
              size: 28,
              color: AppColors.textMedium,
            ),
          ),
        ),
      ),
    );
  }
}

/// Simple PIN text field (alternative to number pad)
/// Use this when showNumberPad is false
class PinTextField extends StatefulWidget {
  final ValueChanged<String> onCompleted;
  final ValueChanged<String>? onChanged;
  final int length;
  final bool enabled;
  final String? errorText;
  final bool autofocus;
  final String? label;

  const PinTextField({
    super.key,
    required this.onCompleted,
    this.onChanged,
    this.length = 4,
    this.enabled = true,
    this.errorText,
    this.autofocus = false,
    this.label,
  });

  @override
  State<PinTextField> createState() => _PinTextFieldState();
}

class _PinTextFieldState extends State<PinTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    widget.onChanged?.call(value);
    if (value.length == widget.length) {
      widget.onCompleted(value);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              fontSize: 14,
            ),
          ),
          SizedBox(height: AppDimensions.spaceSm),
        ],
        TextField(
          controller: _controller,
          focusNode: _focusNode,
          enabled: widget.enabled,
          autofocus: widget.autofocus,
          keyboardType: TextInputType.number,
          obscureText: true,
          maxLength: widget.length,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            letterSpacing: 8,
            color: AppColors.textDark,
          ),
          decoration: InputDecoration(
            counterText: '',
            hintText: '****',
            hintStyle: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              letterSpacing: 8,
              color: AppColors.textLight,
            ),
            filled: true,
            fillColor: AppColors.cardWhite,
            errorText: widget.errorText,
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
          ),
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
            LengthLimitingTextInputFormatter(widget.length),
          ],
          onChanged: _onChanged,
        ),
      ],
    );
  }
}
