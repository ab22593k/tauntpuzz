import 'package:checks/checks.dart';
import 'package:leafy/helpers/share_score_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  int tilesCount = 8;
  const int movesCount = 55;
  const Duration duration = Duration(seconds: 500);
  group('ShareScoreHelper', () {
    test('Gets solved puzzle text with 55 moves and 08:20', () {
      String puzzleSolvedText = ShareScoreHelper.getPuzzleSolvedText(
        movesCount,
        duration,
        tilesCount,
      );

      check(puzzleSolvedText).equals(
        'I just solved this $tilesCount-Tile Leafy slide puzzle in 08:20 with 55 moves!',
      );
    });

    test('Gets solved puzzle Twitter intent link with 55 moves and 08:20', () {
      String twitterShareLink = ShareScoreHelper.getTwitterShareLink(
        movesCount,
        duration,
        tilesCount,
      );

      check(twitterShareLink).equals(
        'https://twitter.com/intent/tweet?text=I just solved this 8-Tile Leafy slide puzzle in 08:20 with 55 moves!',
      );
    });
  });
}
