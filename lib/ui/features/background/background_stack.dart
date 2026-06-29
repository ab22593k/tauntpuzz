import 'package:jigsaw/ui/features/background/background_layers.dart';
import 'package:jigsaw/ui/features/background/animated_background_layer.dart';
import 'package:jigsaw/ui/features/background/stars.dart';
import 'package:flutter/material.dart';

class BackgroundStack extends StatelessWidget {
  final Size size;

  const BackgroundStack({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundLayers = BackgroundLayers()(size);

    return Positioned.fill(
      child: Container(
        height: size.height,
        width: size.width,
        decoration: BoxDecoration(
          gradient: RadialGradient(
            colors: [colorScheme.surfaceContainerLow, colorScheme.surface],
            stops: const [0, 1],
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
