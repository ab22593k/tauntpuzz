import 'package:jigsaw/domain/models/game_mode.dart';
import 'package:jigsaw/domain/models/puzzle.dart';
import 'package:jigsaw/data/services/storage_service.dart';
import 'package:flutter/foundation.dart';

/// Mixin that orchestrates game-mode switching and puzzle-size changes across
/// the game-mode-specific mixins ([PuzzleMixinSpeedrun], [PuzzleMixinBlind],
/// [PuzzleMixinMarathon]) and [PuzzleMixinCore].
///
/// ## Position in the mixin chain
/// This is the **rightmost** mixin — the final layer in the chain. It depends
/// on every mixin to its left for the members it calls:
///
/// ```
/// PuzzleProvider
///   with
///     ChangeNotifier,
///     PuzzleMixinSpeedrun,   ← stopWatchSecondsOverride
///     PuzzleMixinBlind,       ← resetBlindState()
///     PuzzleMixinMarathon,    ← resetMarathonState(), readyMarathonAdvance(),
///                               advanceMarathonSize()
///     PuzzleMixinCore,        ← generate(), updateScoresInStorage()
///     PuzzleMixinOrchestrator ← [YOU ARE HERE]
/// ```
///
/// **Why this ordering is required:**
/// Each mixin declares abstract members that are satisfied by the mixins
/// applied to its left. PuzzleMixinOrchestrator sits at the far right so it
/// can call `generate()`, `resetMarathonState()`, `resetBlindState()`, etc.
/// — all provided by the chain to its left — without needing to declare them
/// as abstract.
///
/// Must be applied **after** all other puzzle mixins in the `with` clause.
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
