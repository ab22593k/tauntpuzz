/// Application directory/namespace name used across storage paths.
///
/// Used on Linux as the subdirectory under XDG base directories
/// (e.g. `~/.local/share/leafy/`, `~/.cache/leafy/`) and as the
/// KConfig-style data file name (`leafyrc`).
const String appStorageDirName = 'leafy';

class StorageKey {
  static const String puzzle = 'puzzle';
  static const String secondsElapsed = 'secondsElapsed';
  static const String scores = 'scores';
  static const String gameMode = 'gameMode';
  static const String marathonStartSize = 'marathonStartSize';
  static const String marathonEndSize = 'marathonEndSize';
}

abstract class StorageService {
  Future<void> init();
  Future<void> remove(String key);
  dynamic get(String key);
  Future<void> clear();
  bool has(String key);
  Future<void> set(String? key, dynamic data);
}
