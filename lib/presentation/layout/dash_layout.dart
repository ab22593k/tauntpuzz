import 'package:dashtronaut/models/position.dart';
import 'package:dashtronaut/presentation/layout/layout_delegate.dart';
import 'package:dashtronaut/presentation/layout/screen_type_helper.dart';
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
      switch (screenTypeHelper.type) {
        case ScreenType.xSmall:
        case ScreenType.small:
          dashHeight = screenHeight * 0.5;
          break;
        case ScreenType.medium:
          dashHeight = screenHeight * 0.5;
          break;
        case ScreenType.large:
          dashHeight = screenHeight * 0.35;
      }
    } else {
      dashHeight = ((screenHeight - puzzleWidth) / 2) * 0.85;
    }
    return Size(dashHeight, dashHeight);
  }

  Position get position {
    switch (screenTypeHelper.type) {
      case ScreenType.xSmall:
      case ScreenType.small:
        return const Position(right: -10, bottom: 20);
      case ScreenType.medium:
        return const Position(right: 0, bottom: 20);
      case ScreenType.large:
        return const Position(right: 0, bottom: 70);
    }
  }
}
