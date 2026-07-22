import 'package:checks/checks.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafz/ui/features/puzzle/view_models/stop_watch_notifier.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  // ──────────────────────────────────────────────
  // StopWatchState
  // ──────────────────────────────────────────────

  group('StopWatchState', () {
    test('defaults to all zeros', () {
      const state = StopWatchState();
      check(state.secondsElapsed).equals(0);
      check(state.isCountDown).isFalse();
      check(state.countdownInitial).equals(0);
      check(state.countdownRemaining).equals(0);
      check(state.isPaused).isFalse();
      check(state.isCountdownExpired).isFalse();
    });

    test('isCountdownExpired returns true when countdownRemaining <= 0', () {
      const expired = StopWatchState(isCountDown: true, countdownRemaining: 0);
      check(expired.isCountdownExpired).isTrue();
    });

    test('isCountdownExpired returns false when isCountDown is false', () {
      const notCountdown = StopWatchState(
        isCountDown: false,
        countdownRemaining: 0,
      );
      check(notCountdown.isCountdownExpired).isFalse();
    });

    test('isCountdownExpired returns false when countdownRemaining > 0', () {
      const active = StopWatchState(isCountDown: true, countdownRemaining: 5);
      check(active.isCountdownExpired).isFalse();
    });

    test('copyWith preserves unset fields', () {
      const original = StopWatchState(secondsElapsed: 10, isCountDown: true);
      final copied = original.copyWith(countdownInitial: 30);
      check(copied.secondsElapsed).equals(10);
      check(copied.isCountDown).isTrue();
      check(copied.countdownInitial).equals(30);
      check(copied.countdownRemaining).equals(0);
    });
  });

  // ──────────────────────────────────────────────
  // StopWatchNotifier
  // ──────────────────────────────────────────────

  group('StopWatchNotifier', () {
    late ProviderContainer container;
    late StopWatchNotifier notifier;

    setUp(() {
      container = ProviderContainer();
      notifier = container.read(stopWatchProvider.notifier);
    });

    tearDown(() {
      notifier.cancel();
      container.dispose();
    });

    // ── build ─────────────────────────────────

    group('initial state', () {
      test('secondsElapsed is 0', () {
        check(container.read(stopWatchProvider).secondsElapsed).equals(0);
      });

      test('isCountDown is false', () {
        check(container.read(stopWatchProvider).isCountDown).isFalse();
      });

      test('isPaused is false', () {
        check(container.read(stopWatchProvider).isPaused).isFalse();
      });
    });

    // ── init ──────────────────────────────────

    group('init', () {
      test('sets secondsElapsed from persisted value', () {
        notifier.init(42);
        check(container.read(stopWatchProvider).secondsElapsed).equals(42);
      });

      test('init with 0 resets secondsElapsed', () {
        notifier.init(99);
        notifier.init(0);
        check(container.read(stopWatchProvider).secondsElapsed).equals(0);
      });
    });

    // ── configureCountdown ────────────────────

    group('configureCountdown', () {
      test('configures countdown mode with total seconds', () {
        notifier.configureCountdown(60);
        final state = container.read(stopWatchProvider);
        check(state.isCountDown).isTrue();
        check(state.countdownInitial).equals(60);
        check(state.countdownRemaining).equals(60);
        check(state.secondsElapsed).equals(0);
      });

      test('resets secondsElapsed when configuring countdown', () {
        notifier.init(99);
        notifier.configureCountdown(30);
        check(container.read(stopWatchProvider).secondsElapsed).equals(0);
      });

      test('can be called multiple times to reset countdown', () {
        notifier.configureCountdown(60);
        notifier.configureCountdown(30);
        final state = container.read(stopWatchProvider);
        check(state.countdownInitial).equals(30);
        check(state.countdownRemaining).equals(30);
      });
    });

    // ── disableCountdown ──────────────────────

    group('disableCountdown', () {
      test('disables countdown mode and clears countdown fields', () {
        notifier.configureCountdown(60);
        notifier.disableCountdown();
        final state = container.read(stopWatchProvider);
        check(state.isCountDown).isFalse();
        check(state.countdownInitial).equals(0);
        check(state.countdownRemaining).equals(0);
      });
    });

    // ── start / stop ──────────────────────────

    group('start and stop', () {
      test('start sets isPaused to false', () {
        notifier.start();
        check(container.read(stopWatchProvider).isPaused).isFalse();
      });

      test('start increments secondsElapsed over time', () {
        fakeAsync((async) {
          notifier.start();

          async.elapse(const Duration(seconds: 3));
          check(container.read(stopWatchProvider).secondsElapsed).equals(3);
        });
      });

      test('start does not increment secondsElapsed before first tick', () {
        notifier.start();
        check(container.read(stopWatchProvider).secondsElapsed).equals(0);
      });

      test('stop pauses and resets state', () {
        notifier.start();
        notifier.stop();
        final state = container.read(stopWatchProvider);
        check(state.isPaused).isTrue();
        check(state.secondsElapsed).equals(0);
        check(state.isCountDown).isFalse();
        check(state.countdownInitial).equals(0);
        check(state.countdownRemaining).equals(0);
      });

      test('stop is idempotent when called twice', () {
        notifier.start();
        notifier.stop();
        notifier.stop(); // second stop should be a no-op
        check(container.read(stopWatchProvider).isPaused).isTrue();
      });

      test('stop before start is a no-op', () {
        notifier.stop();
        final state = container.read(stopWatchProvider);
        check(state.isPaused).isFalse();
        check(state.secondsElapsed).equals(0);
      });

      test('restart after stop resumes the stream', () {
        fakeAsync((async) {
          notifier.start();
          async.elapse(const Duration(seconds: 1));
          check(container.read(stopWatchProvider).secondsElapsed).equals(1);

          notifier.stop();
          check(container.read(stopWatchProvider).isPaused).isTrue();

          // Resume and verify it ticks again
          notifier.start();
          async.elapse(const Duration(seconds: 2));
          check(container.read(stopWatchProvider).secondsElapsed).equals(2);
        });
      });

      test('ticking accumulates correctly over longer periods', () {
        fakeAsync((async) {
          notifier.start();

          async.elapse(const Duration(seconds: 10));
          check(container.read(stopWatchProvider).secondsElapsed).equals(10);

          async.elapse(const Duration(seconds: 5));
          check(container.read(stopWatchProvider).secondsElapsed).equals(15);
        });
      });
    });

    // ── countdown ─────────────────────────────

    group('countdown', () {
      test('counts down from configured total', () {
        notifier.configureCountdown(60);

        fakeAsync((async) {
          notifier.start();
          async.elapse(const Duration(seconds: 3));
          check(
            container.read(stopWatchProvider).countdownRemaining,
          ).equals(57);
        });
      });

      test('isCountdownExpired becomes true when reaching 0', () {
        notifier.configureCountdown(3);

        fakeAsync((async) {
          notifier.start();
          async.elapse(const Duration(seconds: 3));
          final state = container.read(stopWatchProvider);
          check(state.countdownRemaining).equals(0);
          check(state.isCountdownExpired).isTrue();
        });
      });

      test('does not decrement below 0', () {
        notifier.configureCountdown(2);

        fakeAsync((async) {
          notifier.start();
          async.elapse(const Duration(seconds: 5));
          check(container.read(stopWatchProvider).countdownRemaining).equals(0);
        });
      });

      test('secondsElapsed is not incremented during countdown', () {
        notifier.configureCountdown(10);

        fakeAsync((async) {
          notifier.start();
          async.elapse(const Duration(seconds: 3));
          check(container.read(stopWatchProvider).secondsElapsed).equals(0);
        });
      });
    });

    // ── cancel ────────────────────────────────

    group('cancel', () {
      test('cancels the stream subscription so ticks stop', () {
        fakeAsync((async) {
          notifier.start();
          async.elapse(const Duration(seconds: 2));
          check(container.read(stopWatchProvider).secondsElapsed).equals(2);

          notifier.cancel();

          async.elapse(const Duration(seconds: 3));
          // secondsElapsed stays at 2 after cancel — no more ticks
          check(container.read(stopWatchProvider).secondsElapsed).equals(2);
        });
      });

      test('cancel is idempotent when subscription is null', () {
        notifier.cancel();
        notifier.cancel(); // second cancel should not throw
      });

      test('dispose cancels the subscription without errors', () {
        notifier.start();
        // Should not throw — onDispose calls _subscription?.cancel()
        check(() => container.dispose()).returnsNormally();
      });
    });
  });
}
