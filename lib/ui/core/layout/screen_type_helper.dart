enum WindowClass {
  compact,
  medium,
  expanded,
}

class ScreenTypeHelper {
  final double screenWidth;
  final double screenHeight;

  const ScreenTypeHelper(this.screenWidth, this.screenHeight);

  static const double compactMaxWidth = 599;
  static const double mediumMaxWidth = 839;

  bool get isWideLayout => screenWidth > screenHeight;

  WindowClass get windowClass {
    if (screenWidth <= compactMaxWidth) {
      return WindowClass.compact;
    } else if (screenWidth <= mediumMaxWidth) {
      return WindowClass.medium;
    } else {
      return WindowClass.expanded;
    }
  }
}
