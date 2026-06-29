import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AppTextStyles {
  static const String primaryFontFamily = 'PaytoneOne';
  static const String secondaryFontFamily = 'Montserrat';

  static const TextStyle tile = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 28,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
  );

  static const TextStyle tileMobile = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 1.0,
    letterSpacing: 0,
  );

  static const TextStyle title = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 25,
    fontWeight: FontWeight.w400,
    height: 32 / 25,
    letterSpacing: 0,
  );

  static const TextStyle h1 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle h1Bold = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle h2 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w400,
    height: 22 / 16,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 420)],
  );

  static const TextStyle h3 = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle body = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 410)],
  );

  static const TextStyle bodyBold = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 20 / 14,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle bodySm = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 415)],
  );

  static const TextStyle bodyXs = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 16 / 11,
    letterSpacing: 0.5,
    fontVariations: [FontVariation('wght', 425)],
  );

  static const TextStyle bodyXxs = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w400,
    height: 12 / 10,
    letterSpacing: 0.5,
    fontVariations: [FontVariation('wght', 450)],
  );

  static const TextStyle button = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    height: 1,
    letterSpacing: 0.5,
  );

  static const TextStyle buttonSm = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 12,
    height: 1,
    letterSpacing: 0.25,
  );

  static const TextStyle displayLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 57,
    fontWeight: FontWeight.w400,
    height: 64 / 57,
    letterSpacing: -0.25,
  );

  static const TextStyle displayMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 45,
    fontWeight: FontWeight.w400,
    height: 52 / 45,
    letterSpacing: 0,
  );

  static const TextStyle displaySmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 36,
    fontWeight: FontWeight.w400,
    height: 44 / 36,
    letterSpacing: 0,
  );

  static const TextStyle headlineLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 56,
    fontWeight: FontWeight.w700,
    height: 64 / 56,
    letterSpacing: -0.25,
  );

  static const TextStyle headlineMedium = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 32,
    fontWeight: FontWeight.w700,
    height: 40 / 32,
    letterSpacing: 0,
  );

  static const TextStyle headlineSmall = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 24,
    fontWeight: FontWeight.w700,
    height: 32 / 24,
    letterSpacing: 0,
  );

  static const TextStyle titleLarge = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 18,
    fontWeight: FontWeight.w700,
    height: 24 / 18,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 700)],
  );

  static const TextStyle titleMedium = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    height: 20 / 14,
    letterSpacing: 0.1,
    fontVariations: [FontVariation('wght', 650)],
  );

  static const TextStyle titleSmall = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    height: 16 / 12,
    letterSpacing: 0.1,
    fontVariations: [FontVariation('wght', 600)],
  );

  static const TextStyle labelLarge = TextStyle(
    fontFamily: primaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    height: 20 / 14,
    letterSpacing: 0.1,
  );

  static const TextStyle labelMedium = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 0.5,
    fontVariations: [FontVariation('wght', 520)],
  );

  static const TextStyle labelSmall = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w500,
    height: 16 / 11,
    letterSpacing: 1.0,
    fontVariations: [FontVariation('wght', 540)],
  );

  static const TextStyle bodyLarge = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w400,
    height: 20 / 14,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 410)],
  );

  static const TextStyle bodyMedium = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 16 / 12,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 415)],
  );

  static const TextStyle bodySmall = TextStyle(
    fontFamily: secondaryFontFamily,
    fontSize: 11,
    fontWeight: FontWeight.w400,
    height: 16 / 11,
    letterSpacing: 0,
    fontVariations: [FontVariation('wght', 425)],
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
