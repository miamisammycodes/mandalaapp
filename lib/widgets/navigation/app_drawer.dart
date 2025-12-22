import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth/auth_provider.dart';

/// Modern navigation drawer for the app
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.isAuthenticated;
    final parent = authState.parent;
    final activeChild = authState.activeChild;

    final displayName = authState.isChildMode
        ? activeChild?.name
        : parent?.name;
    final displaySubtitle = authState.isChildMode
        ? 'Child Mode'
        : parent?.phoneNumber;

    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          // Header
          _buildHeader(context, isAuthenticated, displayName, displaySubtitle, authState.isChildMode),

          // Navigation items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_outlined,
                  activeIcon: Icons.home_rounded,
                  title: 'Home',
                  routeName: AppRoutes.home,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.auto_stories_outlined,
                  activeIcon: Icons.auto_stories_rounded,
                  title: 'Learning',
                  routeName: AppRoutes.chapters,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.newspaper_outlined,
                  activeIcon: Icons.newspaper_rounded,
                  title: 'News',
                  routeName: AppRoutes.news,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.event_outlined,
                  activeIcon: Icons.event_rounded,
                  title: 'Events',
                  routeName: AppRoutes.events,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.shield_outlined,
                  activeIcon: Icons.shield_rounded,
                  title: 'Online Safety',
                  routeName: AppRoutes.onlineSafety,
                ),

                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Divider(height: 1),
                ),

                if (isAuthenticated) ...[
                  _buildNavItem(
                    context: context,
                    ref: ref,
                    icon: Icons.family_restroom_outlined,
                    activeIcon: Icons.family_restroom_rounded,
                    title: 'My Family',
                    routeName: AppRoutes.parentDashboard,
                    requiresAuth: true,
                  ),
                  _buildNavItem(
                    context: context,
                    ref: ref,
                    icon: Icons.flag_outlined,
                    activeIcon: Icons.flag_rounded,
                    title: 'Report Event',
                    routeName: AppRoutes.eventsReport,
                    requiresAuth: true,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Divider(height: 1),
                  ),
                ],

                _buildNavItem(
                  context: context,
                  icon: Icons.chat_bubble_outline_rounded,
                  activeIcon: Icons.chat_bubble_rounded,
                  title: 'Feedback',
                  routeName: AppRoutes.feedback,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.help_outline_rounded,
                  activeIcon: Icons.help_rounded,
                  title: 'Contact Us',
                  routeName: AppRoutes.contact,
                ),
              ],
            ),
          ),

          // Bottom section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              border: Border(top: BorderSide(color: Colors.grey.shade200)),
            ),
            child: _buildAuthButton(context, ref, isAuthenticated),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isAuthenticated,
    String? userName,
    String? userSubtitle,
    bool isChildMode,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        left: 20,
        right: 20,
        bottom: 24,
      ),
      decoration: BoxDecoration(
        color: isChildMode ? AppColors.pastelPink : AppColors.unicefBlue,
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              isAuthenticated
                  ? (isChildMode ? Icons.face_rounded : Icons.person_rounded)
                  : Icons.shield_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
          const SizedBox(width: 14),
          // Text content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isAuthenticated ? (userName ?? 'User') : 'Child Mandala',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  isAuthenticated
                      ? (userSubtitle ?? '')
                      : 'Protecting every child',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.85),
                    fontSize: 13,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    WidgetRef? ref,
    required IconData icon,
    required IconData activeIcon,
    required String title,
    required String routeName,
    bool requiresAuth = false,
  }) {
    final currentRoute = GoRouterState.of(context).name;
    final isSelected = currentRoute == routeName;

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: isSelected ? AppColors.unicefBlue.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: () {
            final router = GoRouter.of(context);
            Navigator.pop(context);

            if (requiresAuth && ref != null) {
              final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
              if (!isAuthenticated) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Please login to access this feature'),
                    action: SnackBarAction(
                      label: 'Login',
                      onPressed: () => router.goNamed(AppRoutes.login),
                    ),
                  ),
                );
                return;
              }
            }

            router.goNamed(routeName);
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.unicefBlue
                        : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    isSelected ? activeIcon : icon,
                    color: isSelected ? Colors.white : Colors.grey.shade600,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    title,
                    style: TextStyle(
                      color: isSelected ? AppColors.unicefBlue : AppColors.textDark,
                      fontSize: 15,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.chevron_right_rounded,
                    color: AppColors.unicefBlue,
                    size: 20,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildAuthButton(
    BuildContext context,
    WidgetRef ref,
    bool isAuthenticated,
  ) {
    if (isAuthenticated) {
      return InkWell(
        onTap: () async {
          final scaffoldMessenger = ScaffoldMessenger.of(context);
          final router = GoRouter.of(context);
          Navigator.pop(context);
          await ref.read(authStateProvider.notifier).logout();

          scaffoldMessenger.showSnackBar(
            const SnackBar(
              content: Text('Logged out successfully!'),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          router.goNamed(AppRoutes.home);
        },
        borderRadius: BorderRadius.circular(12),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.unicefBlue),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.logout_rounded, color: AppColors.unicefBlue, size: 20),
              SizedBox(width: 8),
              Text(
                'Logout',
                style: TextStyle(
                  color: AppColors.unicefBlue,
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return InkWell(
      onTap: () {
        Navigator.pop(context);
        context.goNamed(AppRoutes.login);
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.unicefBlue,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.login_rounded, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text(
              'Login',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 15,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
