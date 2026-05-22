import 'package:lullaby/ui/core/layout/screen_type_helper.dart';

class Spacing {
  static const double unit = 5;
  static const double xs = 5;
  static const double sm = 12;
  static const double md = 22;
  static const double lg = 32;
  static const double xl = 40;
  static const double tileGap = 4;

  static const double screenHPadding = 24;

  static double screenHPaddingFor(WindowClass windowClass) =>
      switch (windowClass) {
        WindowClass.compact => 24,
        WindowClass.medium => 48,
        WindowClass.expanded => 100,
      };

  static double puzzleMargin(WindowClass windowClass) => switch (windowClass) {
        WindowClass.compact => 24,
        WindowClass.medium => 64,
        WindowClass.expanded => 100,
      };

  static double overlayPadding(WindowClass windowClass) =>
      switch (windowClass) {
        WindowClass.compact => 16,
        WindowClass.medium => 24,
        WindowClass.expanded => 40,
      };
}
