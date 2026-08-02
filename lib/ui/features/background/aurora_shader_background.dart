import 'dart:ui' show FragmentShader;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafz/ui/core/providers/shader_provider.dart';

/// The animated GPU fragment-shader base layer of the app's default
/// background.
///
/// Renders the `aurora.frag` shader (drifting nebula + rippling aurora
/// curtain + two-layer twinkling starfield) full-screen, repainted every
/// frame. Used as the bottom-most layer of [BackgroundStack]; the app's
/// signature [Stars] and planet image layers are composited on top.
///
/// Watches [fragmentProgramProvider]. When the program is `null` (the
/// shader could not be compiled/loaded on the current platform) it falls
/// back to the same radial gradient the background used before the shader
/// was introduced, so the app always has a coherent backdrop.
///
/// Theme-aware: reads `Theme.of(context).brightness` and uploads it to the
/// shader as `uDark`, so the scene cross-fades between a dark "deep space"
/// palette and a bright "day sky" palette with the app theme.
class AuroraShaderBackground extends ConsumerStatefulWidget {
  const AuroraShaderBackground({super.key});

  @override
  ConsumerState<AuroraShaderBackground> createState() =>
      _AuroraShaderBackgroundState();
}

class _AuroraShaderBackgroundState extends ConsumerState<AuroraShaderBackground>
    with TickerProviderStateMixin {
  /// Per-frame repaint driver. `null` when there is no shader program.
  late final AnimationController? _ticker;

  /// The compiled shader instance, created once from the program.
  late final FragmentShader? _shader;

  /// Monotonic clock fed to the shader as `uTime` (avoids the 0→1 jumps of
  /// a looping [AnimationController]).
  final Stopwatch _watch = Stopwatch();

  @override
  void initState() {
    super.initState();
    final program = ref.read(fragmentProgramProvider);
    if (program != null) {
      _shader = program.fragmentShader();
      _watch.start();
      _ticker = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 1),
      )..repeat();
    } else {
      _shader = null;
      _ticker = null;
    }
  }

  @override
  void dispose() {
    _watch.stop();
    _ticker?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // No shader program available — fall back to the pre-shader gradient.
    if (_shader == null) {
      return const SizedBox.expand(child: _FallbackGradient());
    }

    // Drive the shader's theme palette from the ambient Material brightness.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SizedBox.expand(
      child: AnimatedBuilder(
        animation: _ticker!,
        builder: (context, _) {
          return CustomPaint(
            painter: _AuroraShaderPainter(
              shader: _shader,
              time: _watch.elapsedMilliseconds / 1000.0,
              isDark: isDark,
            ),
          );
        },
      ),
    );
  }
}

/// The static deep-space gradient used when the GPU shader is unavailable.
/// Mirrors the radial gradient [BackgroundStack] used before the shader was
/// introduced, so the fallback is visually seamless.
class _FallbackGradient extends StatelessWidget {
  const _FallbackGradient();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: RadialGradient(
          colors: [colorScheme.surfaceContainerLow, colorScheme.surface],
          stops: const [0, 1],
          radius: 1.1,
          center: Alignment.centerLeft,
        ),
      ),
    );
  }
}

/// Paints the aurora fragment shader full-screen, uploading the resolution,
/// elapsed-time and theme uniforms each frame.
///
/// Uniform indices (must match declaration order in `shaders/aurora.frag`):
///   0,1 → uResolution (vec2)   2 → uTime (float)   3 → uDark (float)
class _AuroraShaderPainter extends CustomPainter {
  final FragmentShader shader;
  final double time;
  final bool isDark;

  _AuroraShaderPainter({
    required this.shader,
    required this.time,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    shader
      ..setFloat(0, size.width)
      ..setFloat(1, size.height)
      ..setFloat(2, time)
      ..setFloat(3, isDark ? 1.0 : 0.0);
    canvas.drawRect(Offset.zero & size, Paint()..shader = shader);
  }

  @override
  bool shouldRepaint(_AuroraShaderPainter oldDelegate) =>
      oldDelegate.time != time || oldDelegate.isDark != isDark;
}
