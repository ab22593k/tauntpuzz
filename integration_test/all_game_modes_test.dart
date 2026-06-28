import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:checks/checks.dart';
import 'package:flutter_checks/flutter_checks.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';

import 'package:jigsaw/data/services/storage_service.dart';
import 'package:jigsaw/domain/models/game_mode.dart';
import 'package:jigsaw/generated/app_localizations.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:jigsaw/ui/features/phrases/view_models/phrases_provider.dart';
import 'package:jigsaw/ui/core/locale_provider.dart';
import 'package:jigsaw/ui/core/theme_provider.dart';
import 'package:jigsaw/ui/core/app_theme.dart';
import 'package:jigsaw/ui/features/puzzle/ui/puzzle_view.dart';
import 'package:jigsaw/ui/features/drawer/app_drawer.dart';

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
        theme: AppTheme.light(),
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
      check(find.byKey(const ValueKey('puzzle_board'))).findsOne();

      // Tiles 1-15 rendered (default 4x4 = 15 non-whitespace tiles)
      for (int i = 1; i <= 15; i++) {
        check(find.byKey(ValueKey('tile_$i'))).findsOne();
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
      check(movesCount(tester) > initialMoves).isTrue();
    });

    testWidgets('Speedrun mode switches via drawer and renders',
        (tester) async {
      await pumpApp(tester, storageService);

      await switchMode(tester, GameMode.speedrun);

      // moves should reset on mode switch
      check(movesCount(tester)).equals(0);
    });

    testWidgets('Blind mode switches via drawer and renders', (tester) async {
      await pumpApp(tester, storageService);

      await switchMode(tester, GameMode.blind);

      // moves should reset on mode switch
      check(movesCount(tester)).equals(0);
    });

    testWidgets('Marathon mode switches via drawer and renders',
        (tester) async {
      await pumpApp(tester, storageService);

      await switchMode(tester, GameMode.marathon);

      // moves should reset on mode switch
      check(movesCount(tester)).equals(0);
    });

    testWidgets('Can cycle through all game modes sequentially',
        (tester) async {
      await pumpApp(tester, storageService);

      for (final mode in GameMode.values) {
        await switchMode(tester, mode);
        // moves should reset to 0 after switching to ${mode.name}
        check(movesCount(tester)).equals(0);
      }
    });

    testWidgets('Can change puzzle size via drawer', (tester) async {
      await pumpApp(tester, storageService);

      await switchSize(tester, 3);

      // moves reset after size change
      check(movesCount(tester)).equals(0);
    });

    testWidgets('Puzzle shows correct tile count for chosen size',
        (tester) async {
      await pumpApp(tester, storageService);

      // Default is 4x4 = 16 - 1 whitespace = 15 tiles
      for (int i = 1; i <= 15; i++) {
        // tile $i should exist in 4x4 puzzle
        check(find.byKey(ValueKey('tile_$i'))).findsOne();
      }

      // Switch to 3x3
      await switchSize(tester, 3);

      // Now 3x3 = 9 - 1 = 8 tiles
      for (int i = 1; i <= 8; i++) {
        // tile $i should exist in 3x3 puzzle
        check(find.byKey(ValueKey('tile_$i'))).findsOne();
      }
      // Tile 9 should NOT exist (whitespace)
      // tile 9 is the whitespace tile
      check(find.byKey(const ValueKey('tile_9'))).findsNothing();
    });
  });
}
