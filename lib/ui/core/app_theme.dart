import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:leafz/ui/core/app_colors.dart';
import 'package:leafz/ui/core/app_colors_dark.dart';
import 'package:leafz/ui/core/app_text_styles.dart';

/// Material 3 theme layer for the Leafz app.
///
/// Implements the M3 "Customizing Material" customization model:
///
/// 1. **Brand seed** — [AppColors.brandSeed] is the single key color that
///    defines the brand. It seeds the fallback brand color scheme.
/// 2. **Fallback brand scheme** — [brandLight] / [brandDark] are the
///    deterministic schemes used when dynamic color is off or
///    unavailable. Per M3 spec, a fallback must always exist.
/// 3. **Custom theme that dynamic schemes map to** — [resolve] takes the
///    device's dynamic color scheme (from `DynamicColorBuilder`) and
///    harmonizes it with the brand scheme. Dynamic color overrides hue
///    while the app's component structure (buttons, dialogs, drawer,
///    typography) stays unchanged — "familiar patterns, accessible
///    interactions."
///
/// The component themes below are shared across brand and dynamic schemes
/// so only *tokens* (color, shape) change, never *patterns* (which button
/// style, which dialog shape). This preserves the user's mental model
/// across theme variants — see *Designing Interfaces* Ch.11.
class AppTheme {
  AppTheme._();

  /// Brand key color, exposed for tooling (e.g. Material Theme Builder
  /// parity checks) and as the `seedColor` on fallback schemes.
  static const Color brandSeed = AppColors.brandSeed;

  // ---------------------------------------------------------------------------
  // Fallback brand color schemes (M3: always ship a fallback)
  // ---------------------------------------------------------------------------

  /// The deterministic light scheme, seeded from [brandSeed].
  ///
  /// Used when dynamic color is disabled or unavailable, and as the base
  /// that dynamic schemes harmonize onto.
  static const ColorScheme brandLight = ColorScheme(
    brightness: Brightness.light,
    primary: AppColors.primary,
    onPrimary: AppColors.onPrimary,
    primaryContainer: AppColors.primaryContainer,
    onPrimaryContainer: AppColors.onPrimaryContainer,
    secondary: AppColors.secondary,
    onSecondary: AppColors.onSecondary,
    secondaryContainer: AppColors.secondaryContainer,
    onSecondaryContainer: AppColors.onSecondaryContainer,
    tertiary: AppColors.tertiary,
    onTertiary: AppColors.onTertiary,
    tertiaryContainer: AppColors.tertiaryContainer,
    onTertiaryContainer: AppColors.onTertiaryContainer,
    error: AppColors.error,
    onError: AppColors.onError,
    errorContainer: AppColors.errorContainer,
    onErrorContainer: AppColors.onErrorContainer,
    surface: AppColors.surface,
    onSurface: AppColors.onSurface,
    onSurfaceVariant: AppColors.onSurfaceVariant,
    outline: AppColors.outline,
    outlineVariant: AppColors.outlineVariant,
    surfaceDim: AppColors.surfaceDim,
    surfaceBright: AppColors.surfaceBright,
    surfaceContainerLowest: AppColors.surfaceContainerLowest,
    surfaceContainerLow: AppColors.surfaceContainerLow,
    surfaceContainer: AppColors.surfaceContainer,
    surfaceContainerHigh: AppColors.surfaceContainerHigh,
    surfaceContainerHighest: AppColors.surfaceContainerHighest,
    primaryFixed: AppColors.primaryFixed,
    primaryFixedDim: AppColors.primaryFixedDim,
    onPrimaryFixed: AppColors.onPrimaryFixed,
    onPrimaryFixedVariant: AppColors.onPrimaryFixedVariant,
    secondaryFixed: AppColors.secondaryFixed,
    secondaryFixedDim: AppColors.secondaryFixedDim,
    onSecondaryFixed: AppColors.onSecondaryFixed,
    onSecondaryFixedVariant: AppColors.onSecondaryFixedVariant,
    tertiaryFixed: AppColors.tertiaryFixed,
    tertiaryFixedDim: AppColors.tertiaryFixedDim,
    onTertiaryFixed: AppColors.onTertiaryFixed,
    onTertiaryFixedVariant: AppColors.onTertiaryFixedVariant,
  );

