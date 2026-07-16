import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class ThemeState {
  final ThemeMode mode;

  const ThemeState({this.mode = ThemeMode.system});

  bool get isDark => mode == ThemeMode.dark;
  bool get isLight => mode == ThemeMode.light;
  bool get isSystem => mode == ThemeMode.system;

  ThemeState copyWith({ThemeMode? mode}) => ThemeState(mode: mode ?? this.mode);
}

class ThemeNotifier extends Notifier<ThemeState> {
  @override
  ThemeState build() => const ThemeState();

  void setMode(ThemeMode mode) => state = state.copyWith(mode: mode);
}

final themeProvider = NotifierProvider<ThemeNotifier, ThemeState>(
  ThemeNotifier.new,
);
