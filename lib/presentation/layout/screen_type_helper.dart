enum ScreenType {
  xSmall,
  small,
  medium,
  large,
}

class ScreenTypeHelper {
  final double screenWidth;
  final double screenHeight;

  const ScreenTypeHelper(this.screenWidth, this.screenHeight);

  static Map<ScreenType, double> breakpoints = {
    ScreenType.xSmall: 375,
    ScreenType.small: 576,
    ScreenType.medium: 1200,
    ScreenType.large: 1440,
  };

  bool get isWideLayout => screenWidth > 600 && screenWidth > screenHeight;

  ScreenType get type {
    if (screenWidth <= breakpoints[ScreenType.xSmall]!) {
      return ScreenType.xSmall;
    } else if (screenWidth <= breakpoints[ScreenType.small]!) {
      return ScreenType.small;
    } else if (screenWidth <= breakpoints[ScreenType.medium]!) {
      return ScreenType.medium;
    } else {
      return ScreenType.large;
    }
  }
}
