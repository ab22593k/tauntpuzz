import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';

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
        WindowClass.expanded => 72,
        WindowClass.large => 100,
        WindowClass.extraLarge => 120,
      };

  static double puzzleMargin(WindowClass windowClass) => switch (windowClass) {
        WindowClass.compact => 24,
        WindowClass.medium => 64,
        WindowClass.expanded => 80,
        WindowClass.large => 100,
        WindowClass.extraLarge => 140,
      };

  static double overlayPadding(WindowClass windowClass) =>
      switch (windowClass) {
        WindowClass.compact => 16,
        WindowClass.medium => 24,
        WindowClass.expanded => 32,
        WindowClass.large => 40,
        WindowClass.extraLarge => 48,
      };

  static double paneContentMaxWidth(WindowClass windowClass) =>
      switch (windowClass) {
        WindowClass.compact => 600,
        WindowClass.medium => 720,
        WindowClass.expanded => 840,
        WindowClass.large => 960,
        WindowClass.extraLarge => 1200,
      };
}
