import 'dart:math';

import 'package:jigsaw/ui/core/layout/phrase_bubble_layout.dart';
import 'package:flutter/cupertino.dart';

/// Provides contextual encouragement phrases displayed in the
/// [PhraseBubble] widget.
///
/// Phrase lists are grouped by [PhraseState]:
/// - `puzzleStarted` — random encouragement when the first move is made
/// - `doingGreat` — random encouragement as tiles reach correct positions
/// - `puzzleSolved` — celebratory message when the puzzle is solved
/// - `hardPuzzleSelected` — playful reaction when a large puzzle size is
///   chosen
/// - `dashTapped` — cycling comic commentary when the mascot is repeatedly
///   tapped; runs through ~15 lines in order before wrapping around
///
/// Phrases are drawn randomly from the relevant list, except for dash taps
/// which advance sequentially through the `dashTappedPhrases` list via an
/// incrementing [dashTapCount].
class PhrasesProvider with ChangeNotifier {
  static const List<String> puzzleStartedPhrases = [
    'Good luck!',
    'You can do it!',
    'I believe in you!',
  ];

  static const List<String> doingGreatPhrases = [
    'Keep going!',
    'You\'r doing great!',
    'Not much left!',
  ];

  static const List<String> puzzleSolvedPhrases = [
    'You Are AMAZING!',
    'You Are AWESOME!',
    'Wow! You Did It!',
  ];

  static const List<String> hardPuzzlePhrases = [
    'You sure you can handle all of that?!',
    'WOW! That\'s not easy!',
    'Easy is boring 😉',
  ];

  static const List<String> puzzleTakingTooLongPhrases = [
    'This is taking too long!',
    'Don\'t lose hope',
    'Better late than never',
  ];

  static const List<String> dashTappedPhrases = [
    'Hi! I\'m Dash',
    'The mascot for Flutter 💙 & Dart',
    'Which is what this app is built with!',
    'And I\'m an astronaut here',
    'So you can call me Jigsaw',
    'You can stop poking me now 😃',
    'Why don\'t you play with the puzzle instead???',
    'You\'re starting to annoy me!',
    'Argh! Never mind!',
    'You\'ll probably keep doing this 😒',
    'I can start over you know!!',
    'Hi! I\'m Dash',
    'Nah I didn\'t start over',
    'Now I will...',
    'Hi! I\'m Dash',
    'Still didn\'t',
  ];

  static final Random random = Random();

  static int maxDashTaps = dashTappedPhrases.length - 1;

  int dashTapCount = -1;

  String getPhrase(PhraseState phraseState) {
    assert(phraseState != PhraseState.none);
    return switch (phraseState) {
      PhraseState.puzzleStarted =>
        puzzleStartedPhrases[random.nextInt(puzzleSolvedPhrases.length - 1)],
      PhraseState.puzzleSolved =>
        puzzleSolvedPhrases[random.nextInt(puzzleSolvedPhrases.length - 1)],
      PhraseState.hardPuzzleSelected =>
        hardPuzzlePhrases[random.nextInt(hardPuzzlePhrases.length - 1)],
      PhraseState.doingGreat =>
        doingGreatPhrases[random.nextInt(doingGreatPhrases.length - 1)],
      PhraseState.dashTapped => dashTappedPhrases[dashTapCount],
      PhraseState.none || PhraseState.puzzleTakingTooLong => '',
    };
  }

  PhraseState phraseState = PhraseState.none;

  void setPhraseState(PhraseState phraseState) {
    phraseState = phraseState;
    if (phraseState == PhraseState.dashTapped) {
      if (dashTapCount == maxDashTaps) {
        dashTapCount = 0;
      } else {
        dashTapCount++;
      }
    }
    notifyListeners();
  }
}
