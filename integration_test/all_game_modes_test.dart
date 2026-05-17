import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/generated/app_localizations.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:tauntpuzz/ui/features/phrases/view_models/phrases_provider.dart';
import 'package:tauntpuzz/ui/core/locale_provider.dart';
import 'package:tauntpuzz/ui/core/theme_provider.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/puzzle_view.dart';
import 'package:tauntpuzz/ui/features/drawer/app_drawer.dart';

/// In-memory storage service for integration tests.
class _InMemoryStorage implements StorageService {
  final _store = <String, dynamic>{};

  @override
  Future<void> init() async {}

  @override
  dynamic get(String key) => _store[key];

  @override
  bool has(String key) => _store.containsKey(key);

  @override
  Future<void> set(String? key, dynamic data) async {
    if (key != null) _store[key] = data;
  }

  @override
  Future<void> remove(String key) async {
    _store.remove(key);
  }

  @override
  Future<void> clear() async {
    _store.clear();
  }
}

/// Wraps the real [PuzzleView] and [AppDrawer] with the same providers and
/// localization configuration used by the production app.
class _EndToEndApp extends StatefulWidget {
  final StorageService storageService;

  const _EndToEndApp({required this.storageService});

  @override
  State<_EndToEndApp> createState() => _EndToEndAppState();
}

class _EndToEndAppState extends State<_EndToEndApp> {
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
      child: MaterialApp(
        key: const ValueKey('test_app'),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData(
          useMaterial3: true,
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
        ),
        home: const Scaffold(
          drawer: AppDrawer(),
          body: PuzzleView(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

/// Pumps the app and waits for the initial render. Uses `pump()` instead of
/// `pumpAndSettle()` to avoid hanging on the continuously animating background
/// layers (stars + parallax layers).
Future<void> pumpApp(
    WidgetTester tester, _InMemoryStorage storageService) async {
  await tester.pumpWidget(_EndToEndApp(storageService: storageService));
  // Allow the 400ms delayed animation start + 600ms bg layer animation
  await tester.pump(const Duration(seconds: 2));
}

/// Opens the drawer by tapping the DrawerButton.
Future<void> openDrawer(WidgetTester tester) async {
  await tester.tap(find.byKey(const ValueKey('drawer_button')));
  // Wait for drawer slide animation
  await tester.pump(const Duration(seconds: 1));
}

/// Switches to the given [mode] via the real AppDrawer.
Future<void> switchMode(WidgetTester tester, GameMode mode) async {
  await openDrawer(tester);
  await tester.tap(find.byKey(ValueKey('game_mode_${mode.name}')));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

/// Switches to the given puzzle [size] via the real AppDrawer.
Future<void> switchSize(WidgetTester tester, int size) async {
  await openDrawer(tester);
  await tester.tap(find.byKey(ValueKey('puzzle_size_$size')));
  await tester.pump();
  await tester.pump(const Duration(seconds: 1));
}

/// Returns the current moves count from the PuzzleProvider.
int movesCount(WidgetTester tester) {
  final context = tester.element(find.byType(PuzzleView));
  final provider = Provider.of<PuzzleProvider>(context, listen: false);
  return provider.movesCount;
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  late _InMemoryStorage storageService;

  setUp(() {
    storageService = _InMemoryStorage();
  });

  group('All Game Modes End-to-End', () {
    testWidgets('Classic mode renders tiles and responds to taps',
        (tester) async {
      await pumpApp(tester, storageService);

      // Verify the puzzle board is rendered
      expect(find.byKey(const ValueKey('puzzle_board')), findsOneWidget);

      // Tiles 1-15 rendered (default 4x4 = 15 non-whitespace tiles)
      for (int i = 1; i <= 15; i++) {
        expect(find.byKey(ValueKey('tile_$i')), findsOneWidget);
      }

      // Record initial moves
      final initialMoves = movesCount(tester);

      // Try tapping tiles. Some should be movable from the start.
      for (final tileValue in [
        15,
        14,
        13,
        12,
        11,
        10,
        9,
        8,
        7,
        6,
        5,
        4,
        3,
        2,
        1
      ]) {
        final tileKey = ValueKey('tile_$tileValue');
        if (find.byKey(tileKey).evaluate().isNotEmpty) {
          await tester.tap(find.byKey(tileKey));
          await tester.pump(const Duration(milliseconds: 100));
        }
      }

      // At least one tile tap should have succeeded
      expect(movesCount(tester), greaterThan(initialMoves));
    });

    testWidgets('Speedrun mode switches via drawer and renders',
        (tester) async {
      await pumpApp(tester, storageService);

      await switchMode(tester, GameMode.speedrun);

      expect(movesCount(tester), 0,
          reason: 'moves should reset on mode switch');
    });

    testWidgets('Blind mode switches via drawer and renders', (tester) async {
      await pumpApp(tester, storageService);

      await switchMode(tester, GameMode.blind);

      expect(movesCount(tester), 0,
          reason: 'moves should reset on mode switch');
    });

    testWidgets('Marathon mode switches via drawer and renders',
        (tester) async {
      await pumpApp(tester, storageService);

      await switchMode(tester, GameMode.marathon);

      expect(movesCount(tester), 0,
          reason: 'moves should reset on mode switch');
    });

    testWidgets('Can cycle through all game modes sequentially',
        (tester) async {
      await pumpApp(tester, storageService);

      for (final mode in GameMode.values) {
        await switchMode(tester, mode);
        expect(movesCount(tester), 0,
            reason: 'moves should reset to 0 after switching to ${mode.name}');
      }
    });

    testWidgets('Can change puzzle size via drawer', (tester) async {
      await pumpApp(tester, storageService);

      await switchSize(tester, 3);

      expect(movesCount(tester), 0, reason: 'moves reset after size change');
    });

    testWidgets('Puzzle shows correct tile count for chosen size',
        (tester) async {
      await pumpApp(tester, storageService);

      // Default is 4x4 = 16 - 1 whitespace = 15 tiles
      for (int i = 1; i <= 15; i++) {
        expect(find.byKey(ValueKey('tile_$i')), findsOneWidget,
            reason: 'tile $i should exist in 4x4 puzzle');
      }

      // Switch to 3x3
      await switchSize(tester, 3);

      // Now 3x3 = 9 - 1 = 8 tiles
      for (int i = 1; i <= 8; i++) {
        expect(find.byKey(ValueKey('tile_$i')), findsOneWidget,
            reason: 'tile $i should exist in 3x3 puzzle');
      }
      // Tile 9 should NOT exist (whitespace)
      expect(find.byKey(const ValueKey('tile_9')), findsNothing,
          reason: 'tile 9 is the whitespace tile');
    });
  });
}
