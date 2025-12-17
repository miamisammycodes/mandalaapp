import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/auth/child_profile.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/auth/date_of_birth_picker.dart';
import '../../widgets/auth/pin_input_field.dart';
import '../../widgets/shared/app_button.dart';
import '../../widgets/shared/app_text_field.dart';

/// Edit Child Screen
///
/// Form to edit an existing child profile.
/// Includes name, date of birth, and PIN update.
class EditChildScreen extends ConsumerStatefulWidget {
  final String childId;

  const EditChildScreen({
    super.key,
    required this.childId,
  });

  @override
  ConsumerState<EditChildScreen> createState() => _EditChildScreenState();
}

class _EditChildScreenState extends ConsumerState<EditChildScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  DateTime? _dateOfBirth;
  bool _isLoading = false;
  bool _isDeleting = false;
  bool _changingPin = false;
  String _newPin = '';
  String _confirmPin = '';
  String? _pinError;
  ChildProfile? _child;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
    _loadChild();
  }

  void _loadChild() {
    final children = ref.read(childrenProvider);
    _child = children.firstWhere(
      (c) => c.id == widget.childId,
      orElse: () => throw Exception('Child not found'),
    );

    if (_child != null) {
      _nameController.text = _child!.name;
      _dateOfBirth = _child!.dateOfBirth;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    if (_nameController.text.trim().isEmpty) return false;
    if (_dateOfBirth == null) return false;
    if (_changingPin) {
      if (_newPin.length < 4) return false;
      if (_newPin != _confirmPin) return false;
    }
    return true;
  }

  Future<void> _saveChanges() async {
    if (!_formKey.currentState!.validate()) return;
    if (_child == null) return;

    if (_changingPin && _newPin != _confirmPin) {
      setState(() {
        _pinError = 'PINs do not match';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _pinError = null;
    });

    // Create updated child
    final updatedChild = _child!.copyWith(
      name: _nameController.text.trim(),
      dateOfBirth: _dateOfBirth,
      pin: _changingPin ? _newPin : null,
    );

    final success = await ref.read(authStateProvider.notifier).updateChild(
      updatedChild,
    );

    if (mounted) {
      setState(() {
        _isLoading = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Changes saved'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save changes'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  Future<void> _deleteChild() async {
    if (_child == null) return;

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete ${_child!.name}?'),
        content: Text(
          'This will permanently remove this child profile. This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.error,
            ),
            child: Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    final success = await ref.read(authStateProvider.notifier).removeChild(
      widget.childId,
    );

    if (mounted) {
      setState(() {
        _isDeleting = false;
      });

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${_child!.name} has been removed'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to delete child'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // Re-watch to get updates
    final children = ref.watch(childrenProvider);
    _child = children.where((c) => c.id == widget.childId).firstOrNull;

    if (_child == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Edit Child'),
        ),
        body: Center(
          child: Text('Child not found'),
        ),
      );
    }

    final isExpecting = _dateOfBirth?.isAfter(DateTime.now()) ?? false;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.unicefBlue,
        elevation: 0,
        title: Text(
          'Edit ${_child!.name}',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.white),
            onPressed: _isLoading || _isDeleting ? null : _deleteChild,
            tooltip: 'Delete child',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(AppDimensions.spaceLg),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar header
              Center(
                child: Column(
                  children: [
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: _getAvatarColor(),
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          _child!.name.isNotEmpty
                              ? _child!.name[0].toUpperCase()
                              : '?',
                          style: TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: AppDimensions.spaceSm),
                    AgeGroupBadge.fromDateOfBirth(_child!.dateOfBirth),
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spaceXl),

              // Name field
              AppTextField(
                controller: _nameController,
                label: "Child's Name",
                hintText: 'Enter name',
                textCapitalization: TextCapitalization.words,
                prefixIcon: Icons.person_outline,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a name';
                  }
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              SizedBox(height: AppDimensions.spaceLg),

              // Date of birth picker
              DateOfBirthPicker(
                label: isExpecting ? 'Expected Due Date' : 'Date of Birth',
                hintText: isExpecting
                    ? 'Select expected due date'
                    : 'Select date of birth',
                initialDate: _dateOfBirth,
                allowFutureDates: true,
                onDateSelected: (date) {
                  setState(() {
                    _dateOfBirth = date;
                  });
                },
              ),
              SizedBox(height: AppDimensions.spaceXl),

              // PIN section
              Container(
                decoration: BoxDecoration(
                  color: AppColors.cardWhite,
                  borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
                  border: Border.all(color: AppColors.surfaceGray),
                ),
                child: Column(
                  children: [
                    SwitchListTile(
                      title: Text(
                        'Change PIN',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: AppColors.textDark,
                        ),
                      ),
                      subtitle: Text(
                        'Set a new PIN for this child',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.textMedium,
                        ),
                      ),
                      value: _changingPin,
                      onChanged: (value) {
                        setState(() {
                          _changingPin = value;
                          _newPin = '';
                          _confirmPin = '';
                          _pinError = null;
                        });
                      },
                      activeColor: AppColors.unicefBlue,
                      secondary: Icon(
                        Icons.lock_outline,
                        color: _changingPin
                            ? AppColors.unicefBlue
                            : AppColors.textLight,
                      ),
                    ),
                    if (_changingPin) ...[
                      Divider(height: 1),
                      Padding(
                        padding: EdgeInsets.all(AppDimensions.spaceMd),
                        child: Column(
                          children: [
                            PinTextField(
                              label: 'New PIN',
                              length: 4,
                              onCompleted: (pin) {},
                              onChanged: (pin) {
                                setState(() {
                                  _newPin = pin;
                                  _pinError = null;
                                });
                              },
                              errorText: _pinError,
                            ),
                            SizedBox(height: AppDimensions.spaceMd),
                            PinTextField(
                              label: 'Confirm New PIN',
                              length: 4,
                              onCompleted: (pin) {},
                              onChanged: (pin) {
                                setState(() {
                                  _confirmPin = pin;
                                  if (_newPin.isNotEmpty &&
                                      pin.length == 4 &&
                                      pin != _newPin) {
                                    _pinError = 'PINs do not match';
                                  } else {
                                    _pinError = null;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(height: AppDimensions.spaceXl * 2),

              // Save button
              AppButton(
                text: 'Save Changes',
                onPressed: _isFormValid && !_isLoading && !_isDeleting
                    ? _saveChanges
                    : null,
                isLoading: _isLoading,
                width: double.infinity,
              ),
              SizedBox(height: AppDimensions.spaceMd),

              // Login as child button
              AppButton.secondary(
                text: 'Login as ${_child!.name}',
                icon: Icons.play_circle_outline,
                onPressed: _isLoading || _isDeleting
                    ? null
                    : () => context.push('/auth/child-login', extra: _child),
                width: double.infinity,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getAvatarColor() {
    if (_child == null) return AppColors.softBlue;
    switch (_child!.ageGroup.label) {
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
}
