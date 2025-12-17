import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/auth/age_group.dart';

/// Date of Birth Picker Widget
///
/// A date picker optimized for selecting children's birth dates.
/// Shows age group badge after selection and supports future dates for pregnancy.
class DateOfBirthPicker extends StatefulWidget {
  /// Callback when date is selected
  final ValueChanged<DateTime> onDateSelected;

  /// Initial date value
  final DateTime? initialDate;

  /// Label text
  final String? label;

  /// Hint text when no date selected
  final String? hintText;

  /// Whether to allow future dates (for expected due date)
  final bool allowFutureDates;

  /// Error message to display
  final String? errorText;

  /// Whether the field is enabled
  final bool enabled;

  /// Whether to show age group badge after selection
  final bool showAgeGroup;

  const DateOfBirthPicker({
    super.key,
    required this.onDateSelected,
    this.initialDate,
    this.label,
    this.hintText,
    this.allowFutureDates = false,
    this.errorText,
    this.enabled = true,
    this.showAgeGroup = true,
  });

  @override
  State<DateOfBirthPicker> createState() => _DateOfBirthPickerState();
}

class _DateOfBirthPickerState extends State<DateOfBirthPicker> {
  DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    _selectedDate = widget.initialDate;
  }

  @override
  void didUpdateWidget(DateOfBirthPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.initialDate != oldWidget.initialDate) {
      _selectedDate = widget.initialDate;
    }
  }

  Future<void> _selectDate() async {
    if (!widget.enabled) return;

    final now = DateTime.now();

    // Determine date range
    final firstDate = DateTime(now.year - 18, now.month, now.day); // Max 18 years ago
    final lastDate = widget.allowFutureDates
        ? DateTime(now.year + 1, now.month, now.day) // Up to 1 year in future
        : now;

    // Initial date for picker
    final initialDate = _selectedDate ??
        (widget.allowFutureDates ? now : DateTime(now.year - 3, now.month, now.day));

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate.isAfter(lastDate) ? lastDate :
                   initialDate.isBefore(firstDate) ? firstDate : initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: widget.allowFutureDates
          ? 'Select expected due date'
          : 'Select date of birth',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: AppColors.unicefBlue,
              onPrimary: Colors.white,
              surface: AppColors.cardWhite,
              onSurface: AppColors.textDark,
            ),
            dialogBackgroundColor: AppColors.cardWhite,
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
      widget.onDateSelected(picked);
    }
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, yyyy').format(date);
  }

  @override
  Widget build(BuildContext context) {
    final hasError = widget.errorText != null;
    final hasValue = _selectedDate != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
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

        // Date picker button
        GestureDetector(
          onTap: _selectDate,
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(
              horizontal: AppDimensions.spaceMd,
              vertical: AppDimensions.spaceMd,
            ),
            decoration: BoxDecoration(
              color: widget.enabled ? AppColors.cardWhite : AppColors.surfaceGray,
              borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              border: Border.all(
                color: hasError
                    ? AppColors.error
                    : hasValue
                        ? AppColors.unicefBlue
                        : AppColors.surfaceGray,
                width: hasValue ? 2 : 1.5,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today_outlined,
                  color: hasValue ? AppColors.unicefBlue : AppColors.textLight,
                  size: 20,
                ),
                SizedBox(width: AppDimensions.spaceMd),
                Expanded(
                  child: Text(
                    hasValue
                        ? _formatDate(_selectedDate!)
                        : widget.hintText ?? 'Select date of birth',
                    style: TextStyle(
                      fontSize: 16,
                      color: hasValue ? AppColors.textDark : AppColors.textLight,
                    ),
                  ),
                ),
                if (hasValue && widget.showAgeGroup) ...[
                  _AgeGroupBadge(dateOfBirth: _selectedDate!),
                ],
                Icon(
                  Icons.arrow_drop_down,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),

        // Error message
        if (hasError) ...[
          SizedBox(height: AppDimensions.spaceXs),
          Text(
            widget.errorText!,
            style: TextStyle(
              color: AppColors.error,
              fontSize: 12,
            ),
          ),
        ],
      ],
    );
  }
}

/// Age group badge widget
class _AgeGroupBadge extends StatelessWidget {
  final DateTime dateOfBirth;

  const _AgeGroupBadge({required this.dateOfBirth});

  @override
  Widget build(BuildContext context) {
    final ageGroup = AgeGroup.fromDateOfBirth(dateOfBirth);
    final isExpecting = dateOfBirth.isAfter(DateTime.now());

    Color backgroundColor;
    Color textColor;

    switch (ageGroup) {
      case AgeGroup.pregnancy:
        backgroundColor = AppColors.pastelPink;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.infant:
        backgroundColor = AppColors.pastelYellow;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.toddler:
        backgroundColor = AppColors.pastelGreen;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.child:
        backgroundColor = AppColors.pastelPurple;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.teen:
        backgroundColor = AppColors.skyBlue;
        textColor = AppColors.textDark;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm,
        vertical: AppDimensions.spaceXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        isExpecting ? 'Expecting' : ageGroup.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}

/// Age Group Badge (exported for use elsewhere)
class AgeGroupBadge extends StatelessWidget {
  final AgeGroup ageGroup;
  final bool isExpecting;

  const AgeGroupBadge({
    super.key,
    required this.ageGroup,
    this.isExpecting = false,
  });

  factory AgeGroupBadge.fromDateOfBirth(DateTime dateOfBirth) {
    return AgeGroupBadge(
      ageGroup: AgeGroup.fromDateOfBirth(dateOfBirth),
      isExpecting: dateOfBirth.isAfter(DateTime.now()),
    );
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    switch (ageGroup) {
      case AgeGroup.pregnancy:
        backgroundColor = AppColors.pastelPink;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.infant:
        backgroundColor = AppColors.pastelYellow;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.toddler:
        backgroundColor = AppColors.pastelGreen;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.child:
        backgroundColor = AppColors.pastelPurple;
        textColor = AppColors.textDark;
        break;
      case AgeGroup.teen:
        backgroundColor = AppColors.skyBlue;
        textColor = AppColors.textDark;
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppDimensions.spaceSm,
        vertical: AppDimensions.spaceXs,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
      ),
      child: Text(
        isExpecting ? 'Expecting' : ageGroup.label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
        ),
      ),
    );
  }
}
