enum WindowClass { compact, medium, expanded, large, extraLarge }

class ScreenTypeHelper {
  final double screenWidth;
  final double screenHeight;

  const ScreenTypeHelper(this.screenWidth, this.screenHeight);

  static const double compactMaxWidth = 599;
  static const double mediumMaxWidth = 839;
  static const double expandedMaxWidth = 1199;
  static const double largeMaxWidth = 1599;

  bool get isWideLayout => screenWidth > screenHeight;

  WindowClass get windowClass => switch (screenWidth) {
    <= compactMaxWidth => WindowClass.compact,
    <= mediumMaxWidth => WindowClass.medium,
    <= expandedMaxWidth => WindowClass.expanded,
    <= largeMaxWidth => WindowClass.large,
    _ => WindowClass.extraLarge,
  };

  bool get isSinglePanePreferred => switch (windowClass) {
    WindowClass.compact || WindowClass.medium => true,
    _ => false,
  };

  int get recommendedPaneCount => switch (windowClass) {
    WindowClass.compact => 1,
    WindowClass.medium => 1,
    WindowClass.expanded || WindowClass.large => 2,
    WindowClass.extraLarge => 2,
  };

  int get maximumPaneCount => switch (windowClass) {
    WindowClass.compact => 1,
    WindowClass.medium => 2,
    WindowClass.expanded || WindowClass.large => 2,
    WindowClass.extraLarge => 3,
  };

  bool get railsVisible => switch (windowClass) {
    WindowClass.expanded || WindowClass.large || WindowClass.extraLarge => true,
    _ => false,
  };
}
