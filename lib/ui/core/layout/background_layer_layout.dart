import 'package:tauntpuzz/domain/models/position.dart';
import 'package:tauntpuzz/ui/core/layout/layout_delegate.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:flutter/cupertino.dart';

enum BackgroundLayerType {
  topRightPlanet,
  topLeftPlanet,
  topBgPlanet,
  bottomLeftPlanet,
  bottomRightPlanet,
  bottomBgPlanet,
}

class BackgroundLayerLayout implements LayoutDelegate {
  @override
  final ScreenTypeHelper screenTypeHelper;

  final BackgroundLayerType type;
  final bool isWideLayout;

  const BackgroundLayerLayout({
    required this.screenTypeHelper,
    required this.type,
    required this.isWideLayout,
  });

  String get assetUrl => 'assets/images/background/${type.name}.png';

  Size get size {
    final baseSize = _baseSize;
    final scale = _scaleForWindowClass;
    return baseSize * scale;
  }

  Size get _baseSize {
    switch (type) {
      case BackgroundLayerType.topRightPlanet:
        return const Size(356, 241);
      case BackgroundLayerType.topLeftPlanet:
        return const Size(144, 142);
      case BackgroundLayerType.topBgPlanet:
        return const Size(63, 63);
      case BackgroundLayerType.bottomLeftPlanet:
        return const Size(276, 196);
      case BackgroundLayerType.bottomRightPlanet:
        return const Size(275, 216);
      case BackgroundLayerType.bottomBgPlanet:
        return const Size(112, 104);
    }
  }

  double get _scaleForWindowClass {
    switch (screenTypeHelper.windowClass) {
      case WindowClass.compact:
        return 0.8;
      case WindowClass.medium:
        return isWideLayout ? 1.0 : 1.2;
      case WindowClass.expanded:
        return isWideLayout ? 0.9 : 1.8;
    }
  }

  Position get outOfViewPosition {
    double extraSpace = 10;

    switch (type) {
      case BackgroundLayerType.topRightPlanet:
      case BackgroundLayerType.topBgPlanet:
        return Position(
            right: -(size.width + extraSpace),
            top: -(size.height + extraSpace));
      case BackgroundLayerType.topLeftPlanet:
        return Position(
            left: -(size.width + extraSpace), top: -(size.height + extraSpace));
      case BackgroundLayerType.bottomLeftPlanet:
      case BackgroundLayerType.bottomBgPlanet:
        return Position(
            left: -(size.width + extraSpace),
            bottom: -(size.height + extraSpace));
      case BackgroundLayerType.bottomRightPlanet:
        return Position(
            right: -(size.width + extraSpace),
            bottom: -(size.height + extraSpace));
    }
  }

  Position get position {
    late Position position;

    switch (type) {
      case BackgroundLayerType.topRightPlanet:
        position =
            Position(right: -size.width * 0.36, top: -size.height * 0.08);
        break;
      case BackgroundLayerType.topLeftPlanet:
        position = Position(left: -size.width * 0.28, top: -size.height * 0.2);
        break;
      case BackgroundLayerType.topBgPlanet:
        position = Position(right: size.width * 2.08, top: size.height * 1.74);
        break;
      case BackgroundLayerType.bottomLeftPlanet:
        position = Position(left: -size.width * 0.42, bottom: 0);
        break;
      case BackgroundLayerType.bottomRightPlanet:
        position =
            Position(right: -size.width * 0.45, bottom: -size.height * 0.45);
        break;
      case BackgroundLayerType.bottomBgPlanet:
        position = Position(left: size.width * 0.6, bottom: size.height * 0.8);
        break;
    }
    return position;
  }

  @override
  String toString() =>
      'BackgroundLayerLayout(type: ${type.name}, size: $size, position: $position, assetUrl: $assetUrl)';
}
