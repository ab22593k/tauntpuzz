import 'package:checks/checks.dart';
import 'package:mocktail/mocktail.dart';
import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/puzzle.dart';
import 'package:leafy/data/services/storage_service.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_mixin_orchestrator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockStorageService extends Mock implements StorageService {}

// ---------------------------------------------------------------------------
// Test harness
// ---------------------------------------------------------------------------

class _OrchestratorHarness extends ChangeNotifier with PuzzleMixinOrchestrator {
  _OrchestratorHarness({
    GameMode initialMode = GameMode.classic,
    int initialSize = 3,
  }) : _gameMode = initialMode,
       _n = initialSize;

  // ── Storage ──

  @override
  final StorageService storageService = MockStorageService();

  // ── Game mode ──

  GameMode _gameMode;
  @override
  GameMode get gameMode => _gameMode;
  @override
  set gameMode(GameMode v) => _gameMode = v;

  // ── Puzzle state ──

  int _n;
  @override
  int get n => _n;
  @override
  set n(int v) => _n = v;

  @override
  int movesCount = 0;

  @override
  int stopWatchSecondsOverride = 0;

  // ── Delegate tracking ──

  bool generateCalled = false;
  bool generateForceRefresh = false;

  @override
  void generate({bool forceRefresh = false}) {
    generateCalled = true;
    generateForceRefresh = forceRefresh;
  }

  bool marathonStateReset = false;

  @override
  void resetMarathonState() {
    marathonStateReset = true;
  }

  bool blindStateReset = false;

  @override
  void resetBlindState() {
    blindStateReset = true;
  }

  bool marathonReadyCalled = false;

  @override
  void readyMarathonAdvance() {
    marathonReadyCalled = true;
  }

  bool marathonAdvanceCalled = false;

  @override
  void advanceMarathonSize() {
    marathonAdvanceCalled = true;
  }

  bool scoresUpdated = false;

  @override
  void updateScoresInStorage() {
    scoresUpdated = true;
  }

  /// Clears tracking flags before each test.
  void resetTracking() {
    generateCalled = false;
    generateForceRefresh = false;
    marathonStateReset = false;
    blindStateReset = false;
    marathonReadyCalled = false;
    marathonAdvanceCalled = false;
    scoresUpdated = false;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('PuzzleMixinOrchestrator', () {
    late _OrchestratorHarness harness;

    setUp(() {
      harness = _OrchestratorHarness();
      when(
        () => harness.storageService.set(any(), any()),
      ).thenAnswer((_) => Future<void>.value());
      when(
        () => harness.storageService.remove(any()),
      ).thenAnswer((_) => Future<void>.value());
    });

    tearDown(() {
      harness.resetTracking();
    });

    // ────────────────────────────────────────────
    // setGameMode
    // ────────────────────────────────────────────

    group('setGameMode', () {
      test('switches gameMode', () {
        check(harness.gameMode).equals(GameMode.classic);
        harness.setGameMode(GameMode.speedrun);
        check(harness.gameMode).equals(GameMode.speedrun);
      });

      test('persists mode to storage', () {
        harness.setGameMode(GameMode.speedrun);
        verify(
          () => harness.storageService.set(StorageKey.gameMode, 'speedrun'),
        );
      });

      test('does nothing when switching to the same mode', () {
        harness.gameMode = GameMode.classic;
        harness.setGameMode(GameMode.classic);
        // None of these should be called
        verifyNever(() => harness.storageService.set(any(), any()));
        verifyNever(() => harness.storageService.remove(any()));
        check(harness.marathonStateReset).isFalse();
        check(harness.blindStateReset).isFalse();
        check(harness.generateCalled).isFalse();
      });

      test('resets marathon state', () {
        harness.setGameMode(GameMode.speedrun);
        check(harness.marathonStateReset).isTrue();
      });

      test('resets blind state', () {
        harness.setGameMode(GameMode.speedrun);
        check(harness.blindStateReset).isTrue();
      });

      test('resets movesCount to 0', () {
        harness.movesCount = 99;
        harness.setGameMode(GameMode.speedrun);
        check(harness.movesCount).equals(0);
      });

      test('resets stopWatchSecondsOverride to 0', () {
        harness.stopWatchSecondsOverride = 99;
        harness.setGameMode(GameMode.speedrun);
        check(harness.stopWatchSecondsOverride).equals(0);
      });

      test('removes puzzle from storage', () {
        harness.setGameMode(GameMode.speedrun);
        verify(() => harness.storageService.remove(StorageKey.puzzle));
      });

      test('calls generate with forceRefresh', () {
        harness.setGameMode(GameMode.speedrun);
        check(harness.generateCalled).isTrue();
        check(harness.generateForceRefresh).isTrue();
      });

      test('notifies listeners', () {
        int notifyCount = 0;
        harness.addListener(() => notifyCount++);

        harness.setGameMode(GameMode.speedrun);
        check(notifyCount).isGreaterThan(0);
      });

      test('can switch to all game modes', () {
        for (final mode in GameMode.values) {
          final h = _OrchestratorHarness(initialMode: mode);
          when(
            () => h.storageService.set(any(), any()),
          ).thenAnswer((_) => Future<void>.value());
          when(
            () => h.storageService.remove(any()),
          ).thenAnswer((_) => Future<void>.value());

          // Switch to a different mode
          final other = mode == GameMode.classic
              ? GameMode.speedrun
              : GameMode.classic;
          h.setGameMode(other);
          check(h.gameMode).equals(other);
        }
      });
    });

    // ────────────────────────────────────────────
    // resetPuzzleSize
    // ────────────────────────────────────────────

    group('resetPuzzleSize', () {
      test('sets n to the given size', () {
        check(harness.n).equals(3);
        harness.resetPuzzleSize(5);
        check(harness.n).equals(5);
      });

      test('resets movesCount to 0', () {
        harness.movesCount = 42;
        harness.resetPuzzleSize(4);
        check(harness.movesCount).equals(0);
      });

      test('resets stopWatchSecondsOverride to 0', () {
        harness.stopWatchSecondsOverride = 99;
        harness.resetPuzzleSize(4);
        check(harness.stopWatchSecondsOverride).equals(0);
      });

      test('removes puzzle from storage', () {
        harness.resetPuzzleSize(4);
        verify(() => harness.storageService.remove(StorageKey.puzzle));
      });

      test('calls generate with forceRefresh', () {
        harness.resetPuzzleSize(4);
        check(harness.generateCalled).isTrue();
        check(harness.generateForceRefresh).isTrue();
      });

      test('works for all supported sizes', () {
        for (final size in Puzzle.supportedPuzzleSizes) {
          final h = _OrchestratorHarness();
          when(
            () => h.storageService.set(any(), any()),
          ).thenAnswer((_) => Future<void>.value());
          when(
            () => h.storageService.remove(any()),
          ).thenAnswer((_) => Future<void>.value());
          h.resetPuzzleSize(size);
          check(h.n).equals(size);
        }
      });
    });
  });
}
