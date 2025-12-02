import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/auth/auth_provider.dart';
import '../../screens/auth/forgot_password_screen.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/signup_screen.dart';
import '../../screens/contact/contact_screen.dart';
import '../../screens/education/education_categories_screen.dart';
import '../../screens/education/education_content_screen.dart';
import '../../screens/events/event_report_screen.dart';
import '../../screens/feedback/feedback_screen.dart';
import '../../screens/home/mandala_home_screen.dart';
import '../../screens/news/news_detail_screen.dart';
import '../../screens/news/news_list_screen.dart';
import '../../screens/subscription/subscribe_screen.dart';

/// Route names for type-safe navigation
class AppRoutes {
  static const String home = 'home';
  static const String news = 'news';
  static const String newsDetail = 'news-detail';
  static const String education = 'education';
  static const String educationCategory = 'education-category';
  static const String educationContent = 'education-content';
  static const String eventsReport = 'events-report';
  static const String feedback = 'feedback';
  static const String subscribe = 'subscribe';
  static const String contact = 'contact';
  static const String login = 'login';
  static const String signup = 'signup';
  static const String forgotPassword = 'forgot-password';
}

/// Route paths
class AppPaths {
  static const String home = '/';
  static const String news = '/news';
  static const String newsDetail = '/news/:id';
  static const String education = '/education';
  static const String educationCategory = '/education/:categoryId';
  static const String educationContent = '/education/:categoryId/:contentId';
  static const String eventsReport = '/events/report';
  static const String feedback = '/feedback';
  static const String subscribe = '/subscribe';
  static const String contact = '/contact';
  static const String login = '/auth/login';
  static const String signup = '/auth/signup';
  static const String forgotPassword = '/auth/forgot-password';

  /// Routes that require authentication
  static const List<String> protectedRoutes = [
    eventsReport,
  ];

  /// Auth routes (login, signup, forgot password)
  static const List<String> authRoutes = [
    login,
    signup,
    forgotPassword,
  ];
}

/// Global navigator key for navigation from anywhere
final rootNavigatorKey = GlobalKey<NavigatorState>();

/// Listenable for router refresh
class AuthChangeNotifier extends ChangeNotifier {
  AuthChangeNotifier(Ref ref) {
    ref.listen(authStateProvider, (previous, current) {
      notifyListeners();
    });
  }
}

/// Router provider with auth state watching
final routerProvider = Provider<GoRouter>((ref) {
  final authChangeNotifier = AuthChangeNotifier(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: AppPaths.home,
    debugLogDiagnostics: true,
    routes: _routes,
    refreshListenable: authChangeNotifier,
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),
    redirect: (context, state) {
      final authState = ref.read(authStateProvider);
      final isAuthenticated = authState.isAuthenticated;
      final currentPath = state.matchedLocation;

      // Check if trying to access a protected route
      final isProtectedRoute = AppPaths.protectedRoutes.any(
        (route) => currentPath.startsWith(route.split(':').first),
      );

      // Check if on an auth route
      final isAuthRoute = AppPaths.authRoutes.any(
        (route) => currentPath == route,
      );

      // Redirect unauthenticated users away from protected routes
      if (isProtectedRoute && !isAuthenticated) {
        // Save the intended destination for after login
        return '${AppPaths.login}?redirect=${Uri.encodeComponent(currentPath)}';
      }

      // Redirect authenticated users away from auth routes
      if (isAuthRoute && isAuthenticated) {
        return AppPaths.home;
      }

      // No redirect needed
      return null;
    },
  );
});

/// App routes configuration
final List<RouteBase> _routes = [
  // Home
  GoRoute(
    path: AppPaths.home,
    name: AppRoutes.home,
    builder: (context, state) => const MandalaHomeScreen(),
  ),

  // News routes
  GoRoute(
    path: AppPaths.news,
    name: AppRoutes.news,
    builder: (context, state) => const NewsListScreen(),
    routes: [
      GoRoute(
        path: ':id',
        name: AppRoutes.newsDetail,
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          return NewsDetailScreen(newsId: id);
        },
      ),
    ],
  ),

  // Education routes
  GoRoute(
    path: AppPaths.education,
    name: AppRoutes.education,
    builder: (context, state) => EducationCategoriesScreen(),
    routes: [
      GoRoute(
        path: ':categoryId',
        name: AppRoutes.educationCategory,
        builder: (context, state) {
          final categoryId = state.pathParameters['categoryId']!;
          // Map to existing education screens
          return _getEducationScreen(categoryId);
        },
        routes: [
          GoRoute(
            path: ':contentId',
            name: AppRoutes.educationContent,
            builder: (context, state) {
              final categoryId = state.pathParameters['categoryId']!;
              final contentId = state.pathParameters['contentId']!;
              return _PlaceholderScreen(
                title: 'Content: $categoryId/$contentId',
              );
            },
          ),
        ],
      ),
    ],
  ),

  // Events
  GoRoute(
    path: AppPaths.eventsReport,
    name: AppRoutes.eventsReport,
    builder: (context, state) => const EventReportScreen(),
  ),

  // Feedback
  GoRoute(
    path: AppPaths.feedback,
    name: AppRoutes.feedback,
    builder: (context, state) => const FeedbackScreen(),
  ),

  // Subscribe
  GoRoute(
    path: AppPaths.subscribe,
    name: AppRoutes.subscribe,
    builder: (context, state) => const SubscribeScreen(),
  ),

  // Contact
  GoRoute(
    path: AppPaths.contact,
    name: AppRoutes.contact,
    builder: (context, state) => const ContactScreen(),
  ),

  // Auth routes
  GoRoute(
    path: AppPaths.login,
    name: AppRoutes.login,
    builder: (context, state) => const LoginScreen(),
  ),
  GoRoute(
    path: AppPaths.signup,
    name: AppRoutes.signup,
    builder: (context, state) => const SignupScreen(),
  ),
  GoRoute(
    path: AppPaths.forgotPassword,
    name: AppRoutes.forgotPassword,
    builder: (context, state) => const ForgotPasswordScreen(),
  ),
];

/// Helper to get existing education screens by category ID
Widget _getEducationScreen(String categoryId) {
  switch (categoryId) {
    case 'survival':
      return EducationContentScreen.survival();
    case 'non-discrimination':
      return EducationContentScreen.nonDiscrimination();
    case 'best-interest':
      return EducationContentScreen.bestInterest();
    case 'respect-views':
      return EducationContentScreen.respectViews();
    default:
      return _PlaceholderScreen(title: 'Category: $categoryId');
  }
}

/// Placeholder screen for routes not yet implemented
class _PlaceholderScreen extends StatelessWidget {
  final String title;

  const _PlaceholderScreen({required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.construction,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Coming soon...',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Error screen for 404 and other routing errors
class _ErrorScreen extends StatelessWidget {
  final Exception? error;

  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Page Not Found'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '404',
              style: Theme.of(context).textTheme.headlineLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Page not found',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.goNamed(AppRoutes.home),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  }
}
