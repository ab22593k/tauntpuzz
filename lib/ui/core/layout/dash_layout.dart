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
    final puzzleWidth = containerWidth;
    final dashHeight =
        switch ((screenTypeHelper.isWideLayout, screenTypeHelper.windowClass)) {
      (true, WindowClass.compact) ||
      (true, WindowClass.medium) =>
        screenHeight * 0.5,
      (true, WindowClass.expanded) => screenHeight * 0.35,
      (false, _) => ((screenHeight - puzzleWidth) / 2) * 0.85,
    };
    return Size(dashHeight, dashHeight);
  }

  Position get position => switch (screenTypeHelper.windowClass) {
        WindowClass.compact ||
        WindowClass.medium =>
          const Position(right: -10, bottom: 20),
        WindowClass.expanded => const Position(right: 0, bottom: 70),
      };
}
