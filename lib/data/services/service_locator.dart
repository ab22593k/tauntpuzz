import 'package:jigsaw/data/services/hive_storage_service.dart';
import 'package:jigsaw/data/services/storage_service.dart';
import 'package:get_it/get_it.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerSingleton<StorageService>(HiveStorageService());
}
