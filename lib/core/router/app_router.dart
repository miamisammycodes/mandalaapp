import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../models/auth/child_profile.dart';
import '../../providers/auth/auth_provider.dart';
import '../../screens/auth/parent_login_screen.dart';
import '../../screens/auth/otp_verification_screen.dart';
import '../../screens/auth/child_setup_screen.dart';
import '../../screens/auth/select_profile_screen.dart';
import '../../screens/auth/child_login_screen.dart';
import '../../screens/parent/parent_dashboard_screen.dart';
import '../../screens/parent/add_child_screen.dart';
import '../../screens/parent/edit_child_screen.dart';
import '../../screens/contact/contact_screen.dart';
import '../../screens/education/education_categories_screen.dart';
import '../../screens/education/education_content_screen.dart';
import '../../screens/events/event_report_screen.dart';
import '../../screens/events/events_list_screen.dart';
import '../../screens/events/event_detail_screen.dart';
import '../../screens/feedback/feedback_screen.dart';
import '../../screens/home/mandala_home_screen.dart';
import '../../screens/news/news_detail_screen.dart';
import '../../screens/news/news_list_screen.dart';
import '../../screens/subscription/subscribe_screen.dart';
import '../../screens/language/language_selection_screen.dart';
import '../../screens/content/chapter_list_screen.dart';
import '../../screens/content/chapter_detail_screen.dart';
import '../../screens/safety/online_safety_screen.dart';
import '../../screens/safety/safety_topic_screen.dart';
import '../../screens/safety/safety_tips_screen.dart';
import '../../screens/safety/report_concern_screen.dart';
import '../../screens/chatbot/chatbot_screen.dart';

/// Route names for type-safe navigation
class AppRoutes {
  static const String languageSelection = 'language-selection';
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
  // Auth routes
  static const String login = 'login';
  static const String otpVerification = 'otp-verification';
  static const String childSetup = 'child-setup';
  static const String selectProfile = 'select-profile';
  static const String childLogin = 'child-login';
  // Parent routes
  static const String parentDashboard = 'parent-dashboard';
  static const String addChild = 'add-child';
  static const String editChild = 'edit-child';
  // Content routes
  static const String chapters = 'chapters';
  static const String chapterDetail = 'chapter-detail';
  // Events routes
  static const String events = 'events';
  static const String eventDetail = 'event-detail';
  // Safety routes
  static const String onlineSafety = 'online-safety';
  static const String safetyTopic = 'safety-topic';
  static const String safetyTips = 'safety-tips';
  static const String reportConcern = 'report-concern';
  // Chatbot routes
  static const String chatbot = 'chatbot';
}

/// Route paths
class AppPaths {
  static const String languageSelection = '/language';
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
  // Auth paths
  static const String login = '/login';
  static const String otpVerification = '/auth/otp';
  static const String childSetup = '/auth/child-setup';
  static const String selectProfile = '/auth/select-profile';
  static const String childLogin = '/auth/child-login';
  // Parent paths
  static const String parentDashboard = '/parent';
  static const String addChild = '/parent/children/add';
  static const String editChild = '/parent/children/:childId';
  // Content paths
  static const String chapters = '/content/chapters';
  static const String chapterDetail = '/content/chapters/:chapterId';
  // Events paths
  static const String events = '/events';
  static const String eventDetail = '/events/:eventId';
  // Safety paths
  static const String onlineSafety = '/safety';
  static const String safetyTopic = '/safety/:categoryId';
  static const String safetyTips = '/safety/tips';
  static const String reportConcern = '/safety/report';
  // Chatbot paths
  static const String chatbot = '/chatbot';

  /// Routes that require authentication
  static const List<String> protectedRoutes = [
    eventsReport,
    parentDashboard,
    addChild,
  ];

  /// Auth routes - redirect TO home if already authenticated
  static const List<String> authRoutes = [
    login,
    otpVerification,
  ];

