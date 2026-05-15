import 'package:tauntpuzz/data/services/hive_storage_service.dart';
import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<StorageService>(HiveStorageService());
}
