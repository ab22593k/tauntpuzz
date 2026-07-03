import 'package:leafy/data/services/cbl_storage_service.dart';
import 'package:leafy/data/services/storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<StorageService>(KConfigStorageService());
}
