import 'package:leafz/domain/models/position.dart';
import 'package:leafz/ui/core/layout/layout_delegate.dart';
import 'package:leafz/ui/core/layout/screen_type_helper.dart';
import 'package:flutter/cupertino.dart';

/// Represents the active phrase-bubble state.
///
/// Modeled as a sealed class hierarchy so that switch statements and
/// expressions over [PhraseState] are exhaustively checked at compile time:
/// adding a new variant forces every switch to handle it (or add an explicit
/// wildcard/default case).
sealed class PhraseState {
  const PhraseState();

  /// Canonical instances mirroring the former enum members, so existing call
  /// sites keep working (`PhraseState.none`, `PhraseState.puzzleStarted`, …).
  static const none = PhraseStateNone();
  static const puzzleStarted = PhraseStatePuzzleStarted();
  static const puzzleSolved = PhraseStatePuzzleSolved();
  static const hardPuzzleSelected = PhraseStateHardPuzzleSelected();
  static const puzzleTakingTooLong = PhraseStatePuzzleTakingTooLong();
  static const dashTapped = PhraseStateDashTapped();
  static const doingGreat = PhraseStateDoingGreat();

  /// Stateless variants are equal when their runtime type matches, matching
  /// the value semantics the former enum provided.
  @override
  bool operator ==(Object other) => other.runtimeType == runtimeType;

  @override
  int get hashCode => runtimeType.hashCode;
}

/// No phrase bubble is displayed.
final class PhraseStateNone extends PhraseState {
  const PhraseStateNone();
}

/// Encouragement when the first move is made.
final class PhraseStatePuzzleStarted extends PhraseState {
  const PhraseStatePuzzleStarted();
}

/// Celebration when the puzzle is solved.
final class PhraseStatePuzzleSolved extends PhraseState {
  const PhraseStatePuzzleSolved();
}

/// Playful reaction when a large puzzle size is selected.
final class PhraseStateHardPuzzleSelected extends PhraseState {
  const PhraseStateHardPuzzleSelected();
}

/// Nudge when the puzzle has been taking too long.
final class PhraseStatePuzzleTakingTooLong extends PhraseState {
  const PhraseStatePuzzleTakingTooLong();
}

/// Cycling commentary when the mascot is tapped repeatedly.
final class PhraseStateDashTapped extends PhraseState {
  const PhraseStateDashTapped();
}

/// Encouragement as tiles reach correct positions.
final class PhraseStateDoingGreat extends PhraseState {
  const PhraseStateDoingGreat();
}

class PhraseBubbleLayout implements LayoutDelegate {
  @override
  final ScreenTypeHelper screenTypeHelper;
  final Size dashSize;
  final Position dashPosition;

  PhraseBubbleLayout({
    required this.screenTypeHelper,
    required this.dashSize,
    required this.dashPosition,
  });

  Position get position => switch (screenTypeHelper.windowClass) {
    WindowClass.compact || WindowClass.medium => Position(
      right: screenTypeHelper.screenWidth * 0.05,
      top: screenTypeHelper.screenHeight * 0.15,
    ),
    WindowClass.expanded ||
    WindowClass.large ||
    WindowClass.extraLarge => Position(
      right: screenTypeHelper.screenWidth * 0.12,
      top: screenTypeHelper.screenHeight * 0.20,
    ),
  };
}
