import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_mixin_speedrun.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';

/// Minimal harness to test PuzzleMixinSpeedrun in isolation.
class _SpeedrunHarness extends ChangeNotifier with PuzzleMixinSpeedrun {
  _SpeedrunHarness(this.n);

  @override
  int n;
}

void main() {
  group('PuzzleMixinSpeedrun', () {
    late _SpeedrunHarness harness;

    setUp(() {
      harness = _SpeedrunHarness(4);
    });

    test('stopWatchSecondsOverride defaults to 0', () {
      expect(harness.stopWatchSecondsOverride, equals(0));
    });

    test('stopWatchSecondsOverride can be set and read', () {
      harness.stopWatchSecondsOverride = 99;
      expect(harness.stopWatchSecondsOverride, equals(99));
    });

    test('speedrunCountdownSeconds returns correct value for size 3', () {
      harness.n = 3;
      expect(harness.speedrunCountdownSeconds, equals(60));
    });

    test('speedrunCountdownSeconds returns correct value for size 4', () {
      harness.n = 4;
      expect(harness.speedrunCountdownSeconds, equals(180));
    });

    test('speedrunCountdownSeconds returns correct value for size 5', () {
      harness.n = 5;
      expect(harness.speedrunCountdownSeconds, equals(300));
    });

    test('speedrunCountdownSeconds returns correct value for size 6', () {
      harness.n = 6;
      expect(harness.speedrunCountdownSeconds, equals(480));
    });

    test('notifyListeners can be called without error', () {
      // PuzzleMixinSpeedrun doesn't call notifyListeners itself, but
      // ensure the harness can call it (ChangeNotifier is mixed in correctly).
      expect(() => harness.notifyListeners(), returnsNormally);
    });
  });
}
