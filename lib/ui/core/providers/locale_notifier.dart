import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

@immutable
class LocaleState {
  final Locale? locale;

  const LocaleState({this.locale});

  bool get isOverridden => locale != null;

  LocaleState copyWith({Locale? locale}) =>
      LocaleState(locale: locale ?? this.locale);
}

class LocaleNotifier extends Notifier<LocaleState> {
  @override
  LocaleState build() => const LocaleState();

  void setLocale(Locale locale) => state = state.copyWith(locale: locale);
  void resetToSystem() => state = state.copyWith(locale: null);
}

final localeProvider = NotifierProvider<LocaleNotifier, LocaleState>(
  LocaleNotifier.new,
);
