import 'package:leafy/data/services/storage_service.dart';
import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/location.dart';

/// Minimal surface that [PuzzleProvider] exposes to [GameModeStrategy] instances.
///
/// Breaking this out avoids a circular import between `game_mode_strategy.dart`
/// and `puzzle_provider.dart`.
abstract class GameModeStrategyHost {
  GameMode get gameMode;
  int get n;
  set n(int v);
  int get movesCount;
  set movesCount(int v);
  int get stopWatchSecondsOverride;
  set stopWatchSecondsOverride(int v);
  StorageService get storageService;
  void generate({bool forceRefresh = false});
  void notifyListeners();
  void updateScoresInStorage();
  void updatePuzzleInStorage();
}

/// Strategy per [GameMode] that owns mode-specific lifecycle and state.
///
/// ## Lifecycle
/// [onActivate] / [onDeactivate] — called when switching modes.
/// [onPuzzleGenerated] — called after a fresh board is created.
/// [onTileMoved] — called after each successful tile swap.
/// [onPuzzleSolved] — called when the puzzle enters a solved state.
///   (Score saving is handled by the core; strategies only add mode-specific
///   behavior such as marathon advance.)
///
/// ## State
/// Concrete strategies override the mode-specific getters (blind, marathon,
/// speedrun) that the provider and UI delegate to.
abstract class GameModeStrategy {
  GameMode get mode;

  // ── Lifecycle ──

  void onActivate(GameModeStrategyHost host) {}
  void onDeactivate(GameModeStrategyHost host) {}
  void onPuzzleGenerated(GameModeStrategyHost host) {}
  void onTileMoved(GameModeStrategyHost host) {}
  void onPuzzleSolved(GameModeStrategyHost host) {}

  // ── Speedrun state ──

  int get speedrunCountdownSeconds => 0;

  // ── Blind state ──

  bool get tilesBlinded => false;
  Set<Location> get blindRevealedTiles => const {};
  bool isTileRevealed(Location location) => false;
  void revealBlindTile(Location location) {}
  void startBlindTimer() {}
  void resetBlindState() {}

  // ── Marathon state ──

  int? get marathonStartSize => null;
  int? get marathonEndSize => null;
  bool get marathonRetried => false;
  bool get isMarathonComplete => false;
  void setMarathonRange(int start, int end) {}
  void resetMarathonState() {}
  void readyMarathonAdvance() {}
  void advanceMarathonSize(GameModeStrategyHost host) {}
}
