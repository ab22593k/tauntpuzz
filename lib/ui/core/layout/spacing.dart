import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';

class Spacing {
  static const double unit = 5;
  static const double xs = 5;
  static const double sm = 12;
  static const double md = 22;
  static const double lg = 32;
  static const double xl = 40;
  static const double tileGap = 4;

  static const double screenHPadding = 24;

  static double screenHPaddingFor(WindowClass windowClass) {
    switch (windowClass) {
      case WindowClass.compact:
        return 24;
      case WindowClass.medium:
        return 48;
      case WindowClass.expanded:
        return 80;
    }
  }

  static double puzzleMargin(WindowClass windowClass) {
    switch (windowClass) {
      case WindowClass.compact:
        return 24;
      case WindowClass.medium:
        return 64;
      case WindowClass.expanded:
        return 80;
    }
  }

  static double overlayPadding(WindowClass windowClass) {
    switch (windowClass) {
      case WindowClass.compact:
        return 16;
      case WindowClass.medium:
        return 24;
      case WindowClass.expanded:
        return 32;
    }
  }
}
