import 'dart:async';

import 'package:dashtronaut/app.dart';
import 'package:dashtronaut/services/service_locator.dart';
import 'package:dashtronaut/services/storage/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/url_strategy.dart';

void main() {
  usePathUrlStrategy();
  setupServiceLocator();
  runZonedGuarded<Future<void>>(() async {
    final StorageService storageService = getIt<StorageService>();
    await storageService.init();

    runApp(App(storageService: storageService));
  }, (e, _) => throw e);
}
