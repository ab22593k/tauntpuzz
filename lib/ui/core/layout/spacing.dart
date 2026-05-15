import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';

class Spacing {
  static const double unit = 5;
  static const double xs = 5;
  static const double sm = 10;
  static const double md = 20;
  static const double lg = 25;
  static const double xl = 30;
  static const double tileGap = 4;

  static const double screenHPadding = 17;

  static double screenHPaddingFor(WindowClass windowClass) {
    switch (windowClass) {
      case WindowClass.compact:
        return 17;
      case WindowClass.medium:
        return 32;
      case WindowClass.expanded:
        return 48;
    }
  }

  static double puzzleMargin(WindowClass windowClass) {
    switch (windowClass) {
      case WindowClass.compact:
        return 17;
      case WindowClass.medium:
        return 48;
      case WindowClass.expanded:
        return 64;
    }
  }

  static double overlayPadding(WindowClass windowClass) {
    switch (windowClass) {
      case WindowClass.compact:
        return 12;
      case WindowClass.medium:
        return 20;
      case WindowClass.expanded:
        return 24;
    }
  }
}
