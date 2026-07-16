import 'package:leafy/data/services/storage_service.dart';
import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/puzzle.dart';
import 'package:leafy/ui/features/puzzle/view_models/game_mode_strategy.dart';

/// Chain-solve across a user-defined size range.
///
/// When a puzzle is solved the strategy advances [host.n] to the next
/// supported size, resets counters, and generates a fresh board.
class MarathonGameModeStrategy extends GameModeStrategy {
  @override
  GameMode get mode => GameMode.marathon;

  GameModeStrategyHost? _host;

  int? _marathonStartSize;
  @override
  int? get marathonStartSize => _marathonStartSize;

  int? _marathonEndSize;
  @override
  int? get marathonEndSize => _marathonEndSize;

  bool _marathonRetried = false;
  @override
  bool get marathonRetried => _marathonRetried;

  bool _onPuzzleSolved = false;

  // ── Lifecycle ──

  @override
  void onActivate(GameModeStrategyHost host) {
    _host = host;
  }

  @override
  void onDeactivate(GameModeStrategyHost host) {
    if (host.gameMode != GameMode.marathon) {
      host.storageService.remove(StorageKey.marathonStartSize);
      host.storageService.remove(StorageKey.marathonEndSize);
    }
    resetMarathonState();
    _host = null;
  }

  @override
  void onPuzzleSolved(GameModeStrategyHost host) {
    readyMarathonAdvance();
    advanceMarathonSize(host);
  }

  // ── Marathon state ──

  @override
  void setMarathonRange(int start, int end) {
    _marathonStartSize = start;
    _marathonEndSize = end;
    _host?.storageService.set(StorageKey.marathonStartSize, start);
    _host?.storageService.set(StorageKey.marathonEndSize, end);
  }

  @override
  void resetMarathonState() {
    _marathonStartSize = null;
    _marathonEndSize = null;
    _marathonRetried = false;
    _onPuzzleSolved = false;
  }

  @override
  bool get isMarathonComplete {
    if (_marathonEndSize == null) return false;
    final host = _host;
    if (host == null) return false;
    return host.n >= _marathonEndSize!;
  }

  @override
  void readyMarathonAdvance() {
    _onPuzzleSolved = true;
  }

  @override
  void advanceMarathonSize(GameModeStrategyHost host) {
    if (!_onPuzzleSolved) return;
    _onPuzzleSolved = false;

    final sizes = Puzzle.supportedPuzzleSizes;
    final idx = sizes.indexOf(host.n);
    if (idx < sizes.length - 1 &&
        (_marathonEndSize == null || host.n < _marathonEndSize!)) {
      host.n = sizes[idx + 1];
      _marathonRetried = false;
      host.movesCount = 0;
      host.stopWatchSecondsOverride = 0;
      host.storageService.remove(StorageKey.puzzle);
      host.generate(forceRefresh: true);
    }
  }
}
