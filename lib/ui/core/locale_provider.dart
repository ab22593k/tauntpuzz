import 'package:flutter/material.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  bool get isOverridden => _locale != null;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  void resetToSystem() {
    _locale = null;
    notifyListeners();
  }
}
