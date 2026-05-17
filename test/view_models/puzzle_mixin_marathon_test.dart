import 'package:mocktail/mocktail.dart';
import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_mixin_marathon.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

// ---------------------------------------------------------------------------
// Mocks
// ---------------------------------------------------------------------------

class MockStorageService extends Mock implements StorageService {}

// ---------------------------------------------------------------------------
// Test harness
// ---------------------------------------------------------------------------

class _MarathonHarness extends ChangeNotifier with PuzzleMixinMarathon {
  _MarathonHarness({
    int n = 3,
    GameMode gameMode = GameMode.marathon,
  })  : _n = n,
        _gameMode = gameMode;

  int _n;
  @override
  int get n => _n;
  @override
  set n(int v) => _n = v;

  @override
  int movesCount = 0;

  @override
  final StorageService storageService = MockStorageService();

  @override
  int stopWatchSecondsOverride = 0;

  final GameMode _gameMode;
  @override
  GameMode get gameMode => _gameMode;

  bool generateCalled = false;
  @override
  void generate({bool forceRefresh = false}) {
    generateCalled = true;
  }
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('PuzzleMixinMarathon', () {
    late _MarathonHarness harness;

    setUp(() {
      harness = _MarathonHarness(n: 3, gameMode: GameMode.marathon);
      // Default stubs for Future<void> methods
      when(() => harness.storageService.set(any(), any()))
          .thenAnswer((_) => Future<void>.value());
      when(() => harness.storageService.remove(any()))
          .thenAnswer((_) => Future<void>.value());
    });

    group('initial state', () {
      test('marathonStartSize is null', () {
        expect(harness.marathonStartSize, isNull);
      });

      test('marathonEndSize is null', () {
        expect(harness.marathonEndSize, isNull);
      });

      test('marathonRetried is false', () {
        expect(harness.marathonRetried, isFalse);
      });

      test('isMarathonComplete is false when no end size set', () {
        expect(harness.isMarathonComplete, isFalse);
      });

      test(
          'isMarathonComplete is false when not in marathon mode even with range',
          () {
        harness = _MarathonHarness(
          n: 3,
          gameMode: GameMode.classic,
        );
        when(() => harness.storageService.set(any(), any()))
            .thenAnswer((_) => Future<void>.value());
        when(() => harness.storageService.remove(any()))
            .thenAnswer((_) => Future<void>.value());
        harness.setMarathonRange(3, 6);
        expect(harness.isMarathonComplete, isFalse);
      });
    });

    group('setMarathonRange', () {
      test('sets start and end sizes', () {
        harness.setMarathonRange(3, 6);
        expect(harness.marathonStartSize, equals(3));
        expect(harness.marathonEndSize, equals(6));
      });

      test('persists to storage', () {
        harness.setMarathonRange(3, 6);
        verify(
            () => harness.storageService.set(StorageKey.marathonStartSize, 3));
        verify(() => harness.storageService.set(StorageKey.marathonEndSize, 6));
      });
    });

    group('isMarathonComplete', () {
      test('returns false when n is below end size', () {
        harness.setMarathonRange(3, 6);
        harness.n = 4;
        expect(harness.isMarathonComplete, isFalse);
      });

      test('returns true when n equals end size', () {
        harness.setMarathonRange(3, 6);
        harness.n = 6;
        expect(harness.isMarathonComplete, isTrue);
      });

      test('returns true when n exceeds end size', () {
        harness.setMarathonRange(3, 4);
        harness.n = 5;
        expect(harness.isMarathonComplete, isTrue);
      });
    });

    group('resetMarathonState', () {
      test('clears start and end sizes', () {
        harness.setMarathonRange(3, 6);
        harness.resetMarathonState();
        expect(harness.marathonStartSize, isNull);
        expect(harness.marathonEndSize, isNull);
      });

      test('clears retried flag', () {
        harness.setMarathonRange(3, 6);
        harness.readyMarathonAdvance();
        harness.resetMarathonState();
        expect(harness.marathonRetried, isFalse);
      });

      test('removes storage keys when not in marathon mode', () {
        harness = _MarathonHarness(gameMode: GameMode.classic);
        when(() => harness.storageService.set(any(), any()))
            .thenAnswer((_) => Future<void>.value());
        when(() => harness.storageService.remove(any()))
            .thenAnswer((_) => Future<void>.value());
        harness.setMarathonRange(3, 6);
        harness.resetMarathonState();
        verify(
            () => harness.storageService.remove(StorageKey.marathonStartSize));
        verify(() => harness.storageService.remove(StorageKey.marathonEndSize));
      });

      test('does NOT remove storage keys when in marathon mode', () {
        harness.setMarathonRange(3, 6);
        harness.resetMarathonState();
        verifyNever(
            () => harness.storageService.remove(StorageKey.marathonStartSize));
        verifyNever(
            () => harness.storageService.remove(StorageKey.marathonEndSize));
      });
    });

    group('marathonRetried', () {
      test('stays false after readyMarathonAdvance', () {
        harness.setMarathonRange(3, 6);
        harness.readyMarathonAdvance();
        expect(harness.marathonRetried, isFalse);
      });
    });

    group('readyMarathonAdvance', () {
      test('flags the puzzle as solved', () {
        harness.setMarathonRange(3, 6);
        harness.readyMarathonAdvance();
        // advanceMarathonSize should proceed because _onPuzzleSolved = true
        harness.advanceMarathonSize();
        expect(harness.n, greaterThan(3));
      });

      test('advanceMarathonSize does nothing without readyMarathonAdvance', () {
        harness.setMarathonRange(3, 6);
        harness.advanceMarathonSize(); // no readyMarathonAdvance called
        expect(harness.n, equals(3));
      });
    });

    group('advanceMarathonSize', () {
      test('advances to next supported size', () {
        harness.setMarathonRange(3, 6);
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.n, equals(4));
      });

      test('calls generate for the new board', () {
        harness.setMarathonRange(3, 6);
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.generateCalled, isTrue);
      });

      test('resets movesCount to 0', () {
        harness.setMarathonRange(3, 6);
        harness.movesCount = 42;
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.movesCount, equals(0));
      });

      test('resets stopWatchSecondsOverride to 0', () {
        harness.setMarathonRange(3, 6);
        harness.stopWatchSecondsOverride = 99;
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.stopWatchSecondsOverride, equals(0));
      });

      test('removes puzzle from storage', () {
        harness.setMarathonRange(3, 6);
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        verify(() => harness.storageService.remove(StorageKey.puzzle));
      });

      test('stops advancing when reaching end size', () {
        harness.setMarathonRange(4, 4);
        harness.n = 4;
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        // Should stay at 4 since end size is 4
        expect(harness.n, equals(4));
      });

      test('does not advance beyond the last supported size', () {
        // Set n to 6 (last supported), end size above it
        harness.n = 6;
        harness.setMarathonRange(3, 10); // 10 > supported max
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        // Should not advance beyond 6
        expect(harness.n, equals(6));
      });

      test('advances across multiple sizes', () {
        harness.setMarathonRange(3, 6);

        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.n, equals(4));

        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.n, equals(5));

        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.n, equals(6));

        // Should not advance past 6
        harness.readyMarathonAdvance();
        harness.advanceMarathonSize();
        expect(harness.n, equals(6));
      });
    });
  });
}
