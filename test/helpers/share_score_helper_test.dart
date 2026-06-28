import 'package:checks/checks.dart';
import 'package:jigsaw/helpers/share_score_helper.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const int puzzleSize = 3;
  int tilesCount = 8;
  const int movesCount = 55;
  const Duration duration = Duration(seconds: 500);
  String officialWebsiteUrl = 'https://jigsaw.app';

  group('ShareScoreHelper', () {
    test('Gets ${puzzleSize}x$puzzleSize solved puzzle image', () {
      String imageUrl = ShareScoreHelper.getPuzzleSolvedImageUrl(puzzleSize);

      check(imageUrl).equals(
          '${ShareScoreHelper.puzzleSolvedImagesUrlRoot}/solved-3x3.png');
    });

    test('Gets solved puzzle text with 55 moves and 08:20', () {
      String puzzleSolvedText = ShareScoreHelper.getPuzzleSolvedText(
          movesCount, duration, tilesCount);

      check(puzzleSolvedText).equals(
        'I just solved this $tilesCount-Tile Jigsaw slide puzzle in 08:20 with 55 moves!',
      );
    });

    test('Gets solved puzzle text with 55 moves and 08:20 with website link',
        () {
      String puzzleSolvedTextMobile =
          ShareScoreHelper.getPuzzleSolvedTextMobile(
              movesCount, duration, tilesCount);

      check(puzzleSolvedTextMobile).equals(
        'I just solved this 8-Tile Jigsaw slide puzzle in 08:20 with 55 moves! \n\n$officialWebsiteUrl',
      );
    });

    test('Gets solved puzzle Twitter intent link with 55 moves and 08:20', () {
      String twitterShareLink = ShareScoreHelper.getTwitterShareLink(
          movesCount, duration, tilesCount);

      check(twitterShareLink).equals(
        'https://twitter.com/intent/tweet?text=I just solved this 8-Tile Jigsaw slide puzzle in 08:20 with 55 moves!&url=$officialWebsiteUrl',
      );
    });
  });
}
