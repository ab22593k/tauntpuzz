import 'dart:math' show Random;

import 'package:checks/checks.dart';
import 'package:mocktail/mocktail.dart';
import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/domain/models/location.dart';
import 'package:tauntpuzz/domain/models/puzzle.dart';
import 'package:tauntpuzz/domain/models/score.dart';
import 'package:tauntpuzz/domain/models/tile.dart';
import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_mixin_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockStorageService extends Mock implements StorageService {}

// ---------------------------------------------------------------------------
// Test harness
// ---------------------------------------------------------------------------

class _CoreHarness extends ChangeNotifier with PuzzleMixinCore {
  _CoreHarness({
    GameMode gameMode = GameMode.classic,
  }) : _gameMode = gameMode {
    when(() => storageService.has(any())).thenReturn(false);
    when(() => storageService.get(any())).thenReturn(null);
    when(() => storageService.set(any(), any()))
        .thenAnswer((_) => Future<void>.value());
    when(() => storageService.remove(any()))
        .thenAnswer((_) => Future<void>.value());
  }

  @override
  late List<Tile> tiles;

  @override
  final StorageService storageService = MockStorageService();

  @override
  List<Score> scores = <Score>[];

  @override
  int n = 3;

  @override
  int movesCount = 0;

  @override
  final Random random = Random();

  final GameMode _gameMode;
  @override
  GameMode get gameMode => _gameMode;

  @override
  Puzzle get puzzle => Puzzle(n: n, tiles: tiles, movesCount: movesCount);

  // --- Delegate tracking ---

  bool blindStateReset = false;
  bool blindTimerStarted = false;

  @override
  void resetBlindState() {
    blindStateReset = true;
  }

  @override
  void startBlindTimer() {
    blindTimerStarted = true;
  }

  bool marathonReadyCalled = false;
  bool marathonAdvanceCalled = false;

  @override
  void readyMarathonAdvance() {
    marathonReadyCalled = true;
  }

  @override
  void advanceMarathonSize() {
    marathonAdvanceCalled = true;
  }

  bool scoresUpdated = false;

  @override
  void updateScoresInStorage() {
    scoresUpdated = true;
  }

  Puzzle? puzzleFromStorageResult;

  @override
  Puzzle? getPuzzleFromStorage() => puzzleFromStorageResult;

  bool puzzleInStorageUpdated = false;

  @override
  void updatePuzzleInStorage() {
    puzzleInStorageUpdated = true;
  }

  List<Score> scoresFromStorageResult = <Score>[];

  @override
  List<Score> getScoresFromStorage() => scoresFromStorageResult;

  // --- Test helpers ---

  /// Generates correct location list for the current [n].
  List<Location> _correct() => Puzzle.generateTileCorrectLocations(n);

  /// Populates [tiles] with the given current locations.
  void _setTiles(List<Location> current) {
    tiles = Puzzle.getTilesFromLocations(
      correctLocations: _correct(),
      currentLocations: current,
    );
  }

  /// Sets up an almost-solved board where only tile 8 and whitespace are
  /// swapped with each other. One swap solves it.
  void setupAlmostSolvedBoard() {
    final c = _correct(); // (1,1) … (3,3), index 8 = whitespace
    final cur = List<Location>.from(c);
    // Swap index 7 (3,2) with index 8 (3,3)
    final saved = cur[7];
    cur[7] = cur[8];
    cur[8] = saved;
    _setTiles(cur);
  }

  /// Sets up a shuffled board that is still solvable.  Whitespace stays
  /// at (3,3) and tile 8 stays at (3,2).
  void setupShuffledBoard() {
    final c = _correct();
    final cur = List<Location>.from(c);
    // Scramble first 7 tiles (keep whitespace at (3,3), tile 8 at (3,2))
    final toShuffle = cur.sublist(0, 7)..shuffle(Random(42));
    for (int i = 0; i < 7; i++) {
      cur[i] = toShuffle[i];
    }
    _setTiles(cur);
  }

