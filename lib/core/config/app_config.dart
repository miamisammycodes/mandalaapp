/// Application configuration and constants
///
/// This class contains all app-wide configuration settings.
/// Currently using static constants for simplicity during the mock data phase.
/// When backend API is ready, consider using `--dart-define` for build-time
/// configuration or implement Flavors for different environments.
class AppConfig {
  // Private constructor to prevent instantiation
  AppConfig._();

  // ============================================================================
  // App Information
  // ============================================================================

  /// Application name
  static const String appName = 'UNICEF Child Protection';

  /// Application version
  static const String appVersion = '1.0.0';

  /// Build number
  static const int buildNumber = 1;

  // ============================================================================
  // Feature Flags
  // ============================================================================

  /// Flag to enable/disable mock data (always true until backend is ready)
  static const bool useMockData = true;

  /// Enable debug logging in console
  static const bool enableLogging = true;

  /// Enable analytics tracking
  static const bool enableAnalytics = false;

  /// Enable crash reporting
  static const bool enableCrashReporting = false;

  // ============================================================================
  // API Configuration
  // ============================================================================

  /// Base URL for API endpoints (placeholder - not used with mock data)
  static const String apiBaseUrl = 'http://localhost:3000/api/v1';

  /// API timeout in milliseconds
  static const int apiTimeout = 30000; // 30 seconds

  /// Mock data network delay simulation in milliseconds
  static const int mockNetworkDelay = 800; // 800ms

  // ============================================================================
  // Pagination Configuration
  // ============================================================================

  /// Default page size for lists
  static const int defaultPageSize = 20;

  /// Maximum page size
  static const int maxPageSize = 50;

  // ============================================================================
  // File Upload Configuration
  // ============================================================================

  /// Maximum image file size in bytes (10MB)
  static const int maxImageSize = 10 * 1024 * 1024; // 10MB

  /// Maximum video file size in bytes (50MB)
  static const int maxVideoSize = 50 * 1024 * 1024; // 50MB

  /// Maximum PDF file size in bytes (10MB)
  static const int maxPdfSize = 10 * 1024 * 1024; // 10MB

  /// Image compression quality (0-100)
  static const int imageCompressionQuality = 85;

  /// Maximum image dimensions for compression
  static const int maxImageWidth = 1920;
  static const int maxImageHeight = 1920;

  // ============================================================================
  // Authentication Configuration
  // ============================================================================

  /// Token expiry duration in hours
  static const int tokenExpiryHours = 24;

  /// Enable biometric authentication
  static const bool enableBiometricAuth = false;

  // ============================================================================
  // Cache Configuration
  // ============================================================================

  /// Cache duration for news articles in hours
  static const int newsCacheDuration = 1;

  /// Cache duration for educational content in hours
  static const int contentCacheDuration = 24;

  /// Maximum cache size in MB
  static const int maxCacheSize = 100;

  // ============================================================================
  // UI Configuration
  // ============================================================================

  /// Default animation duration in milliseconds
  static const int defaultAnimationDuration = 300;

  /// Toast/Snackbar duration in seconds
  static const int toastDuration = 3;

  /// Error toast duration in seconds
  static const int errorToastDuration = 5;

  // ============================================================================
  // Helper Methods
  // ============================================================================

  /// Check if app is running in debug mode
  static bool get isDebugMode {
    bool inDebugMode = false;
    assert(inDebugMode = true);
    return inDebugMode;
  }

  /// Check if app is running in release mode
  static bool get isReleaseMode => !isDebugMode;

  /// Get environment name
  static String get environment {
    if (useMockData) return 'Mock Data';
    if (isDebugMode) return 'Development';
    return 'Production';
  }

  /// Print configuration summary (for debugging)
  static void printConfig() {
    if (!enableLogging) return;

    print('═══════════════════════════════════════════════');
    print('📱 $appName v$appVersion ($buildNumber)');
    print('═══════════════════════════════════════════════');
    print('Environment: $environment');
    print('Mock Data: $useMockData');
    print('Debug Logging: $enableLogging');
    print('Analytics: $enableAnalytics');
    print('Crash Reporting: $enableCrashReporting');
    print('API Base URL: $apiBaseUrl');
    print('═══════════════════════════════════════════════');
  }
}
