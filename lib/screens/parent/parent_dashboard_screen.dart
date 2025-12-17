import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../models/auth/child_profile.dart';
import '../../providers/auth/auth_provider.dart';
import '../../widgets/auth/date_of_birth_picker.dart';

/// Parent Dashboard Screen
///
/// Shows overview of all children with quick actions.
/// Parent can manage children, switch to child mode, or access settings.
class ParentDashboardScreen extends ConsumerWidget {
  const ParentDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final parent = ref.watch(currentParentProvider);
    final children = ref.watch(childrenProvider);
    final isChildMode = ref.watch(isChildModeProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.unicefBlue,
        elevation: 0,
        title: Text(
          'My Family',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/'),
        ),
        actions: [
          if (isChildMode)
            TextButton.icon(
              onPressed: () => _switchToParent(context, ref),
              icon: Icon(Icons.swap_horiz, color: Colors.white, size: 20),
              label: Text(
                'Parent Mode',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: CustomScrollView(
        slivers: [
          // Parent header
          SliverToBoxAdapter(
            child: _ParentHeader(
              name: parent?.name ?? 'Parent',
              childCount: children.length,
            ),
          ),

          // Children section header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                AppDimensions.spaceLg,
                AppDimensions.spaceLg,
                AppDimensions.spaceLg,
                AppDimensions.spaceMd,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Children',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark,
                        ),
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/parent/children/add'),
                    icon: Icon(Icons.add, size: 20),
                    label: Text('Add Child'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.unicefBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Children list
          if (children.isEmpty)
            SliverToBoxAdapter(
              child: _EmptyChildrenState(
                onAddChild: () => context.push('/parent/children/add'),
              ),
            )
          else
            SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: AppDimensions.spaceLg),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final child = children[index];
                    return Padding(
                      padding: EdgeInsets.only(bottom: AppDimensions.spaceMd),
                      child: _ChildCard(
                        child: child,
                        onTap: () => context.push('/parent/children/${child.id}'),
                        onLoginAsChild: () => _loginAsChild(context, ref, child),
                      ),
                    );
                  },
                  childCount: children.length,
                ),
              ),
            ),

          // Bottom spacing
          SliverToBoxAdapter(
            child: SizedBox(height: AppDimensions.spaceXl),
          ),
        ],
      ),
    );
  }

  Future<void> _switchToParent(BuildContext context, WidgetRef ref) async {
    await ref.read(authStateProvider.notifier).switchToParent();
  }

  void _loginAsChild(BuildContext context, WidgetRef ref, ChildProfile child) {
    context.push('/auth/child-login', extra: child);
  }
}

/// Parent header with avatar and stats
class _ParentHeader extends StatelessWidget {
  final String name;
  final int childCount;

  const _ParentHeader({
    required this.name,
    required this.childCount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.unicefBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(AppDimensions.radiusXxl),
          bottomRight: Radius.circular(AppDimensions.radiusXxl),
        ),
      ),
      padding: EdgeInsets.fromLTRB(
        AppDimensions.spaceLg,
        AppDimensions.spaceMd,
        AppDimensions.spaceLg,
        AppDimensions.spaceXl,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.person,
              size: 40,
              color: AppColors.unicefBlue,
            ),
          ),
          SizedBox(width: AppDimensions.spaceMd),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
                SizedBox(height: AppDimensions.spaceXs),
                Text(
                  '$childCount ${childCount == 1 ? 'child' : 'children'}',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state when no children added
class _EmptyChildrenState extends StatelessWidget {
  final VoidCallback onAddChild;

  const _EmptyChildrenState({required this.onAddChild});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(AppDimensions.spaceXl),
      child: Column(
        children: [
          SizedBox(height: AppDimensions.spaceXl),
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.pastelPurple.withValues(alpha: 0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.child_care,
              size: 48,
              color: AppColors.textMedium,
            ),
          ),
          SizedBox(height: AppDimensions.spaceLg),
          Text(
            'No children added yet',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppColors.textMedium,
                  fontWeight: FontWeight.w600,
                ),
          ),
          SizedBox(height: AppDimensions.spaceSm),
          Text(
            'Add your children to personalize their learning experience',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textLight,
                ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: AppDimensions.spaceLg),
          ElevatedButton.icon(
            onPressed: onAddChild,
            icon: Icon(Icons.add),
            label: Text('Add Your First Child'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.unicefBlue,
              foregroundColor: Colors.white,
              padding: EdgeInsets.symmetric(
                horizontal: AppDimensions.spaceLg,
                vertical: AppDimensions.spaceMd,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppDimensions.radiusMd),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Child card with info and actions
class _ChildCard extends StatelessWidget {
  final ChildProfile child;
  final VoidCallback onTap;
  final VoidCallback onLoginAsChild;

  const _ChildCard({
    required this.child,
    required this.onTap,
    required this.onLoginAsChild,
  });

  Color get _avatarColor {
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
        child: Padding(
          padding: EdgeInsets.all(AppDimensions.spaceMd),
          child: Row(
            children: [
              // Avatar
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: _avatarColor,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    child.name.isNotEmpty ? child.name[0].toUpperCase() : '?',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ),
              SizedBox(width: AppDimensions.spaceMd),

              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      child.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                    ),
                    SizedBox(height: AppDimensions.spaceXs),
                    Row(
                      children: [
                        AgeGroupBadge.fromDateOfBirth(child.dateOfBirth),
                        SizedBox(width: AppDimensions.spaceSm),
                        Text(
                          child.ageDisplay,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: AppColors.textMedium,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Actions
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Login as child button
                  IconButton(
                    onPressed: onLoginAsChild,
                    icon: Icon(Icons.play_circle_outline),
                    color: AppColors.unicefBlue,
                    tooltip: 'Login as ${child.name}',
                  ),
                  // Edit button
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textLight,
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
