import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_typography.dart';

/// App Text Field Widget
///
/// Reusable text input component following the design system.
/// Supports various input types, validation, and customization.
///
/// Features:
/// - Standard text input
/// - Password input with visibility toggle
/// - Multi-line text input (textarea)
/// - Validation error display
/// - Prefix and suffix icons
/// - Focus state styling
/// - Consistent design system integration
///
/// Example:
/// ```dart
/// AppTextField(
///   label: 'Email',
///   hintText: 'Enter your email',
///   controller: emailController,
///   keyboardType: TextInputType.emailAddress,
///   validator: (value) => value?.isEmpty ?? true ? 'Required' : null,
/// )
/// ```
class AppTextField extends StatefulWidget {
  /// Text field label
  final String? label;

  /// Placeholder text
  final String? hintText;

  /// Helper text below input
  final String? helperText;

  /// Error message to display
  final String? errorText;

  /// Text editing controller
  final TextEditingController? controller;

  /// Initial value (used if controller is null)
  final String? initialValue;

  /// Callback when text changes
  final ValueChanged<String>? onChanged;

  /// Callback when editing is complete
  final VoidCallback? onEditingComplete;

  /// Callback when field is submitted
  final ValueChanged<String>? onSubmitted;

  /// Validation function
  final FormFieldValidator<String>? validator;

  /// Keyboard type
  final TextInputType keyboardType;

  /// Text input action
  final TextInputAction? textInputAction;

  /// Whether this is a password field
  final bool isPassword;

  /// Whether this is a multi-line field
  final bool isMultiline;

  /// Maximum lines (for multiline)
  final int? maxLines;

  /// Minimum lines (for multiline)
  final int? minLines;

  /// Maximum length
  final int? maxLength;

  /// Whether to show character counter
  final bool showCounter;

  /// Prefix icon
  final IconData? prefixIcon;

  /// Suffix icon
  final IconData? suffixIcon;

  /// Suffix icon tap callback
  final VoidCallback? onSuffixIconTap;

  /// Whether field is enabled
  final bool enabled;

  /// Whether field is read-only
  final bool readOnly;

  /// Autofocus on mount
  final bool autofocus;

  /// Input formatters
  final List<TextInputFormatter>? inputFormatters;

  /// Focus node
  final FocusNode? focusNode;

  /// Text capitalization
  final TextCapitalization textCapitalization;

  /// Autocorrect
  final bool autocorrect;

  const AppTextField({
    super.key,
    this.label,
    this.hintText,
    this.helperText,
    this.errorText,
    this.controller,
    this.initialValue,
    this.onChanged,
    this.onEditingComplete,
    this.onSubmitted,
    this.validator,
    this.keyboardType = TextInputType.text,
    this.textInputAction,
    this.isPassword = false,
    this.isMultiline = false,
    this.maxLines,
    this.minLines,
    this.maxLength,
    this.showCounter = false,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixIconTap,
    this.enabled = true,
    this.readOnly = false,
    this.autofocus = false,
    this.inputFormatters,
    this.focusNode,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
  });

  /// Create an email input field
  factory AppTextField.email({
    Key? key,
    String? label,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
  }) {
    return AppTextField(
      key: key,
      label: label ?? 'Email',
      hintText: hintText ?? 'Enter your email',
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      keyboardType: TextInputType.emailAddress,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.email_outlined,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
    );
  }

  /// Create a password input field
  factory AppTextField.password({
    Key? key,
    String? label,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
    VoidCallback? onSubmitted,
  }) {
    return AppTextField(
      key: key,
      label: label ?? 'Password',
      hintText: hintText ?? 'Enter your password',
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      isPassword: true,
      keyboardType: TextInputType.visiblePassword,
      textInputAction: TextInputAction.done,
      prefixIcon: Icons.lock_outlined,
      autocorrect: false,
      textCapitalization: TextCapitalization.none,
    );
  }

  /// Create a multiline text area
  factory AppTextField.multiline({
    Key? key,
    String? label,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
    int maxLines = 5,
    int minLines = 3,
    int? maxLength,
    bool showCounter = false,
  }) {
    return AppTextField(
      key: key,
      label: label,
      hintText: hintText,
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      isMultiline: true,
      maxLines: maxLines,
      minLines: minLines,
      maxLength: maxLength,
      showCounter: showCounter,
      keyboardType: TextInputType.multiline,
      textInputAction: TextInputAction.newline,
      textCapitalization: TextCapitalization.sentences,
    );
  }

