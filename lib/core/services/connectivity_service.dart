import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../config/app_config.dart';

/// Connectivity Service
///
/// Monitors network connectivity status and provides real-time updates
/// when connectivity changes. Used to detect online/offline states
/// and show appropriate UI feedback to users.
///
/// Features:
/// - Current connectivity status checking
/// - Real-time connectivity change stream
/// - Online/offline detection
/// - Support for WiFi, mobile data, ethernet, and offline states
class ConnectivityService {
  // Singleton instance
  static final ConnectivityService _instance = ConnectivityService._internal();
  factory ConnectivityService() => _instance;

  late final Connectivity _connectivity;
  late final StreamController<ConnectivityStatus> _statusController;

  // Current connectivity status
  ConnectivityStatus _currentStatus = ConnectivityStatus.unknown;

  // Private constructor
  ConnectivityService._internal() {
    _connectivity = Connectivity();
    _statusController = StreamController<ConnectivityStatus>.broadcast();
    _initialize();
  }

  /// Get current connectivity status
  ConnectivityStatus get currentStatus => _currentStatus;

  /// Get connectivity status stream
  ///
  /// Listen to this stream for real-time connectivity updates
  Stream<ConnectivityStatus> get statusStream => _statusController.stream;

  // ============================================================================
  // INITIALIZATION
  // ============================================================================

  /// Initialize connectivity monitoring
  Future<void> _initialize() async {
    try {
      // Check initial connectivity status
      await checkConnectivity();

      // Listen for connectivity changes
      _connectivity.onConnectivityChanged.listen(
        (List<ConnectivityResult> results) {
          _handleConnectivityChange(results);
        },
        onError: (error) {
          if (AppConfig.enableLogging) {
            print('❌ Connectivity error: $error');
          }
        },
      );

      if (AppConfig.enableLogging) {
        print('📡 Connectivity service initialized');
      }
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error initializing connectivity service: $e');
      }
    }
  }

  // ============================================================================
  // CONNECTIVITY CHECKING
  // ============================================================================

  /// Check current connectivity status
  ///
  /// Returns the current connectivity status and updates internal state
  Future<ConnectivityStatus> checkConnectivity() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _handleConnectivityChange(results);
      return _currentStatus;
    } catch (e) {
      if (AppConfig.enableLogging) {
        print('❌ Error checking connectivity: $e');
      }
      _updateStatus(ConnectivityStatus.unknown);
      return ConnectivityStatus.unknown;
    }
  }

  /// Handle connectivity change
  void _handleConnectivityChange(List<ConnectivityResult> results) {
    if (results.isEmpty) {
      _updateStatus(ConnectivityStatus.offline);
      return;
    }

    // Check if any connection is available
    // Priority: WiFi > Mobile > Ethernet > Other
    if (results.contains(ConnectivityResult.wifi)) {
      _updateStatus(ConnectivityStatus.wifi);
    } else if (results.contains(ConnectivityResult.mobile)) {
      _updateStatus(ConnectivityStatus.mobile);
    } else if (results.contains(ConnectivityResult.ethernet)) {
      _updateStatus(ConnectivityStatus.ethernet);
    } else if (results.contains(ConnectivityResult.vpn)) {
      _updateStatus(ConnectivityStatus.vpn);
    } else if (results.contains(ConnectivityResult.none)) {
      _updateStatus(ConnectivityStatus.offline);
    } else {
      _updateStatus(ConnectivityStatus.other);
    }
  }

  /// Update connectivity status and notify listeners
  void _updateStatus(ConnectivityStatus newStatus) {
    if (_currentStatus != newStatus) {
      final oldStatus = _currentStatus;
      _currentStatus = newStatus;

      // Add to stream
      if (!_statusController.isClosed) {
        _statusController.add(newStatus);
      }

      if (AppConfig.enableLogging) {
        print('📡 Connectivity changed: ${oldStatus.label} → ${newStatus.label}');
      }
    }
  }

  // ============================================================================
  // UTILITY METHODS
  // ============================================================================

  /// Check if device is online
  ///
  /// Returns true if any network connection is available
  bool get isOnline {
    return _currentStatus != ConnectivityStatus.offline &&
        _currentStatus != ConnectivityStatus.unknown;
  }

  /// Check if device is offline
  ///
  /// Returns true if no network connection is available
  bool get isOffline {
    return _currentStatus == ConnectivityStatus.offline;
  }

  /// Check if connected via WiFi
  bool get isWifi => _currentStatus == ConnectivityStatus.wifi;

  /// Check if connected via mobile data
  bool get isMobile => _currentStatus == ConnectivityStatus.mobile;

  /// Check if connected via ethernet
  bool get isEthernet => _currentStatus == ConnectivityStatus.ethernet;

  /// Check if connected via VPN
  bool get isVPN => _currentStatus == ConnectivityStatus.vpn;

  /// Get human-readable connection type
  String get connectionType => _currentStatus.label;

  // ============================================================================
  // CLEANUP
  // ============================================================================

  /// Dispose connectivity service
  ///
  /// Call this when the service is no longer needed
  void dispose() {
    _statusController.close();
    if (AppConfig.enableLogging) {
      print('📡 Connectivity service disposed');
    }
  }
}

// ==============================================================================
// CONNECTIVITY STATUS ENUM
// ==============================================================================

/// Connectivity status types
enum ConnectivityStatus {
  /// WiFi connection
  wifi,

  /// Mobile data connection (3G, 4G, 5G)
  mobile,

  /// Ethernet connection
  ethernet,

  /// VPN connection
  vpn,

  /// Other connection type
  other,

  /// No connection available
  offline,

  /// Unknown connectivity state
  unknown;

  /// Get human-readable label
  String get label {
    switch (this) {
      case ConnectivityStatus.wifi:
        return 'WiFi';
      case ConnectivityStatus.mobile:
        return 'Mobile Data';
      case ConnectivityStatus.ethernet:
        return 'Ethernet';
      case ConnectivityStatus.vpn:
        return 'VPN';
      case ConnectivityStatus.other:
        return 'Connected';
      case ConnectivityStatus.offline:
        return 'Offline';
      case ConnectivityStatus.unknown:
        return 'Unknown';
    }
  }

  /// Get emoji for status
  String get emoji {
    switch (this) {
      case ConnectivityStatus.wifi:
        return '📶';
      case ConnectivityStatus.mobile:
        return '📱';
      case ConnectivityStatus.ethernet:
        return '🔌';
      case ConnectivityStatus.vpn:
        return '🔒';
      case ConnectivityStatus.other:
        return '🌐';
      case ConnectivityStatus.offline:
        return '📵';
      case ConnectivityStatus.unknown:
        return '❓';
    }
  }

  /// Check if this status represents an online state
  bool get isOnline {
    return this != ConnectivityStatus.offline &&
        this != ConnectivityStatus.unknown;
  }

  /// Check if this status represents an offline state
  bool get isOffline => this == ConnectivityStatus.offline;
}
