import 'package:dashtronaut/presentation/layout/background_layer_layout.dart';
import 'package:dashtronaut/presentation/layout/screen_type_helper.dart';
import 'package:flutter/material.dart';

class BackgroundLayers {
  static List<BackgroundLayerType> types = [
    BackgroundLayerType.topBgPlanet,
    BackgroundLayerType.topRightPlanet,
    BackgroundLayerType.topLeftPlanet,
    BackgroundLayerType.bottomLeftPlanet,
    BackgroundLayerType.bottomRightPlanet,
  ];

  List<BackgroundLayerLayout> call(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final screenTypeHelper = ScreenTypeHelper(size.width, size.height);
    return List.generate(
      types.length,
      (i) => BackgroundLayerLayout(
        screenTypeHelper: screenTypeHelper,
        type: types[i],
        isWideLayout: screenTypeHelper.isWideLayout,
      ),
    );
  }
}
