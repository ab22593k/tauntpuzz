import 'package:leafz/ui/features/background/animated_background_layer.dart';
import 'package:leafz/ui/features/background/aurora_shader_background.dart';
import 'package:leafz/ui/features/background/background_layers.dart';
import 'package:leafz/ui/features/background/stars.dart';
import 'package:flutter/material.dart';

/// The app's default background.
///
/// Composites, bottom-to-top:
///   1. [AuroraShaderBackground] — the animated GPU fragment-shader base
///      (drifting nebula + aurora curtain + twinkling starfield), or a
///      static radial-gradient fallback when the shader is unavailable.
///   2. [Stars] — the app's signature twinkling star field.
///   3. The planet image layers ([AnimatedBackgroundLayer]).
class BackgroundStack extends StatelessWidget {
  final Size size;

  const BackgroundStack({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    final backgroundLayers = BackgroundLayers()(size);

    return Positioned.fill(
      child: Stack(
        children: [
          const Positioned.fill(child: AuroraShaderBackground()),
          Positioned.fill(child: Stars(size: size)),
          ...List.generate(
            backgroundLayers.length,
            (i) => AnimatedBackgroundLayer(layer: backgroundLayers[i]),
          ),
        ],
      ),
    );
  }
}
