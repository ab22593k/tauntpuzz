import 'package:flutter/material.dart';

/// Brand color tokens for the Leafy puzzle app.
///
/// The [brandSeed] is the single key color that seeds the Material 3
/// color system. Per the M3 "Customizing Material" spec, it generates
/// the fallback brand scheme (used when dynamic color is unavailable)
/// and is the value user-generated dynamic color schemes map onto.
///
/// The explicit role constants below remain the hand-tuned monochrome
/// palette used by [AppTheme.brandLight] / [AppTheme.brandDark] — the
/// deterministic fallback that preserves the app's identity regardless
/// of platform dynamic-color support.
class AppColors {
  /// The brand key color. A near-black anchors the "Leafy" space
  /// aesthetic; seeding M3 with it yields tonal palettes that stay
  /// neutral and high-contrast in both light and dark.
  static const Color brandSeed = Color(0xff1b1b1b);

  static const Color primary = Color(0xff000000);
  static const Color onPrimary = Color(0xffe2e2e2);
  static const Color primaryContainer = Color(0xff3b3b3b);
  static const Color onPrimaryContainer = Color(0xffcccccc);

  static const Color secondary = Color(0xff595959);
  static const Color onSecondary = Color(0xffffffff);
  static const Color secondaryContainer = Color(0xffe8e8e8);
  static const Color onSecondaryContainer = Color(0xff2b2b2b);

  static const Color tertiary = Color(0xff717171);
  static const Color onTertiary = Color(0xffffffff);
  static const Color tertiaryContainer = Color(0xfff0f0f0);
  static const Color onTertiaryContainer = Color(0xff2b2b2b);

  static const Color error = Color(0xffba1a1a);
  static const Color onError = Color(0xffffffff);
  static const Color errorContainer = Color(0xffffdad6);
  static const Color onErrorContainer = Color(0xff410002);

  static const Color background = Color(0xfff9f9f9);
  static const Color onBackground = Color(0xff1b1b1b);

  static const Color surface = Color(0xfff9f9f9);
  static const Color onSurface = Color(0xff1b1b1b);
  static const Color surfaceVariant = Color(0xffe8e8e8);
  static const Color onSurfaceVariant = Color(0xff494949);

  static const Color outline = Color(0xff747474);
  static const Color outlineVariant = Color(0xffc6c6c6);

  static const Color deepSpace = Color(0xff1b1b1b);
  static const Color nebulaPurple = Color(0xff3b3b3b);
  static const Color stellarWhite = Color(0xffffffff);

  static const Color glassSurface = Color(0xB2EEEEEE);
  static const Color glassBorder = Color(0x40C6C6C6);

  static const Color surfaceDim = Color(0xffdadada);
  static const Color surfaceBright = Color(0xfffafafa);
  static const Color surfaceContainerLowest = Color(0xffffffff);
  static const Color surfaceContainerLow = Color(0xfff3f3f3);
  static const Color surfaceContainer = Color(0xffeeeeee);
  static const Color surfaceContainerHigh = Color(0xffe8e8e8);
  static const Color surfaceContainerHighest = Color(0xffdddddd);

  static const Color primaryFixed = Color(0xff000000);
  static const Color primaryFixedDim = Color(0xff3b3b3b);
  static const Color onPrimaryFixed = Color(0xffffffff);
  static const Color onPrimaryFixedVariant = Color(0xffe2e2e2);

  static const Color secondaryFixed = Color(0xffe8e8e8);
  static const Color secondaryFixedDim = Color(0xffc6c6c7);
  static const Color onSecondaryFixed = Color(0xff1b1b1b);
  static const Color onSecondaryFixedVariant = Color(0xff494949);

  static const Color tertiaryFixed = Color(0xfff0f0f0);
  static const Color tertiaryFixedDim = Color(0xffd6d6d6);
  static const Color onTertiaryFixed = Color(0xff1b1b1b);
  static const Color onTertiaryFixedVariant = Color(0xff494949);
}
