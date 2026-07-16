import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafy/generated/app_localizations.dart';
import 'package:leafy/ui/core/layout/phrase_bubble_layout.dart'
    show PhraseState;

@immutable
class PhrasesState {
  final PhraseState phraseState;
  final int dashTapCount;

  const PhrasesState({
    this.phraseState = PhraseState.none,
    this.dashTapCount = -1,
  });

  PhrasesState copyWith({PhraseState? phraseState, int? dashTapCount}) {
    return PhrasesState(
      phraseState: phraseState ?? this.phraseState,
      dashTapCount: dashTapCount ?? this.dashTapCount,
    );
  }
}

class PhrasesNotifier extends Notifier<PhrasesState> {
  static final _puzzleStarted = [
    _phr((l) => l.phraseGoodLuck),
    _phr((l) => l.phraseYouCanDoIt),
    _phr((l) => l.phraseIBelieveInYou),
  ];

  static final _doingGreat = [
    _phr((l) => l.phraseKeepGoing),
    _phr((l) => l.phraseYoureDoingGreat),
    _phr((l) => l.phraseNotMuchLeft),
  ];

  static final _puzzleSolved = [
    _phr((l) => l.phraseYouAreAmazing),
    _phr((l) => l.phraseYouAreAwesome),
    _phr((l) => l.phraseWowYouDidIt),
  ];

  static final _hardPuzzle = [
    _phr((l) => l.phraseSureYouCanHandle),
    _phr((l) => l.phraseWOWThatsNotEasy),
    _phr((l) => l.phraseEasyIsBoring),
  ];

  static final _dashTapped = [
    _phr((l) => l.dashIntro),
    _phr((l) => l.dashMascotOf),
    _phr((l) => l.dashBuiltWith),
    _phr((l) => l.dashAstronaut),
    _phr((l) => l.dashCallMeLeafy),
    _phr((l) => l.dashStopPoking),
    _phr((l) => l.dashPlayInstead),
    _phr((l) => l.dashAnnoying),
    _phr((l) => l.dashNeverMind),
    _phr((l) => l.dashKeepDoingThis),
    _phr((l) => l.dashStartOver),
    _phr((l) => l.dashIntro),
    _phr((l) => l.dashNahDidntStartOver),
    _phr((l) => l.dashNowIWill),
    _phr((l) => l.dashIntro),
    _phr((l) => l.dashStillDidnt),
  ];

  @override
  PhrasesState build() => const PhrasesState();

  static final Random _random = Random();

  String getPhrase(PhraseState phraseState, AppLocalizations l10n) {
    if (phraseState == PhraseState.none) return '';
    return switch (phraseState) {
      PhraseState.puzzleStarted =>
        _puzzleStarted[_random.nextInt(_puzzleStarted.length)](l10n),
      PhraseState.puzzleSolved =>
        _puzzleSolved[_random.nextInt(_puzzleSolved.length)](l10n),
      PhraseState.hardPuzzleSelected =>
        _hardPuzzle[_random.nextInt(_hardPuzzle.length)](l10n),
      PhraseState.doingGreat =>
        _doingGreat[_random.nextInt(_doingGreat.length)](l10n),
      PhraseState.dashTapped => _dashTapped[state.dashTapCount](l10n),
      PhraseState.none || PhraseState.puzzleTakingTooLong => '',
    };
  }

  void setPhraseState(PhraseState newState) {
    int nextDash = state.dashTapCount;
    if (newState == PhraseState.dashTapped) {
      nextDash = nextDash >= _dashTapped.length - 1 ? 0 : nextDash + 1;
    }
    state = state.copyWith(phraseState: newState, dashTapCount: nextDash);
  }
}

typedef _Phr = String Function(AppLocalizations);

_Phr _phr(String Function(AppLocalizations) f) => f;

final phrasesProvider = NotifierProvider<PhrasesNotifier, PhrasesState>(
  PhrasesNotifier.new,
);
