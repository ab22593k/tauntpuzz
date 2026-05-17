import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/helpers/game_mode_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GameModeHelper', () {
    group('speedrunCountdownSeconds', () {
      test('returns 60 for 3x3 puzzle', () {
        expect(GameModeHelper.speedrunCountdownSeconds(3), equals(60));
      });

      test('returns 180 for 4x4 puzzle', () {
        expect(GameModeHelper.speedrunCountdownSeconds(4), equals(180));
      });

      test('returns 300 for 5x5 puzzle', () {
        expect(GameModeHelper.speedrunCountdownSeconds(5), equals(300));
      });

      test('returns 480 for 6x6 puzzle', () {
        expect(GameModeHelper.speedrunCountdownSeconds(6), equals(480));
      });
    });

    group('blindHideDelaySeconds', () {
      test('returns 15 for 3x3 puzzle', () {
        expect(GameModeHelper.blindHideDelaySeconds(3), equals(15));
      });

      test('returns 25 for 4x4 puzzle', () {
        expect(GameModeHelper.blindHideDelaySeconds(4), equals(25));
      });

      test('returns 35 for 5x5 puzzle', () {
        expect(GameModeHelper.blindHideDelaySeconds(5), equals(35));
      });

      test('returns 45 for 6x6 puzzle', () {
        expect(GameModeHelper.blindHideDelaySeconds(6), equals(45));
      });
    });

    group('displayName', () {
      test('returns correct label for classic', () {
        expect(GameModeHelper.displayName(GameMode.classic), equals('Classic'));
      });

      test('returns correct label for speedrun', () {
        expect(
            GameModeHelper.displayName(GameMode.speedrun), equals('Speedrun'));
      });

      test('returns correct label for blind', () {
        expect(GameModeHelper.displayName(GameMode.blind), equals('Blind'));
      });

      test('returns correct label for marathon', () {
        expect(
            GameModeHelper.displayName(GameMode.marathon), equals('Marathon'));
      });
    });

    group('description', () {
      test('returns description for classic', () {
        expect(GameModeHelper.description(GameMode.classic),
            equals('Solve at your own pace'));
      });

      test('returns description for speedrun', () {
        expect(GameModeHelper.description(GameMode.speedrun),
            equals('Beat the countdown'));
      });

      test('returns description for blind', () {
        expect(GameModeHelper.description(GameMode.blind),
            equals('Tiles hide — tap to peek'));
      });

      test('returns description for marathon', () {
        expect(GameModeHelper.description(GameMode.marathon),
            equals('Chain-solve across sizes'));
      });
    });
  });
}
