import 'dart:async';

import 'package:leafy/app.dart';
import 'package:leafy/data/services/service_locator.dart';
import 'package:leafy/data/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  runZonedGuarded<Future<void>>(() async {
    WidgetsFlutterBinding.ensureInitialized();
    setupServiceLocator();
    final StorageService storageService = getIt<StorageService>();
    await storageService.init();

    runApp(App(storageService: storageService));
  }, (e, _) => throw e);
}
