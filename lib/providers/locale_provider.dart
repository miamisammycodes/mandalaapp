import 'dart:ui';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Supported locales in the app
class AppLocales {
  static const Locale english = Locale('en');
  static const Locale dzongkha = Locale('dz');

  static const List<Locale> supportedLocales = [english, dzongkha];

  static const String _storageKey = 'app_locale';

  /// Get locale from language code
  static Locale fromCode(String code) {
    switch (code) {
      case 'dz':
        return dzongkha;
      case 'en':
      default:
        return english;
    }
  }

  /// Get display name for locale
  static String getDisplayName(Locale locale) {
    switch (locale.languageCode) {
      case 'dz':
        return 'རྫོང་ཁ (Dzongkha)';
      case 'en':
      default:
        return 'English';
    }
  }

  /// Get native name for locale
  static String getNativeName(Locale locale) {
    switch (locale.languageCode) {
      case 'dz':
        return 'རྫོང་ཁ';
      case 'en':
      default:
        return 'English';
    }
  }
}

/// Locale state notifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(AppLocales.english) {
    _loadSavedLocale();
  }

  /// Load saved locale from storage
  Future<void> _loadSavedLocale() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedCode = prefs.getString(AppLocales._storageKey);
      if (savedCode != null) {
        state = AppLocales.fromCode(savedCode);
      }
    } catch (e) {
      // Use default locale on error
    }
  }

  /// Set locale and persist
  Future<void> setLocale(Locale locale) async {
    state = locale;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(AppLocales._storageKey, locale.languageCode);
    } catch (e) {
      // Continue with in-memory locale on error
    }
  }

  /// Set English locale
  Future<void> setEnglish() => setLocale(AppLocales.english);

  /// Set Dzongkha locale
  Future<void> setDzongkha() => setLocale(AppLocales.dzongkha);

  /// Toggle between locales
  Future<void> toggleLocale() async {
    if (state.languageCode == 'en') {
      await setDzongkha();
    } else {
      await setEnglish();
    }
  }

  /// Check if current locale is English
  bool get isEnglish => state.languageCode == 'en';

  /// Check if current locale is Dzongkha
  bool get isDzongkha => state.languageCode == 'dz';
}

/// Provider for locale state
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Provider to check if locale has been selected (first launch)
final hasSelectedLocaleProvider = FutureProvider<bool>((ref) async {
  try {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey(AppLocales._storageKey);
  } catch (e) {
    return false;
  }
});

/// Mark locale as selected (after first language selection)
Future<void> markLocaleSelected() async {
  // The locale is marked as selected when setLocale is called
  // This provider just checks if a locale key exists
}
