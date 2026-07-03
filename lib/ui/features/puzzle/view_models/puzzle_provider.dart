import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/puzzle.dart';
import 'package:leafy/domain/models/score.dart';
import 'package:leafy/domain/models/tile.dart';
import 'package:leafy/data/services/storage_service.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_mixin_blind.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_mixin_core.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_mixin_marathon.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_mixin_orchestrator.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_mixin_speedrun.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PuzzleProvider
    with
        ChangeNotifier,
        PuzzleMixinSpeedrun,
        PuzzleMixinBlind,
        PuzzleMixinMarathon,
        PuzzleMixinCore,
        PuzzleMixinOrchestrator {
  @override
  final StorageService storageService;

  PuzzleProvider(this.storageService) {
    _restoreGameMode();
  }

  /// One dimensional size of the puzzle => size = n x n (Default = 4x4)
  @override
  int n = Puzzle.supportedPuzzleSizes[1];

  /// Random value used in shuffling tiles
  @override
  final Random random = Random();

  /// List of tiles of the puzzle
  late List<Tile> _tiles;

  @override
  List<Tile> get tiles => _tiles;

  @override
  set tiles(List<Tile> v) {
    _tiles = v;
    _invalidateBoardState();
  }

  /// list of [tiles] excluding white space tile
  List<Tile>? _cachedTilesWithoutWhitespace;
  List<Tile> get tilesWithoutWhitespace {
    if (_cachedTilesWithoutWhitespace case final cached?) return cached;
    final result = _tiles.where((tile) => !tile.tileIsWhiteSpace).toList();
    _cachedTilesWithoutWhitespace = result;
    return result;
  }

  @override
  int movesCount = 0;

  bool get hasStarted => movesCount > 0;

  // ──────────────────────────────────────────────
  // Game Mode
  // ──────────────────────────────────────────────

  GameMode _gameMode = GameMode.classic;
  @override
  GameMode get gameMode => _gameMode;
  @override
  set gameMode(GameMode v) => _gameMode = v;
  bool get isModeLocked => movesCount > 0;

  void _restoreGameMode() {
    final stored = storageService.get(StorageKey.gameMode);
    if (stored != null) {
      try {
        _gameMode = GameMode.values.byName(stored);
      } catch (_) {
        _gameMode = GameMode.classic;
      }
    }
  }

  // ──────────────────────────────────────────────

  /// Getter for puzzle object
  @override
  Puzzle get puzzle => Puzzle(n: n, tiles: tiles, movesCount: movesCount);

  void _invalidateBoardState() {
    _cachedTilesWithoutWhitespace = null;
    _cachedCorrectTilesCount = null;
  }

  /// Invalidates cached board state. Called by mixins after tile mutations.
  @override
  void invalidateBoardState() => _invalidateBoardState();

  int? _cachedCorrectTilesCount;
  int get correctTilesCount {
    if (_cachedCorrectTilesCount case final cached?) return cached;
    int count = 0;
    for (final tile in _tiles) {
      if (tile.isAtCorrectLocation && !tile.tileIsWhiteSpace) {
        count++;
      }
    }
    _cachedCorrectTilesCount = count;
    return count;
  }

  /// Handle Keyboard event and move appropriate tile
  void handleKeyboardEvent(KeyEvent event) {
    if (event case KeyDownEvent(:var physicalKey)) {
      final tile = switch (physicalKey) {
        PhysicalKeyboardKey.arrowDown => puzzle.tileTopOfWhitespace,
        PhysicalKeyboardKey.arrowUp => puzzle.tileBottomOfWhitespace,
        PhysicalKeyboardKey.arrowLeft => puzzle.tileRightOfWhitespace,
        PhysicalKeyboardKey.arrowRight => puzzle.tileLeftOfWhitespace,
        _ => null,
      };

      if (tile case var t?) {
        swapTilesAndUpdatePuzzle(t);
      }
    }
  }

  // ──────────────────────────────────────────────
  // Scores
  // ──────────────────────────────────────────────

  @override
  List<Score> scores = <Score>[];

  static const int maxStorableScores = 10;

  @override
  void updateScoresInStorage() {
    final seconds = stopWatchSecondsOverride > 0
        ? stopWatchSecondsOverride
        : (storageService.get(StorageKey.secondsElapsed) ?? 0);
    final newScore = Score(
      movesCount: movesCount,
      puzzleSize: n,
      secondsElapsed: seconds,
      gameMode: _gameMode,
    );
    try {
      final savedScores = getScoresFromStorage();
      if (savedScores.length == maxStorableScores) {
        savedScores.removeAt(0);
      }
      savedScores.add(newScore);
      scores = savedScores;
      storageService.set(StorageKey.scores, Score.toJsonList(scores));
    } catch (e) {
      storageService.remove(StorageKey.scores);
      log('Error updating scores in storage $e');
    }
  }

  @override
  List<Score> getScoresFromStorage() {
    List<Score> storedScores = [];
    try {
      final scoresData = storageService.get(StorageKey.scores);
      if (scoresData != null) {
        storedScores = Score.fromJsonList(scoresData);
      }
    } catch (e) {
      storageService.remove(StorageKey.scores);
      log('Error retrieving scores from storage');
      log('$e');
    }
    return storedScores;
  }

  // ──────────────────────────────────────────────
  // Puzzle storage
  // ──────────────────────────────────────────────

  @override
  Puzzle? getPuzzleFromStorage() {
    try {
      final puzzleData = storageService.get(StorageKey.puzzle);
      return Puzzle.fromJson(json.decode(json.encode(puzzleData)));
    } catch (e) {
      log('Error in local storage, clearing data...');
      storageService.clear();
      return null;
    }
  }

  @override
  void dispose() {
    resetBlindState();
    super.dispose();
  }

  @override
  void updatePuzzleInStorage() {
    try {
      storageService.set(StorageKey.puzzle, puzzle.toJson());
    } catch (e) {
      log('Error updating puzzle in storage');
      log('$e');
    }
  }
}
