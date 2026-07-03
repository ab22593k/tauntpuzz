import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/puzzle.dart';
import 'package:leafy/data/services/storage_service.dart';
import 'package:flutter/foundation.dart';

/// Mixin that adds marathon puzzle mode logic (chain-solve across a
/// user-selected size range) to a [ChangeNotifier] provider.
///
/// ## Position in the mixin chain
/// Applied **right of** [PuzzleMixinBlind] and **left of** [PuzzleMixinCore].
/// Exposes `readyMarathonAdvance()` / `advanceMarathonSize()` which are
/// consumed by [PuzzleMixinCore] (for solved dispatch) and
/// [PuzzleMixinOrchestrator] (for state reset).
///
/// Full chain: `Speedrun → Blind → Marathon → Core → Orchestrator`
///
/// Requires the parent class to expose the abstract members below.
mixin PuzzleMixinMarathon on ChangeNotifier {
  // ──────────────────────────────────────────────
  // Abstract — must be provided by the parent class
  // ──────────────────────────────────────────────

  int get n;
  set n(int v);
  int get movesCount;
  set movesCount(int v);
  StorageService get storageService;
  int get stopWatchSecondsOverride;
  set stopWatchSecondsOverride(int v);
  GameMode get gameMode;
  void generate({bool forceRefresh = false});

  // ──────────────────────────────────────────────
  // Marathon Mode State
  // ──────────────────────────────────────────────

  int? _marathonStartSize;
  int? get marathonStartSize => _marathonStartSize;

  int? _marathonEndSize;
  int? get marathonEndSize => _marathonEndSize;

  bool _marathonRetried = false;
  bool get marathonRetried => _marathonRetried;

  /// Guard flag — set before calling [advanceMarathonSize].
  bool _onPuzzleSolved = false;

  // ──────────────────────────────────────────────
  // Public API
  // ──────────────────────────────────────────────

  /// Sets the marathon size range and persists it.
  void setMarathonRange(int start, int end) {
    _marathonStartSize = start;
    _marathonEndSize = end;
    storageService.set(StorageKey.marathonStartSize, start);
    storageService.set(StorageKey.marathonEndSize, end);
  }

  /// Resets the marathon state. Clears storage unless currently in marathon mode.
  void resetMarathonState() {
    _marathonStartSize = null;
    _marathonEndSize = null;
    _marathonRetried = false;
    _onPuzzleSolved = false;
    if (gameMode != GameMode.marathon) {
      storageService.remove(StorageKey.marathonStartSize);
      storageService.remove(StorageKey.marathonEndSize);
    }
  }

  /// Whether the marathon chain has reached (or passed) the end size.
  bool get isMarathonComplete {
    if (gameMode != GameMode.marathon || _marathonEndSize == null) {
      return false;
    }
    return n >= _marathonEndSize!;
  }

  /// Marks that the current puzzle has been solved and the chain should
  /// attempt to advance. Call [advanceMarathonSize] after this.
  void readyMarathonAdvance() {
    _onPuzzleSolved = true;
  }

  /// Advances to the next puzzle size in the marathon chain if possible.
  /// Resets move/timer counters and calls [generate] for the new board.
  ///
  /// **Note:** This does NOT call `resetBlindState()` — the parent provider
  /// is responsible for orchestrating that if needed.
  void advanceMarathonSize() {
    if (!_onPuzzleSolved) return;
    _onPuzzleSolved = false;

    final sizes = Puzzle.supportedPuzzleSizes;
    final idx = sizes.indexOf(n);
    if (idx < sizes.length - 1 &&
        (_marathonEndSize == null || n < _marathonEndSize!)) {
      n = sizes[idx + 1];
      _marathonRetried = false;
      movesCount = 0;
      stopWatchSecondsOverride = 0;
      storageService.remove(StorageKey.puzzle);
      generate(forceRefresh: true);
    }
  }
}
