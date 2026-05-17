import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/domain/models/puzzle.dart';
import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:flutter/foundation.dart';

/// Mixin that orchestrates game-mode switching and puzzle-size changes across
/// the game-mode-specific mixins ([PuzzleMixinSpeedrun], [PuzzleMixinBlind],
/// [PuzzleMixinMarathon]) and [PuzzleMixinCore].
///
/// Must be applied **after** [PuzzleMixinCore] and the game-mode mixins in the
/// `with` clause so that the abstract members below are satisfied.
mixin PuzzleMixinOrchestrator on ChangeNotifier {
  // ──────────────────────────────────────────────
  // Abstract — provided by PuzzleProvider and/or the other mixins
  // ──────────────────────────────────────────────

  StorageService get storageService;
  GameMode get gameMode;
  set gameMode(GameMode v);
  int get movesCount;
  set movesCount(int v);
  int get stopWatchSecondsOverride;
  set stopWatchSecondsOverride(int v);
  int get n;
  set n(int v);
  void generate({bool forceRefresh = false});
  void resetMarathonState();
  void resetBlindState();
  void readyMarathonAdvance();
  void advanceMarathonSize();

  /// Persists the current puzzle result as a [Score] in storage.
  void updateScoresInStorage();

  // ──────────────────────────────────────────────
  // Orchestration
  // ──────────────────────────────────────────────

  /// Switches to the given [mode], resets mode-specific state, and
  /// generates a fresh puzzle board.
  void setGameMode(GameMode mode) {
    if (gameMode == mode) return;
    gameMode = mode;
    resetMarathonState();
    resetBlindState();
    storageService.set(StorageKey.gameMode, mode.name);
    movesCount = 0;
    stopWatchSecondsOverride = 0;
    storageService.remove(StorageKey.puzzle);
    generate(forceRefresh: true);
    notifyListeners();
  }

  /// Resets the board to the given [size] and generates a fresh puzzle.
  void resetPuzzleSize(int size) {
    assert(Puzzle.supportedPuzzleSizes.contains(size));
    n = size;
    movesCount = 0;
    stopWatchSecondsOverride = 0;
    storageService.remove(StorageKey.puzzle);
    generate(forceRefresh: true);
  }
}
