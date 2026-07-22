import 'package:leafz/domain/models/position.dart';
import 'package:leafz/ui/core/layout/layout_delegate.dart';
import 'package:leafz/ui/core/layout/screen_type_helper.dart';
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
