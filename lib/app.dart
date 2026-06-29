import 'dart:io';

import 'package:jigsaw/generated/app_localizations.dart';
import 'package:jigsaw/router/router_config.dart';
import 'package:jigsaw/ui/core/app_theme.dart';
import 'package:jigsaw/ui/core/theme_provider.dart';
import 'package:jigsaw/ui/core/theme_transition.dart';
import 'package:jigsaw/domain/models/puzzle.dart';
import 'package:jigsaw/ui/features/background/background_layers.dart';
import 'package:jigsaw/ui/core/layout/background_layer_layout.dart';
import 'package:jigsaw/ui/core/locale_provider.dart';
import 'package:jigsaw/ui/features/phrases/view_models/phrases_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:jigsaw/data/services/storage_service.dart';
import 'package:desktop_window/desktop_window.dart';
import 'package:dynamic_color/dynamic_color.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
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
      child: SafeArea(
        child: Consumer<LocaleProvider>(
          builder: (context, localeProvider, _) {
            final localeKey = localeProvider.locale?.languageCode ?? 'system';
            return Consumer<ThemeProvider>(
              builder: (context, themeProvider, _) {
                return DynamicColorBuilder(
                  builder: (dynamicLight, dynamicDark) {
                    final lightTheme =
                        AppTheme.light(dynamicLight: dynamicLight);
                    final darkTheme = AppTheme.dark(dynamicDark: dynamicDark);

                    return ThemeTransitionBuilder(
                      lightTheme: lightTheme,
                      darkTheme: darkTheme,
                      themeMode: themeProvider.mode,
                      builder: (context, animatedTheme) {
                        return MaterialApp.router(
                          key: ValueKey(localeKey),
                          debugShowCheckedModeBanner: false,
                          title: 'Jigsaw',
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
            );
          },
        ),
      ),
    );
  }
}
