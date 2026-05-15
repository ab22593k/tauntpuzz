import 'package:dashtronaut/presentation/background/utils/background_layers.dart';
import 'package:dashtronaut/presentation/background/widgets/animated_background_layer.dart';
import 'package:dashtronaut/presentation/background/widgets/stars.dart';
import 'package:dashtronaut/presentation/layout/background_layer_layout.dart';
import 'package:dashtronaut/presentation/styles/app_colors.dart';
import 'package:flutter/material.dart';

class BackgroundStack extends StatelessWidget {
  final Size size;

  const BackgroundStack({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    List<BackgroundLayerLayout> backgroundLayers = BackgroundLayers()(context);

    return Positioned.fill(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [AppColors.primaryAccent, AppColors.primary],
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
