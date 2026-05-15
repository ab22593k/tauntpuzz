import 'package:tauntpuzz/ui/features/background/background_layers.dart';
import 'package:tauntpuzz/ui/features/background/animated_background_layer.dart';
import 'package:tauntpuzz/ui/features/background/stars.dart';
import 'package:tauntpuzz/ui/core/layout/background_layer_layout.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundStack extends StatelessWidget {
  final Size size;

  const BackgroundStack({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    List<BackgroundLayerLayout> backgroundLayers = BackgroundLayers()(size);

    return Positioned.fill(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [AppColors.nebulaPurple, AppColors.surfaceDim],
            stops: [0, 1],
            radius: 1.1,
            center: Alignment.centerLeft,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: Stars(size: size)),
            ...List.generate(
              backgroundLayers.length,
              (i) => AnimatedBackgroundLayer(layer: backgroundLayers[i]),
            ),
          ],
        ),
      ),
    );
  }
}
