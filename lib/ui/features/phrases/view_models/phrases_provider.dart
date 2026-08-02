import 'dart:math';

import 'package:leafz/generated/app_localizations.dart';
import 'package:leafz/ui/core/layout/phrase_bubble_layout.dart';
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
  static final List<String Function(AppLocalizations)> puzzleStartedPhrases = [
    (l) => l.phraseGoodLuck,
    (l) => l.phraseYouCanDoIt,
    (l) => l.phraseIBelieveInYou,
  ];

  static final List<String Function(AppLocalizations)> doingGreatPhrases = [
    (l) => l.phraseKeepGoing,
    (l) => l.phraseYoureDoingGreat,
    (l) => l.phraseNotMuchLeft,
  ];

  static final List<String Function(AppLocalizations)> puzzleSolvedPhrases = [
    (l) => l.phraseYouAreAmazing,
    (l) => l.phraseYouAreAwesome,
    (l) => l.phraseWowYouDidIt,
  ];

  static final List<String Function(AppLocalizations)> hardPuzzlePhrases = [
    (l) => l.phraseSureYouCanHandle,
    (l) => l.phraseWOWThatsNotEasy,
    (l) => l.phraseEasyIsBoring,
  ];

  static final List<String Function(AppLocalizations)>
  puzzleTakingTooLongPhrases = [
    (l) => l.phraseThisIsTakingTooLong,
    (l) => l.phraseDontLoseHope,
    (l) => l.phraseBetterLateThanNever,
  ];

  static final List<String Function(AppLocalizations)> dashTappedPhrases = [
    (l) => l.dashIntro,
    (l) => l.dashMascotOf,
    (l) => l.dashBuiltWith,
    (l) => l.dashAstronaut,
    (l) => l.dashCallMeLeafz,
    (l) => l.dashStopPoking,
    (l) => l.dashPlayInstead,
    (l) => l.dashAnnoying,
    (l) => l.dashNeverMind,
    (l) => l.dashKeepDoingThis,
    (l) => l.dashStartOver,
    (l) => l.dashIntro,
    (l) => l.dashNahDidntStartOver,
    (l) => l.dashNowIWill,
    (l) => l.dashIntro,
    (l) => l.dashStillDidnt,
  ];

  static final Random random = Random();

  static int maxDashTaps = dashTappedPhrases.length - 1;

  int dashTapCount = -1;

  String getPhrase(PhraseState phraseState, AppLocalizations l10n) {
    assert(phraseState is! PhraseStateNone);
    return switch (phraseState) {
      PhraseStatePuzzleStarted() =>
        puzzleStartedPhrases[random.nextInt(puzzleStartedPhrases.length)](l10n),
      PhraseStatePuzzleSolved() =>
        puzzleSolvedPhrases[random.nextInt(puzzleSolvedPhrases.length)](l10n),
      PhraseStateHardPuzzleSelected() =>
        hardPuzzlePhrases[random.nextInt(hardPuzzlePhrases.length)](l10n),
      PhraseStateDoingGreat() =>
        doingGreatPhrases[random.nextInt(doingGreatPhrases.length)](l10n),
      PhraseStateDashTapped() => dashTappedPhrases[dashTapCount](l10n),
      PhraseStateNone() || PhraseStatePuzzleTakingTooLong() => '',
    };
  }

  PhraseState phraseState = PhraseState.none;

  void setPhraseState(PhraseState state) {
    phraseState = state;
    if (state is PhraseStateDashTapped) {
      if (dashTapCount == maxDashTaps) {
        dashTapCount = 0;
      } else {
        dashTapCount++;
      }
    }
    notifyListeners();
  }
}
