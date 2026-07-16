import 'dart:async';

import 'package:leafy/app.dart';
import 'package:leafy/data/services/service_locator.dart';
import 'package:leafy/data/services/storage_service.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_notifier.dart'
    show storageServiceProvider;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    setupServiceLocator();
    final StorageService storageService = getIt<StorageService>();
    await storageService.init();

    runApp(
      ProviderScope(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
        child: const App(),
      ),
    );
  }, (e, _) => throw e);
}
