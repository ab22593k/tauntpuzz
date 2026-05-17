import 'package:flutter/material.dart';

/// Manages the app's visual theme mode — light, dark, or system default.
///
/// Consumed by [DarkModeToggle] in the drawer and by [App] which reads
/// [mode] to select between the light and dark [ThemeData] definitions in
/// `app.dart`.
///
/// Defaults to [ThemeMode.system] so the app follows the OS setting until
/// the user makes an explicit choice.
class ThemeProvider extends ChangeNotifier {
  ThemeMode _mode = ThemeMode.system;

  /// The current theme mode.
  ThemeMode get mode => _mode;

  /// Whether the current mode is explicitly dark.
  bool get isDark => _mode == ThemeMode.dark;

  /// Whether the current mode is explicitly light.
  bool get isLight => _mode == ThemeMode.light;

  /// Whether the current mode follows the OS setting.
  bool get isSystem => _mode == ThemeMode.system;

  /// Switches to the given [mode] and notifies listeners.
  void setMode(ThemeMode mode) {
    _mode = mode;
    notifyListeners();
  }
}
