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
