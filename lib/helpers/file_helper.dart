import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:leafz/data/services/storage_service.dart';
import 'package:path_provider/path_provider.dart' as path;
import 'package:xdg_directories/xdg_directories.dart' as xdg;

/// Helper class for handling [File]s
class FileHelper {
  /// Get temporary directory
  static Future<Directory> getTemporaryDirectory() async {
    return await path.getTemporaryDirectory();
  }

  /// Write File as Bytes from path
  static Future<File> writeFileAsBytes(
    dynamic byteData,
    String filePath,
  ) async {
    return await File(filePath).writeAsBytes(
      byteData.buffer.asUint8List(
        byteData.offsetInBytes,
        byteData.lengthInBytes,
      ),
    );
  }

  /// Returns a type [File] from a url
  ///
  /// Writes the file's binary data to the platform-appropriate cache location.
  /// On Linux, uses `xdgCacheHome` (~/.cache/leafz/); on other platforms,
  /// falls back to the system temporary directory.
  /// Returns the written file.
  static Future<File> getFileFromUrl(String url) async {
    final uri = Uri.parse(url);
    final response = await http.get(uri);
    final byteData = response.bodyBytes;

    Directory cacheDir;
    if (Platform.isLinux) {
      await xdg.cacheHome.create(recursive: true);
      cacheDir = Directory('${xdg.cacheHome.path}/$appStorageDirName');
      await cacheDir.create(recursive: true);
    } else {
      cacheDir = await getTemporaryDirectory();
    }

    final cachePath = '${cacheDir.path}/file.png';
    return await writeFileAsBytes(byteData, cachePath);
  }
}
