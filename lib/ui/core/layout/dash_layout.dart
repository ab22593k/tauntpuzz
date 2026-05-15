import 'package:tauntpuzz/domain/models/position.dart';
import 'package:tauntpuzz/ui/core/layout/layout_delegate.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:flutter/cupertino.dart';

class DashLayout implements LayoutDelegate {
  @override
  final ScreenTypeHelper screenTypeHelper;
  final double screenWidth;
  final double screenHeight;
  final double containerWidth;

  DashLayout({
    required this.screenTypeHelper,
    required this.screenWidth,
    required this.screenHeight,
    required this.containerWidth,
  });

  Size get size {
    double puzzleWidth = containerWidth;

    late double dashHeight;

    if (screenTypeHelper.isWideLayout) {
      switch (screenTypeHelper.windowClass) {
        case WindowClass.compact:
        case WindowClass.medium:
          dashHeight = screenHeight * 0.5;
          break;
        case WindowClass.expanded:
          dashHeight = screenHeight * 0.35;
      }
    } else {
      dashHeight = ((screenHeight - puzzleWidth) / 2) * 0.85;
    }
    return Size(dashHeight, dashHeight);
  }

  Position get position {
    switch (screenTypeHelper.windowClass) {
      case WindowClass.compact:
      case WindowClass.medium:
        return const Position(right: -10, bottom: 20);
      case WindowClass.expanded:
        return const Position(right: 0, bottom: 70);
    }
  }
}
