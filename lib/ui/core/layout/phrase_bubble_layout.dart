import 'package:tauntpuzz/domain/models/position.dart';
import 'package:tauntpuzz/ui/core/layout/layout_delegate.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
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
    switch (screenTypeHelper.windowClass) {
      case WindowClass.compact:
      case WindowClass.medium:
        return Position(
          right: dashSize.width + (dashPosition.right ?? 0) - 20,
          bottom: (dashSize.height * 0.1) + (dashPosition.bottom ?? 0),
        );
      case WindowClass.expanded:
        return Position(
          right: dashSize.width + (dashPosition.right ?? 0) - 70,
          bottom: (dashSize.height * 0.1) + (dashPosition.bottom ?? 0),
        );
    }
  }
}
