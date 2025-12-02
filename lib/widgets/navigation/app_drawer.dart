import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_colors.dart';
import '../../core/router/app_router.dart';
import '../../providers/auth/auth_provider.dart';

/// Main navigation drawer for the app
class AppDrawer extends ConsumerWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    final isAuthenticated = authState.isAuthenticated;
    final user = authState.user;

    return Drawer(
      child: Column(
        children: [
          // Header
          _buildHeader(context, isAuthenticated, user?.name, user?.email),

          // Navigation items
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                _buildNavItem(
                  context: context,
                  icon: Icons.home_outlined,
                  selectedIcon: Icons.home,
                  title: 'Home',
                  routeName: AppRoutes.home,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.article_outlined,
                  selectedIcon: Icons.article,
                  title: 'News',
                  routeName: AppRoutes.news,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.school_outlined,
                  selectedIcon: Icons.school,
                  title: 'Education',
                  routeName: AppRoutes.education,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.report_outlined,
                  selectedIcon: Icons.report,
                  title: 'Report Event',
                  routeName: AppRoutes.eventsReport,
                  requiresAuth: true,
                  isAuthenticated: isAuthenticated,
                ),
                const Divider(),
                _buildNavItem(
                  context: context,
                  icon: Icons.feedback_outlined,
                  selectedIcon: Icons.feedback,
                  title: 'Feedback',
                  routeName: AppRoutes.feedback,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.email_outlined,
                  selectedIcon: Icons.email,
                  title: 'Subscribe',
                  routeName: AppRoutes.subscribe,
                ),
                _buildNavItem(
                  context: context,
                  icon: Icons.contact_mail_outlined,
                  selectedIcon: Icons.contact_mail,
                  title: 'Contact Us',
                  routeName: AppRoutes.contact,
                ),
              ],
            ),
          ),

          // Auth section at bottom
          const Divider(height: 1),
          _buildAuthSection(context, ref, isAuthenticated),
        ],
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context,
    bool isAuthenticated,
    String? userName,
    String? userEmail,
  ) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 24,
        left: 16,
        right: 16,
        bottom: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.unicefBlue,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          // User name or app name
          Text(
            isAuthenticated ? (userName ?? 'User') : 'UNICEF Child Protection',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          if (isAuthenticated && userEmail != null)
            Text(
              userEmail,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          if (!isAuthenticated)
            Text(
              'Protecting every child',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
            ),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required IconData icon,
    required IconData selectedIcon,
    required String title,
    required String routeName,
    bool requiresAuth = false,
    bool isAuthenticated = false,
  }) {
    final currentRoute = GoRouterState.of(context).name;
    final isSelected = currentRoute == routeName;

    return ListTile(
      leading: Icon(
        isSelected ? selectedIcon : icon,
        color: isSelected ? AppColors.unicefBlue : null,
      ),
      title: Text(
        title,
        style: TextStyle(
          color: isSelected ? AppColors.unicefBlue : null,
          fontWeight: isSelected ? FontWeight.w600 : null,
        ),
      ),
      selected: isSelected,
      onTap: () {
        Navigator.pop(context); // Close drawer

        if (requiresAuth && !isAuthenticated) {
          // Show login prompt for protected routes
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Please login to access this feature'),
              action: SnackBarAction(
                label: 'Login',
                onPressed: () => context.goNamed(AppRoutes.login),
              ),
            ),
          );
          return;
        }

        context.goNamed(routeName);
      },
    );
  }

  Widget _buildAuthSection(
    BuildContext context,
    WidgetRef ref,
    bool isAuthenticated,
  ) {
    if (isAuthenticated) {
      return ListTile(
        leading: const Icon(Icons.logout, color: AppColors.errorColor),
        title: const Text(
          'Logout',
          style: TextStyle(color: AppColors.errorColor),
        ),
        onTap: () async {
          Navigator.pop(context); // Close drawer
          await ref.read(authStateProvider.notifier).logout();
          if (context.mounted) {
            context.goNamed(AppRoutes.home);
          }
        },
      );
    }

    return ListTile(
      leading: const Icon(Icons.login, color: AppColors.unicefBlue),
      title: const Text(
        'Login',
        style: TextStyle(color: AppColors.unicefBlue),
      ),
      onTap: () {
        Navigator.pop(context);
        context.goNamed(AppRoutes.login);
      },
    );
  }
}
