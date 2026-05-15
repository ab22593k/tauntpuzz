import 'dart:io';

import 'package:tauntpuzz/helpers/file_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';

import '../mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FileHelper', () {
    setUp(() async {
      PathProviderPlatform.instance = MockPathProviderPlatform();
    });

    test('getTemporaryDirectory', () async {
      final Directory result = await FileHelper.getTemporaryDirectory();
      expect(result.path, kTemporaryPath);
    });
  });
}
