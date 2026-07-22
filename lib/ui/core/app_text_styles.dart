import 'package:flutter/material.dart';
import 'package:leafz/ui/core/layout/screen_type_helper.dart';

class AppTextStyles {
  static const String primaryFontFamily = 'OpenDyslexic';
  static const String secondaryFontFamily = 'OpenDyslexic';

  static TextStyle get tile => const TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
  );

  static TextStyle get tileMobile => const TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
  );

  static TextStyle get title => const TextStyle(
    fontSize: 25,
    fontWeight: FontWeight.w400,
    height: 32 / 25,
    letterSpacing: 0,
  );

  static TextStyle get h1 => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get h1Bold => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get h2 => const TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    letterSpacing: 0,
  );

  static TextStyle get h3 => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get body => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static TextStyle get bodyBold => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
  );

  static TextStyle get bodySm =>
      const TextStyle(fontSize: 14, letterSpacing: 0);

  static TextStyle get bodyXs => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 16 / 11,
    letterSpacing: 0.5,
  );

  static TextStyle get bodyXxs => const TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 12 / 10,
    letterSpacing: 0.5,
  );

  static TextStyle get button => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0.5,
    fontFamily: 'OpenDyslexic',
  );

  static TextStyle get buttonSm => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 1,
    letterSpacing: 0.25,
  );

  static TextStyle get displayLarge => const TextStyle(
    fontSize: 56,
    fontWeight: FontWeight.w400,
    height: 1.1,
    letterSpacing: -0.25,
  );

  static TextStyle get displayMedium => const TextStyle(
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 52 / 45,
    letterSpacing: 0,
  );

  static TextStyle get displaySmall => const TextStyle(
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: 0,
  );

  static TextStyle get headlineLarge => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 1.2,
    letterSpacing: -0.25,
  );

  static TextStyle get headlineMedium => const TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w400,
    height: 40 / 32,
    letterSpacing: 0,
  );

  static TextStyle get headlineSmall => const TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w400,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static TextStyle get titleLarge => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
  );

  static TextStyle get titleMedium => const TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w500,
    height: 1.5,
    letterSpacing: 0.1,
  );

  static TextStyle get titleSmall => const TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.1,
  );

  static TextStyle get labelLarge => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  static TextStyle get labelMedium => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.5,
  );

  static TextStyle get labelSmall => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w600,
    height: 1.4,
    letterSpacing: 1.6,
  );

  static TextStyle get bodyLarge => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
  );

  static TextStyle get bodyMedium => const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 1.6,
    letterSpacing: 0,
  );

  static TextStyle get bodySmall => const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 16 / 11,
    letterSpacing: 0,
  );

  static TextStyle tileAdaptive(WindowClass wc) => switch (wc) {
    WindowClass.compact => tileMobile,
    WindowClass.medium => tile,
    WindowClass.expanded ||
    WindowClass.large ||
    WindowClass.extraLarge => tile.copyWith(fontSize: 36),
  };

  static TextStyle titleAdaptive(WindowClass wc) => switch (wc) {
    WindowClass.compact => titleSmall,
    WindowClass.medium => titleMedium,
    WindowClass.expanded ||
    WindowClass.large ||
    WindowClass.extraLarge => titleLarge,
  };

  static TextStyle bodyAdaptive(WindowClass wc) => switch (wc) {
    WindowClass.compact => bodySmall,
    WindowClass.medium => bodyMedium,
    WindowClass.expanded ||
    WindowClass.large ||
    WindowClass.extraLarge => bodyLarge,
  };

  static TextStyle labelAdaptive(WindowClass wc) => switch (wc) {
    WindowClass.compact => labelSmall,
    WindowClass.medium => labelMedium,
    WindowClass.expanded ||
    WindowClass.large ||
    WindowClass.extraLarge => labelLarge,
  };
}