  /// The deterministic dark scheme, seeded from [brandSeed].
  static const ColorScheme brandDark = ColorScheme(
    brightness: Brightness.dark,
    primary: AppColorsDark.primary,
    onPrimary: AppColorsDark.onPrimary,
    primaryContainer: AppColorsDark.primaryContainer,
    onPrimaryContainer: AppColorsDark.onPrimaryContainer,
    secondary: AppColorsDark.secondary,
    onSecondary: AppColorsDark.onSecondary,
    secondaryContainer: AppColorsDark.secondaryContainer,
    onSecondaryContainer: AppColorsDark.onSecondaryContainer,
    tertiary: AppColorsDark.tertiary,
    onTertiary: AppColorsDark.onTertiary,
    tertiaryContainer: AppColorsDark.tertiaryContainer,
    onTertiaryContainer: AppColorsDark.onTertiaryContainer,
    error: AppColorsDark.error,
    onError: AppColorsDark.onError,
    errorContainer: AppColorsDark.errorContainer,
    onErrorContainer: AppColorsDark.onErrorContainer,
    surface: AppColorsDark.surface,
    onSurface: AppColorsDark.onSurface,
    onSurfaceVariant: AppColorsDark.onSurfaceVariant,
    outline: AppColorsDark.outline,
    outlineVariant: AppColorsDark.outlineVariant,
    surfaceDim: AppColorsDark.surfaceDim,
    surfaceBright: AppColorsDark.surfaceBright,
    surfaceContainerLowest: AppColorsDark.surfaceContainerLowest,
    surfaceContainerLow: AppColorsDark.surfaceContainerLow,
    surfaceContainer: AppColorsDark.surfaceContainer,
    surfaceContainerHigh: AppColorsDark.surfaceContainerHigh,
    surfaceContainerHighest: AppColorsDark.surfaceContainerHighest,
    primaryFixed: AppColorsDark.primaryFixed,
    primaryFixedDim: AppColorsDark.primaryFixedDim,
    onPrimaryFixed: AppColorsDark.onPrimaryFixed,
    onPrimaryFixedVariant: AppColorsDark.onPrimaryFixedVariant,
    secondaryFixed: AppColorsDark.secondaryFixed,
    secondaryFixedDim: AppColorsDark.secondaryFixedDim,
    onSecondaryFixed: AppColorsDark.onSecondaryFixed,
    onSecondaryFixedVariant: AppColorsDark.onSecondaryFixedVariant,
    tertiaryFixed: AppColorsDark.tertiaryFixed,
    tertiaryFixedDim: AppColorsDark.tertiaryFixedDim,
    onTertiaryFixed: AppColorsDark.onTertiaryFixed,
    onTertiaryFixedVariant: AppColorsDark.onTertiaryFixedVariant,
  );

  // ---------------------------------------------------------------------------
  // Theme resolution — maps dynamic color onto the custom theme
  // ---------------------------------------------------------------------------

  /// Builds the light [ThemeData].
  ///
  /// Pass [dynamicLight] from `DynamicColorBuilder` to let the device's
  /// wallpaper-derived scheme override the brand scheme's hue. When null
  /// (dynamic color off / unsupported), the [brandLight] fallback is used.
  static ThemeData light({ColorScheme? dynamicLight}) {
    final colorScheme = dynamicLight ?? brandLight;
    return _base(
      colorScheme: colorScheme,
      brightness: Brightness.light,
      scaffoldBackground: AppColors.background,
      overlayTint: AppColors.stellarWhite,
      systemOverlay: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.dark,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xfff9f9f9),
      ),
    );
  }

  /// Builds the dark [ThemeData].
  ///
  /// Pass [dynamicDark] from `DynamicColorBuilder` to let the device's
  /// wallpaper-derived scheme override the brand scheme's hue. When null,
  /// the [brandDark] fallback is used.
  static ThemeData dark({ColorScheme? dynamicDark}) {
    final colorScheme = dynamicDark ?? brandDark;
    return _base(
      colorScheme: colorScheme,
      brightness: Brightness.dark,
      scaffoldBackground: AppColorsDark.background,
      overlayTint: AppColorsDark.deepSpace,
      systemOverlay: const SystemUiOverlayStyle(
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Color(0xff131313),
      ),
    );
  }

  static ThemeData _base({
    required ColorScheme colorScheme,
    required Brightness brightness,
    required Color scaffoldBackground,
    required Color overlayTint,
    required SystemUiOverlayStyle systemOverlay,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AppTextStyles.secondaryFontFamily,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: scaffoldBackground,
      appBarTheme: AppBarTheme(systemOverlayStyle: systemOverlay),
      textTheme: TextTheme(
        displayLarge: AppTextStyles.displayLarge,
        displayMedium: AppTextStyles.displayMedium,
        displaySmall: AppTextStyles.displaySmall,
        headlineLarge: AppTextStyles.headlineLarge,
        headlineMedium: AppTextStyles.headlineMedium,
        headlineSmall: AppTextStyles.headlineSmall,
        titleLarge: AppTextStyles.titleLarge,
        titleMedium: AppTextStyles.titleMedium,
        titleSmall: AppTextStyles.titleSmall,
        bodyLarge: AppTextStyles.bodyLarge,
        bodyMedium: AppTextStyles.bodyMedium,
        bodySmall: AppTextStyles.bodySmall,
        labelLarge: AppTextStyles.labelLarge,
        labelMedium: AppTextStyles.labelMedium,
        labelSmall: AppTextStyles.labelSmall,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style:
            ElevatedButton.styleFrom(
              foregroundColor: colorScheme.onPrimary,
              textStyle: AppTextStyles.button,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              backgroundColor: colorScheme.primary,
              elevation: 0,
              shadowColor: Colors.transparent,
              padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
            ).copyWith(
              overlayColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.hovered)) {
                  return overlayTint.withValues(alpha: 0.12);
                }
                if (states.contains(WidgetState.pressed)) {
                  return overlayTint.withValues(alpha: 0.24);
                }
                return null;
              }),
            ),
      ),
      dialogTheme: const DialogThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      drawerTheme: const DrawerThemeData(
        backgroundColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.only(
            topEnd: Radius.zero,
            bottomEnd: Radius.zero,
          ),
        ),
      ),
    );
  }
}
