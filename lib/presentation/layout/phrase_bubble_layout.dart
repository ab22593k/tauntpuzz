import 'package:dashtronaut/models/position.dart';
import 'package:dashtronaut/presentation/layout/layout_delegate.dart';
import 'package:dashtronaut/presentation/layout/screen_type_helper.dart';
import 'package:flutter/cupertino.dart';

enum PhraseState {
  none,
  puzzleStarted,
  puzzleSolved,
  hardPuzzleSelected,
  puzzleTakingTooLong,
  dashTapped,
  doingGreat,
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

  Position get position {
    switch (screenTypeHelper.type) {
      case ScreenType.xSmall:
      case ScreenType.small:
        return Position(
          right: dashSize.width + (dashPosition.right ?? 0) - 20,
          bottom: (dashSize.height * 0.1) + (dashPosition.bottom ?? 0),
        );
      case ScreenType.medium:
        return Position(
          right: dashSize.width + (dashPosition.right ?? 0) - 40,
          bottom: dashPosition.bottom,
        );
      case ScreenType.large:
        return Position(
          right: dashSize.width + (dashPosition.right ?? 0) - 70,
          bottom: (dashSize.height * 0.1) + (dashPosition.bottom ?? 0),
        );
    }
  }
}
