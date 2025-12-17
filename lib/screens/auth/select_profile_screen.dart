import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/auth/child_profile.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/auth/date_of_birth_picker.dart';

/// Select Profile Screen
///
/// Shows all children under the parent account.
/// Parent can select a child to log in as or continue as parent.
class SelectProfileScreen extends ConsumerWidget {
  const SelectProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final children = ref.watch(childrenProvider);
    final parent = ref.watch(currentParentProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spaceXl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: AppDimensions.spaceMd),

              // Header
              Text(
                'Who\'s using the app?',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spaceSm),
              Text(
                'Select a profile to continue',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppColors.textMedium,
                    ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: AppDimensions.spaceXl * 2),

              // Profiles grid
              Expanded(
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: AppDimensions.spaceMd,
                    crossAxisSpacing: AppDimensions.spaceMd,
                    childAspectRatio: 0.85,
                  ),
                  itemCount: children.length + 2, // +1 for parent, +1 for add
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      // Parent profile
                      return _ParentProfileCard(
                        name: parent?.name ?? 'Parent',
                        onTap: () => _continueAsParent(context),
                      );
                    } else if (index <= children.length) {
                      // Child profile
                      final child = children[index - 1];
                      return _ChildProfileCard(
                        child: child,
                        onTap: () => _selectChild(context, ref, child),
                      );
                    } else {
                      // Add child button
                      return _AddChildCard(
                        onTap: () => context.push('/auth/child-setup'),
                      );
                    }
                  },
                ),
              ),

              SizedBox(height: AppDimensions.spaceLg),

              // Logout button
              TextButton.icon(
                onPressed: () => _logout(context, ref),
                icon: Icon(Icons.logout, size: 18),
                label: Text('Sign out'),
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _continueAsParent(BuildContext context) {
    context.go('/');
  }

  void _selectChild(BuildContext context, WidgetRef ref, ChildProfile child) {
    // Navigate to child login (PIN entry)
    context.push('/auth/child-login', extra: child);
  }

  Future<void> _logout(BuildContext context, WidgetRef ref) async {
    await ref.read(authStateProvider.notifier).logout();
    if (context.mounted) {
      context.go('/login');
    }
  }
}

/// Parent profile card
class _ParentProfileCard extends StatelessWidget {
  final String name;
  final VoidCallback onTap;

  const _ParentProfileCard({
    required this.name,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(
            color: AppColors.unicefBlue,
            width: 2,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.unicefBlue,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.person,
                size: 40,
                color: Colors.white,
              ),
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Name
            Text(
              name,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: AppDimensions.spaceXs),

            // Badge
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceSm,
                vertical: AppDimensions.spaceXs,
              ),
              decoration: BoxDecoration(
                color: AppColors.unicefBlue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(AppDimensions.radiusSm),
              ),
              child: Text(
                'Parent',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.unicefBlue,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Child profile card
class _ChildProfileCard extends StatelessWidget {
  final ChildProfile child;
  final VoidCallback onTap;

  const _ChildProfileCard({
    required this.child,
    required this.onTap,
  });

  Color get _avatarColor {
    // Assign colors based on age group
    switch (child.ageGroup.label) {
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Avatar
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: _avatarColor,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ),
            SizedBox(height: AppDimensions.spaceMd),

            // Name
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceSm),
              child: Text(
                child.name,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textDark,
                    ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            SizedBox(height: AppDimensions.spaceXs),

            // Age group badge
            AgeGroupBadge.fromDateOfBirth(child.dateOfBirth),
          ],
        ),
      ),
    );
  }
}

/// Add child card
class _AddChildCard extends StatelessWidget {
  final VoidCallback onTap;

  const _AddChildCard({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardWhite,
          borderRadius: BorderRadius.circular(AppDimensions.radiusXl),
          border: Border.all(
            color: AppColors.surfaceGray,
            width: 2,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.surfaceGray,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.add,
                size: 40,
                color: AppColors.textMedium,
              ),
            ),
            SizedBox(height: AppDimensions.spaceMd),
            Text(
              'Add Child',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textMedium,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
