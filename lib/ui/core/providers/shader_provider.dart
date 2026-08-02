import 'dart:ui' show FragmentProgram;

import 'package:flutter_riverpod/flutter_riverpod.dart';

/// The compiled GPU fragment program that backs the app's animated
/// default background (`shaders/aurora.frag`).
///
/// It is loaded once in `main.dart` and injected via `ProviderScope`
/// overrides. `null` means the shader is unavailable on the current
/// platform/build; consumers ([AuroraShaderBackground]) fall back to a
/// static radial gradient so the app always has a coherent deep-space
/// backdrop.
final fragmentProgramProvider = Provider<FragmentProgram?>((ref) => null);