  /// Create a phone number input field
  factory AppTextField.phone({
    Key? key,
    String? label,
    String? hintText,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    FormFieldValidator<String>? validator,
    String? errorText,
  }) {
    return AppTextField(
      key: key,
      label: label ?? 'Phone Number',
      hintText: hintText ?? 'Enter your phone number',
      controller: controller,
      onChanged: onChanged,
      validator: validator,
      errorText: errorText,
      keyboardType: TextInputType.phone,
      textInputAction: TextInputAction.next,
      prefixIcon: Icons.phone_outlined,
      autocorrect: false,
    );
  }

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  /// Whether password is visible
  bool _obscurePassword = true;

  /// Focus node (internal or from widget)
  late FocusNode _focusNode;

  /// Whether we own the focus node
  bool _internalFocusNode = false;

  @override
  void initState() {
    super.initState();

    // Use provided focus node or create internal one
    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _internalFocusNode = true;
    }
  }

  @override
  void dispose() {
    // Only dispose if we created the focus node
    if (_internalFocusNode) {
      _focusNode.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Label
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTypography.body2.copyWith(
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: AppDimensions.spaceSm),
        ],

        // Text field
        TextFormField(
          controller: widget.controller,
          initialValue: widget.initialValue,
          focusNode: _focusNode,
          enabled: widget.enabled,
          readOnly: widget.readOnly,
          autofocus: widget.autofocus,
          obscureText: widget.isPassword && _obscurePassword,
          keyboardType: widget.keyboardType,
          textInputAction: widget.textInputAction,
          textCapitalization: widget.textCapitalization,
          autocorrect: widget.autocorrect,
          maxLines: widget.isPassword
              ? 1
              : widget.isMultiline
                  ? widget.maxLines
                  : 1,
          minLines: widget.isMultiline ? widget.minLines : null,
          maxLength: widget.maxLength,
          inputFormatters: widget.inputFormatters,
          style: AppTypography.body1.copyWith(
            color: widget.enabled ? AppColors.textDark : AppColors.textLight,
          ),
          decoration: _buildInputDecoration(),
          onChanged: widget.onChanged,
          onEditingComplete: widget.onEditingComplete,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          buildCounter: widget.showCounter
              ? null
              : (context, {required currentLength, required isFocused, maxLength}) =>
                  null,
        ),

        // Helper text
        if (widget.helperText != null && widget.errorText == null) ...[
          const SizedBox(height: AppDimensions.spaceXs),
          Text(
            widget.helperText!,
            style: AppTypography.caption.copyWith(
              color: AppColors.textLight,
            ),
          ),
        ],
      ],
    );
  }

  /// Build input decoration
  InputDecoration _buildInputDecoration() {
    final hasError = widget.errorText != null;

    return InputDecoration(
      hintText: widget.hintText,
      hintStyle: AppTypography.body1.copyWith(
        color: AppColors.textLight,
      ),
      errorText: widget.errorText,
      errorStyle: AppTypography.caption.copyWith(
        color: AppColors.error,
      ),
      errorMaxLines: 2,

      // Prefix icon
      prefixIcon: widget.prefixIcon != null
          ? Icon(
              widget.prefixIcon,
              color: hasError
                  ? AppColors.error
                  : _focusNode.hasFocus
                      ? AppColors.unicefBlue
                      : AppColors.textLight,
              size: AppDimensions.iconMd,
            )
          : null,

      // Suffix icon (password toggle or custom)
      suffixIcon: _buildSuffixIcon(hasError),

      // Filled style
      filled: true,
      fillColor: widget.enabled ? AppColors.cardWhite : AppColors.surfaceGray,

      // Content padding
      contentPadding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceMd,
        vertical: widget.isMultiline
            ? AppDimensions.spaceMd
            : AppDimensions.spaceSm,
      ),

      // Border styling
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.surfaceGray,
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
          width: 2.0,
        ),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 1.5,
        ),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: const BorderSide(
          color: AppColors.error,
          width: 2.0,
        ),
      ),
      disabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
        borderSide: BorderSide(
          color: AppColors.surfaceGray.withValues(alpha: 0.5),
          width: 1.5,
        ),
      ),
    );
  }

  /// Build suffix icon (password toggle or custom icon)
  Widget? _buildSuffixIcon(bool hasError) {
    // Password visibility toggle
    if (widget.isPassword) {
      return IconButton(
        icon: Icon(
          _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: hasError
              ? AppColors.error
              : _focusNode.hasFocus
                  ? AppColors.unicefBlue
                  : AppColors.textLight,
          size: AppDimensions.iconMd,
        ),
        onPressed: () {
          setState(() {
            _obscurePassword = !_obscurePassword;
          });
        },
        tooltip: _obscurePassword ? 'Show password' : 'Hide password',
      );
    }

    // Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          color: hasError
              ? AppColors.error
              : _focusNode.hasFocus
                  ? AppColors.unicefBlue
                  : AppColors.textLight,
          size: AppDimensions.iconMd,
        ),
        onPressed: widget.onSuffixIconTap,
      );
    }

    return null;
  }
}