  /// Clears tracking flags before each test.
  void resetTracking() {
    blindStateReset = false;
    blindTimerStarted = false;
    marathonReadyCalled = false;
    marathonAdvanceCalled = false;
    scoresUpdated = false;
    puzzleInStorageUpdated = false;
    puzzleFromStorageResult = null;
    scoresFromStorageResult = <Score>[];
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('PuzzleMixinCore', () {
    late _CoreHarness harness;

    setUp(() {
      harness = _CoreHarness();
    });

    tearDown(() {
      harness.resetTracking();
    });

    // ────────────────────────────────────────────
    // generate
    // ────────────────────────────────────────────

    group('generate', () {
      test('creates a solvable board with tiles', () {
        harness.generate();
        check(harness.tiles.length).equals(9);
        check(harness.puzzle.isSolvable()).isTrue();
      });

      test('sets movesCount to 0', () {
        harness.movesCount = 42;
        harness.generate();
        check(harness.movesCount).equals(0);
      });

      test('restores from storage when puzzle exists', () {
        // Create a known board and store it
        final c = Puzzle.generateTileCorrectLocations(3);
        final storedPuzzle = Puzzle(
          n: 3,
          tiles: Puzzle.getTilesFromLocations(
            correctLocations: c,
            currentLocations: List<Location>.from(c),
          ),
          movesCount: 7,
        );
        harness.puzzleFromStorageResult = storedPuzzle;

        when(() => harness.storageService.has(StorageKey.puzzle))
            .thenReturn(true);

        harness.generate();
        check(harness.n).equals(3);
        check(harness.movesCount).equals(7);
      });

      test('does NOT restore from storage when forceRefresh is true', () {
        final c = Puzzle.generateTileCorrectLocations(3);
        final storedPuzzle = Puzzle(
          n: 3,
          tiles: Puzzle.getTilesFromLocations(
            correctLocations: c,
            currentLocations: List<Location>.from(c),
          ),
          movesCount: 7,
        );
        harness.puzzleFromStorageResult = storedPuzzle;

        when(() => harness.storageService.has(StorageKey.puzzle))
            .thenReturn(true);

        harness.generate(forceRefresh: true);
        // movesCount should be 0 (fresh board), not 7
        check(harness.movesCount).equals(0);
      });

      test('resets blind state', () {
        harness.generate();
        check(harness.blindStateReset).isTrue();
      });

      test('starts blind timer in blind mode', () {
        harness = _CoreHarness(gameMode: GameMode.blind);
        harness.generate();
        check(harness.blindTimerStarted).isTrue();
      });

      test('does NOT start blind timer in classic mode', () {
        harness.generate();
        check(harness.blindTimerStarted).isFalse();
      });

      test('does NOT start blind timer in marathon mode', () {
        harness = _CoreHarness(gameMode: GameMode.marathon);
        harness.generate();
        check(harness.blindTimerStarted).isFalse();
      });

      test('notifies listeners', () {
        int notifyCount = 0;
        harness.addListener(() => notifyCount++);
        harness.generate();
        check(notifyCount).isGreaterThan(0);
      });

      test('loads scores from storage when scores key exists', () {
        const storedScore = Score(
          movesCount: 5,
          puzzleSize: 3,
          secondsElapsed: 30,
          gameMode: GameMode.classic,
        );
        harness.scoresFromStorageResult = [storedScore];

        when(() => harness.storageService.has(StorageKey.scores))
            .thenReturn(true);

        harness.generate();
        check(harness.scores.length).equals(1);
        check(harness.scores.first.movesCount).equals(5);
      });
    });

    // ────────────────────────────────────────────
    // swapTilesAndUpdatePuzzle
    // ────────────────────────────────────────────

    group('swapTilesAndUpdatePuzzle', () {
      test('swaps tile and whitespace locations', () {
        harness.setupAlmostSolvedBoard();

        final tile8 = harness.tiles[7]; // value 8, currently at (3,3)
        final ws = harness.tiles[8]; // whitespace, currently at (3,2)
        final locA = tile8.currentLocation;
        final locB = ws.currentLocation;

        harness.swapTilesAndUpdatePuzzle(tile8);

        check(harness.tiles[7].currentLocation).equals(locB);
        check(harness.tiles[8].currentLocation).equals(locA);
      });

      test('increments movesCount', () {
        harness.setupShuffledBoard();
        // Find a non-whitespace tile adjacent to whitespace
        final tile =
            harness.tiles[7]; // value 8 at (3,2), adjacent to ws at (3,3)
        harness.movesCount = 0;

        harness.swapTilesAndUpdatePuzzle(tile);

        check(harness.movesCount).equals(1);
      });

      test('calls updatePuzzleInStorage', () {
        harness.setupShuffledBoard();
        final tile = harness.tiles[7];

        harness.swapTilesAndUpdatePuzzle(tile);

        check(harness.puzzleInStorageUpdated).isTrue();
      });

      test('notifies listeners', () {
        harness.setupShuffledBoard();
        final tile = harness.tiles[7];

        int notifyCount = 0;
        harness.addListener(() => notifyCount++);

        harness.swapTilesAndUpdatePuzzle(tile);

        check(notifyCount).isGreaterThan(0);
      });

      test('calls handlePuzzleSolved when puzzle becomes solved', () {
        harness.setupAlmostSolvedBoard();
        final tile8 = harness.tiles[7]; // value 8, swapping with ws solves it

        harness.swapTilesAndUpdatePuzzle(tile8);

        check(harness.scoresUpdated).isTrue();
        // Classic mode → only updateScoresInStorage, no marathon methods
        check(harness.marathonReadyCalled).isFalse();
      });

      test('does NOT call handlePuzzleSolved when puzzle is not solved', () {
        harness.setupShuffledBoard();
        final tile = harness.tiles[7];

        harness.swapTilesAndUpdatePuzzle(tile);

        check(harness.scoresUpdated).isFalse();
      });
    });

    // ────────────────────────────────────────────
    // handlePuzzleSolved
    // ────────────────────────────────────────────

    group('handlePuzzleSolved', () {
      test('calls updateScoresInStorage in classic mode', () {
        harness.handlePuzzleSolved();
        check(harness.scoresUpdated).isTrue();
      });

      test('calls updateScoresInStorage in speedrun mode', () {
        harness = _CoreHarness(gameMode: GameMode.speedrun);
        harness.handlePuzzleSolved();
        check(harness.scoresUpdated).isTrue();
      });

      test('calls updateScoresInStorage in blind mode', () {
        harness = _CoreHarness(gameMode: GameMode.blind);
        harness.handlePuzzleSolved();
        check(harness.scoresUpdated).isTrue();
      });

      test(
          'calls readyMarathonAdvance + updateScoresInStorage + advanceMarathonSize '
          'in marathon mode', () {
        harness = _CoreHarness(gameMode: GameMode.marathon);
        harness.handlePuzzleSolved();

        check(harness.marathonReadyCalled).isTrue();
        check(harness.scoresUpdated).isTrue();
        check(harness.marathonAdvanceCalled).isTrue();
      });
    });
  });
}
