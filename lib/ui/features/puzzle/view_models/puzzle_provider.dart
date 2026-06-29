import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:jigsaw/domain/models/game_mode.dart';
import 'package:jigsaw/domain/models/puzzle.dart';
import 'package:jigsaw/domain/models/score.dart';
import 'package:jigsaw/domain/models/tile.dart';
import 'package:jigsaw/data/services/storage_service.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_mixin_blind.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_mixin_core.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_mixin_marathon.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_mixin_orchestrator.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_mixin_speedrun.dart';
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
  @override
  late List<Tile> tiles;

  /// list of [tiles] excluding white space tile
  List<Tile> get tilesWithoutWhitespace =>
      tiles.where((tile) => !tile.tileIsWhiteSpace).toList();

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

  int get correctTilesCount {
    int count = 0;
    for (final tile in tiles) {
      if (tile.isAtCorrectLocation && !tile.tileIsWhiteSpace) {
        count++;
      }
    }
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
