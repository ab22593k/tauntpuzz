import 'package:flutter/material.dart';

/// Manages the app's locale override for multi-language support.
///
/// When [_locale] is `null` (the default), the app follows the system
/// locale. Calling [setLocale] overrides this to a specific language;
/// [resetToSystem] returns control to the OS setting.
///
/// Consumed by [LanguagePicker] in the drawer and by [App] which passes
/// [locale] to [MaterialApp.router] for Flutter's built-in localization
/// resolution via [AppLocalizations].
class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  /// The overridden locale, or `null` to use the system locale.
  Locale? get locale => _locale;

  /// Whether a locale override is active (as opposed to system default).
  bool get isOverridden => _locale != null;

  /// Overrides the app locale to the given [locale].
  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  /// Clears the locale override, returning to the system locale.
  void resetToSystem() {
    _locale = null;
    notifyListeners();
  }
}
