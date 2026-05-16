import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/core/layout/spacing.dart';

class PuzzleLayout {
  final ScreenTypeHelper screenTypeHelper;
  final double screenWidth;
  final double screenHeight;

  PuzzleLayout({
    required this.screenTypeHelper,
    required this.screenWidth,
    required this.screenHeight,
  });

  double get containerWidth {
    final margin = Spacing.puzzleMargin(screenTypeHelper.windowClass) * 2;
    final maxWidth = screenWidth - margin;

    return switch (screenTypeHelper.windowClass) {
      WindowClass.compact => maxWidth,
      WindowClass.medium => maxWidth.clamp(400, 520),
      WindowClass.expanded => (maxWidth).clamp(420, 560),
    };
  }

  static double? tileTextSize(int puzzleSize) {
    return puzzleSize > 5
        ? 20
        : puzzleSize > 4
            ? 25
            : puzzleSize > 3
                ? 30
                : null;
  }
}
