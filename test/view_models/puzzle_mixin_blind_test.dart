import 'package:fake_async/fake_async.dart';
import 'package:tauntpuzz/domain/models/location.dart';
import 'package:tauntpuzz/helpers/game_mode_helper.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_mixin_blind.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal harness to test PuzzleMixinBlind in isolation.
class _BlindHarness extends ChangeNotifier with PuzzleMixinBlind {
  _BlindHarness(this.n);

  @override
  int n;
}

void main() {
  group('PuzzleMixinBlind', () {
    late _BlindHarness harness;

    setUp(() {
      harness = _BlindHarness(4);
    });

    group('initial state', () {
      test('tilesBlinded is false', () {
        expect(harness.tilesBlinded, isFalse);
      });

      test('blindRevealedTiles is empty', () {
        expect(harness.blindRevealedTiles, isEmpty);
      });

      test('isTileRevealed returns false for any location', () {
        const loc = Location(x: 1, y: 1);
        expect(harness.isTileRevealed(loc), isFalse);
      });
    });

    group('resetBlindState', () {
      test('resets tilesBlinded to false', () {
        // Force the blinded flag
        harness.startBlindTimer();
        // No need to wait — resetBlindState should clear it immediately
        harness.resetBlindState();
        expect(harness.tilesBlinded, isFalse);
      });

      test('clears revealed tiles', () {
        // Manually trigger reveal by setting up and calling reset
        harness.startBlindTimer();
        harness.resetBlindState();
        expect(harness.blindRevealedTiles, isEmpty);
        expect(harness.tilesBlinded, isFalse);
      });

      test('can be called multiple times without error', () {
        harness.resetBlindState();
        harness.resetBlindState();
        harness.resetBlindState();
        expect(harness.tilesBlinded, isFalse);
      });
    });

    group('revealBlindTile', () {
      test('does nothing when tiles are not blinded', () {
        const loc = Location(x: 2, y: 2);
        harness.revealBlindTile(loc);
        expect(harness.isTileRevealed(loc), isFalse);
        expect(harness.blindRevealedTiles, isEmpty);
      });

      test('reveals tile after tileBlinded is true', () {
        const loc = Location(x: 1, y: 1);

        // Simulate blinded state
        fakeAsync((async) {
          harness.startBlindTimer();
          // The timer uses a real duration, but for this test we just need
          // to trigger the reveal path. We can inspect internally via
          // isTileRevealed after manually making tilesBlinded true via startBlindTimer + elapse.
          async.elapse(
              Duration(seconds: GameModeHelper.blindHideDelaySeconds(4)));
        });

        // After fakeAsync, tiles should be blinded
        expect(harness.tilesBlinded, isTrue);

        harness.revealBlindTile(loc);
        expect(harness.isTileRevealed(loc), isTrue);
      });

      test('auto-hides revealed tile after 1.5 seconds', () {
        const loc = Location(x: 1, y: 1);

        // First, become blinded
        fakeAsync((async) {
          harness.startBlindTimer();
          async.elapse(
              Duration(seconds: GameModeHelper.blindHideDelaySeconds(4)));
        });

        expect(harness.tilesBlinded, isTrue);

        // Now reveal and test auto-hide
        fakeAsync((async) {
          harness.revealBlindTile(loc);
          expect(harness.isTileRevealed(loc), isTrue);

          async.elapse(const Duration(milliseconds: 1500));
          expect(harness.isTileRevealed(loc), isFalse);
        });
      });
    });

    group('startBlindTimer', () {
      test('hides tiles after the configured delay', () {
        harness = _BlindHarness(3); // 15 second delay

        fakeAsync((async) {
          harness.startBlindTimer();
          expect(harness.tilesBlinded, isFalse);

          async.elapse(const Duration(seconds: 14));
          expect(harness.tilesBlinded, isFalse);

          async.elapse(const Duration(seconds: 1));
          expect(harness.tilesBlinded, isTrue);
        });
      });

      test('clears previously revealed tiles when starting', () {
        fakeAsync((async) {
          harness.startBlindTimer();
          async.elapse(
              Duration(seconds: GameModeHelper.blindHideDelaySeconds(4)));
        });

        // Blind state achieved
        expect(harness.tilesBlinded, isTrue);
        expect(harness.blindRevealedTiles, isEmpty);
      });

      test('notifies listeners when tiles become blinded', () {
        final freshHarness = _BlindHarness(3); // 15 second delay
        int notifyCount = 0;
        freshHarness.addListener(() => notifyCount++);

        fakeAsync((async) {
          freshHarness.startBlindTimer();

          async.elapse(const Duration(seconds: 15));
          expect(notifyCount, greaterThan(0));
        });
      });
    });
  });
}
