import 'dart:io';

import 'package:lullaby/generated/app_localizations.dart';
import 'package:lullaby/router/router_config.dart';
import 'package:lullaby/ui/core/app_colors.dart';
import 'package:lullaby/ui/core/app_colors_dark.dart';
import 'package:lullaby/ui/core/theme_provider.dart';
import 'package:lullaby/ui/core/theme_transition.dart';
import 'package:lullaby/domain/models/puzzle.dart';
import 'package:lullaby/ui/features/background/background_layers.dart';
import 'package:lullaby/ui/core/layout/background_layer_layout.dart';
import 'package:lullaby/ui/core/app_text_styles.dart';
import 'package:lullaby/ui/core/locale_provider.dart';
import 'package:lullaby/ui/features/phrases/view_models/phrases_provider.dart';
import 'package:lullaby/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:lullaby/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:lullaby/data/services/storage_service.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class App extends StatefulWidget {
  final StorageService storageService;

  const App({
    super.key,
    required this.storageService,
  });

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    if (!kIsWeb && Platform.isMacOS) {
      DesktopWindow.getWindowSize().then((size) {
        DesktopWindow.setMinWindowSize(Size(size.height * 0.5, size.height));
      }).onError((error, stackTrace) {
        DesktopWindow.setMinWindowSize(const Size(600, 1000));
      });
    }
    super.initState();
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      for (BackgroundLayerType layerType in BackgroundLayers.types) {
        precacheImage(
          Image.asset('assets/images/background/${layerType.name}.png').image,
          context,
        );
      }

      for (int size in Puzzle.supportedPuzzleSizes) {
        precacheImage(
          Image.asset('assets/images/puzzle-solved/solved-${size}x$size.png')
              .image,
          context,
        );
      }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => PuzzleProvider(widget.storageService)..generate(),
        ),
        ChangeNotifierProvider(
          create: (_) => StopWatchProvider(widget.storageService)..init(),
        ),
        ChangeNotifierProvider(
          create: (_) => PhrasesProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => LocaleProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
      ],
      child: Consumer<LocaleProvider>(
        builder: (context, localeProvider, _) {
          final localeKey = localeProvider.locale?.languageCode ?? 'system';
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, _) {
              final lightTheme = ThemeData(
                useMaterial3: true,
                brightness: Brightness.light,
                fontFamily: AppTextStyles.secondaryFontFamily,
                colorScheme: const ColorScheme(
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
                ),
                scaffoldBackgroundColor: AppColors.background,
                appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.dark,
                    statusBarIconBrightness: Brightness.dark,
                    systemNavigationBarIconBrightness: Brightness.dark,
                    systemNavigationBarColor: Color(0xfff9f9f9),
                  ),
                ),
                textTheme: const TextTheme(
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
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColors.onPrimary,
                    textStyle: AppTextStyles.button,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: AppColors.primary,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return AppColors.stellarWhite.withValues(alpha: 0.12);
                      }
                      if (states.contains(WidgetState.pressed)) {
                        return AppColors.stellarWhite.withValues(alpha: 0.24);
                      }
                      return null;
                    }),
                  ),
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
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

              final darkTheme = ThemeData(
                useMaterial3: true,
                brightness: Brightness.dark,
                fontFamily: AppTextStyles.secondaryFontFamily,
                colorScheme: const ColorScheme(
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
                  surfaceContainerHighest:
                      AppColorsDark.surfaceContainerHighest,
                  primaryFixed: AppColorsDark.primaryFixed,
                  primaryFixedDim: AppColorsDark.primaryFixedDim,
                  onPrimaryFixed: AppColorsDark.onPrimaryFixed,
                  onPrimaryFixedVariant: AppColorsDark.onPrimaryFixedVariant,
                  secondaryFixed: AppColorsDark.secondaryFixed,
                  secondaryFixedDim: AppColorsDark.secondaryFixedDim,
                  onSecondaryFixed: AppColorsDark.onSecondaryFixed,
                  onSecondaryFixedVariant:
                      AppColorsDark.onSecondaryFixedVariant,
                  tertiaryFixed: AppColorsDark.tertiaryFixed,
                  tertiaryFixedDim: AppColorsDark.tertiaryFixedDim,
                  onTertiaryFixed: AppColorsDark.onTertiaryFixed,
                  onTertiaryFixedVariant: AppColorsDark.onTertiaryFixedVariant,
                ),
                scaffoldBackgroundColor: AppColorsDark.background,
                appBarTheme: const AppBarTheme(
                  systemOverlayStyle: SystemUiOverlayStyle(
                    statusBarBrightness: Brightness.light,
                    statusBarIconBrightness: Brightness.light,
                    systemNavigationBarIconBrightness: Brightness.light,
                    systemNavigationBarColor: Color(0xff131313),
                  ),
                ),
                textTheme: const TextTheme(
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
                  style: ElevatedButton.styleFrom(
                    foregroundColor: AppColorsDark.onPrimary,
                    textStyle: AppTextStyles.button,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                    ),
                    backgroundColor: AppColorsDark.primary,
                    elevation: 0,
                    shadowColor: Colors.transparent,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 22, vertical: 12),
                  ).copyWith(
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return AppColorsDark.deepSpace.withValues(alpha: 0.12);
                      }
                      if (states.contains(WidgetState.pressed)) {
                        return AppColorsDark.deepSpace.withValues(alpha: 0.24);
                      }
                      return null;
                    }),
                  ),
                ),
                dialogTheme: const DialogThemeData(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
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

              return ThemeTransitionBuilder(
                lightTheme: lightTheme,
                darkTheme: darkTheme,
                themeMode: themeProvider.mode,
                builder: (context, animatedTheme) {
                  return MaterialApp.router(
                    key: ValueKey(localeKey),
                    debugShowCheckedModeBanner: false,
                    title: 'Lullaby',
                    theme: animatedTheme,
                    themeMode: ThemeMode.light,
                    routerConfig: AppRouter.router,
                    locale: localeProvider.locale,
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