  /// Post-auth routes - require authentication but are part of onboarding
  static const List<String> postAuthRoutes = [
    childSetup,
    selectProfile,
    childLogin,
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
    initialLocation: AppPaths.languageSelection,
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

      // Check if on an auth route (login/otp only)
      final isAuthRoute = AppPaths.authRoutes.any(
        (route) => currentPath == route,
      );

      // Check if on a post-auth route (child-setup, select-profile, child-login)
      final isPostAuthRoute = AppPaths.postAuthRoutes.any(
        (route) => currentPath == route,
      );

      // Redirect unauthenticated users away from protected routes
      if (isProtectedRoute && !isAuthenticated) {
        return '${AppPaths.login}?redirect=${Uri.encodeComponent(currentPath)}';
      }

      // Redirect unauthenticated users away from post-auth routes
      if (isPostAuthRoute && !isAuthenticated) {
        return AppPaths.login;
      }

      // Redirect authenticated users away from login/otp routes only
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
  // Language Selection (first launch)
  GoRoute(
    path: AppPaths.languageSelection,
    name: AppRoutes.languageSelection,
    builder: (context, state) => const LanguageSelectionScreen(),
  ),

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
    builder: (context, state) => const ParentLoginScreen(),
  ),
  GoRoute(
    path: AppPaths.otpVerification,
    name: AppRoutes.otpVerification,
    builder: (context, state) {
      final phoneNumber = state.extra as String? ?? '';
      return OtpVerificationScreen(phoneNumber: phoneNumber);
    },
  ),
  GoRoute(
    path: AppPaths.childSetup,
    name: AppRoutes.childSetup,
    builder: (context, state) {
      final isFirstChild = state.extra as bool? ?? true;
      return ChildSetupScreen(isFirstChild: isFirstChild);
    },
  ),
  GoRoute(
    path: AppPaths.selectProfile,
    name: AppRoutes.selectProfile,
    builder: (context, state) => const SelectProfileScreen(),
  ),
  GoRoute(
    path: AppPaths.childLogin,
    name: AppRoutes.childLogin,
    builder: (context, state) {
      final child = state.extra as ChildProfile;
      return ChildLoginScreen(child: child);
    },
  ),

  // Parent routes
  GoRoute(
    path: AppPaths.parentDashboard,
    name: AppRoutes.parentDashboard,
    builder: (context, state) => const ParentDashboardScreen(),
  ),
  GoRoute(
    path: AppPaths.addChild,
    name: AppRoutes.addChild,
    builder: (context, state) => const AddChildScreen(),
  ),
  GoRoute(
    path: AppPaths.editChild,
    name: AppRoutes.editChild,
    builder: (context, state) {
      final childId = state.pathParameters['childId']!;
      return EditChildScreen(childId: childId);
    },
  ),

  // Content routes
  GoRoute(
    path: AppPaths.chapters,
    name: AppRoutes.chapters,
    builder: (context, state) => const ChapterListScreen(),
  ),
  GoRoute(
    path: AppPaths.chapterDetail,
    name: AppRoutes.chapterDetail,
    builder: (context, state) {
      final chapterId = state.pathParameters['chapterId']!;
      return ChapterDetailScreen(chapterId: chapterId);
    },
  ),

  // Events routes (Phase 9)
  GoRoute(
    path: AppPaths.events,
    name: AppRoutes.events,
    builder: (context, state) => const EventsListScreen(),
  ),
  GoRoute(
    path: AppPaths.eventDetail,
    name: AppRoutes.eventDetail,
    builder: (context, state) {
      final eventId = state.pathParameters['eventId']!;
      return EventDetailScreen(eventId: eventId);
    },
  ),

  // Safety routes (Phase 8)
  GoRoute(
    path: AppPaths.safetyTips,
    name: AppRoutes.safetyTips,
    builder: (context, state) => const SafetyTipsScreen(),
  ),
  GoRoute(
    path: AppPaths.reportConcern,
    name: AppRoutes.reportConcern,
    builder: (context, state) => const ReportConcernScreen(),
  ),
  GoRoute(
    path: AppPaths.onlineSafety,
    name: AppRoutes.onlineSafety,
    builder: (context, state) => const OnlineSafetyScreen(),
  ),
  GoRoute(
    path: AppPaths.safetyTopic,
    name: AppRoutes.safetyTopic,
    builder: (context, state) {
      final categoryId = state.pathParameters['categoryId']!;
      return SafetyTopicScreen(categoryId: categoryId);
    },
  ),

  // Chatbot route (Phase 10)
  GoRoute(
    path: AppPaths.chatbot,
    name: AppRoutes.chatbot,
    builder: (context, state) => const ChatbotScreen(),
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
