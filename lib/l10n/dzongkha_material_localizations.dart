import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Custom Material Localizations delegate for Dzongkha
/// Falls back to English since Flutter doesn't have native Dzongkha support
class DzongkhaMaterialLocalizations extends DefaultMaterialLocalizations {
  const DzongkhaMaterialLocalizations();

  static const LocalizationsDelegate<MaterialLocalizations> delegate =
      _DzongkhaMaterialLocalizationsDelegate();
}

class _DzongkhaMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const _DzongkhaMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'dz';
  }

  @override
  Future<MaterialLocalizations> load(Locale locale) {
    return SynchronousFuture<MaterialLocalizations>(
      const DzongkhaMaterialLocalizations(),
    );
  }

  @override
  bool shouldReload(_DzongkhaMaterialLocalizationsDelegate old) => false;
}

/// Custom Cupertino Localizations delegate for Dzongkha
class DzongkhaCupertinoLocalizations extends DefaultCupertinoLocalizations {
  const DzongkhaCupertinoLocalizations();

  static const LocalizationsDelegate<CupertinoLocalizations> delegate =
      _DzongkhaCupertinoLocalizationsDelegate();
}

class _DzongkhaCupertinoLocalizationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const _DzongkhaCupertinoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return locale.languageCode == 'dz';
  }

  @override
  Future<CupertinoLocalizations> load(Locale locale) {
    return SynchronousFuture<CupertinoLocalizations>(
      const DzongkhaCupertinoLocalizations(),
    );
  }

  @override
  bool shouldReload(_DzongkhaCupertinoLocalizationsDelegate old) => false;
}
