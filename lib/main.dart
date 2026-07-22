import 'dart:async';

import 'package:leafz/app.dart';
import 'package:leafz/data/services/cbl_storage_service.dart';
import 'package:leafz/data/services/storage_service.dart';
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

    runApp(
      ProviderScope(
        overrides: [storageServiceProvider.overrideWithValue(storageService)],
        child: const App(),
      ),
    );
  }, (e, _) => throw e);
}
