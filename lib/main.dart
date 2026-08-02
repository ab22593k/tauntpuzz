import 'dart:async';
import 'dart:ui' show FragmentProgram;

import 'package:leafz/app.dart';
import 'package:leafz/data/services/cbl_storage_service.dart';
import 'package:leafz/data/services/storage_service.dart';
import 'package:leafz/ui/core/providers/shader_provider.dart';
import 'package:leafz/ui/features/puzzle/view_models/puzzle_notifier.dart'
    show storageServiceProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    final StorageService storageService = KConfigStorageService();
    await storageService.init();

    // Load the animated GPU aurora shader used as the app's default
    // background (rendered by `AuroraShaderBackground`). Falls back to a
    // static gradient when the shader is unavailable on the current
    // platform/build.
    FragmentProgram? shaderProgram;
    try {
      shaderProgram = await FragmentProgram.fromAsset('shaders/aurora.frag');
    } catch (_) {
      shaderProgram = null;
    }

    runApp(
      ProviderScope(
        overrides: [
          storageServiceProvider.overrideWithValue(storageService),
          fragmentProgramProvider.overrideWithValue(shaderProgram),
        ],
        child: const App(),
      ),
    );
  }, (e, _) => throw e);
}
