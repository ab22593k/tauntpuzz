import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/domain/models/location.dart';
import 'package:tauntpuzz/domain/models/position.dart';
import 'package:tauntpuzz/domain/models/puzzle.dart';
import 'package:tauntpuzz/domain/models/score.dart';
import 'package:tauntpuzz/domain/models/tile.dart';
import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:tauntpuzz/helpers/game_mode_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

class PuzzleProvider with ChangeNotifier {
  final StorageService storageService;

  PuzzleProvider(this.storageService) {
    _restoreGameMode();
  }

  /// One dimensional size of the puzzle => size = n x n (Default = 4x4)
  int n = Puzzle.supportedPuzzleSizes[1];

  /// Random value used in shuffling tiles
  final Random random = Random();

  /// List of tiles of the puzzle
  late List<Tile> tiles;

  /// list of [tiles] excluding white space tile
  List<Tile> get tilesWithoutWhitespace =>
      tiles.where((tile) => !tile.tileIsWhiteSpace).toList();

  int movesCount = 0;

  bool get hasStarted => movesCount > 0;

  // ──────────────────────────────────────────────
  // Game Mode
  // ──────────────────────────────────────────────

  GameMode _gameMode = GameMode.classic;
  GameMode get gameMode => _gameMode;
  bool get isModeLocked => movesCount > 0;

  void setGameMode(GameMode mode) {
    if (_gameMode == mode) return;
    _gameMode = mode;
    _resetMarathonState();
    _resetBlindState();
    storageService.set(StorageKey.gameMode, mode.name);
    movesCount = 0;
    stopWatchSecondsOverride = 0;
    storageService.remove(StorageKey.puzzle);
    generate(forceRefresh: true);
    notifyListeners();
  }

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
  // Speedrun
  // ──────────────────────────────────────────────

  int stopWatchSecondsOverride = 0;

  /// Speedrun: countdown seconds for the current puzzle size.
  int get speedrunCountdownSeconds =>
      GameModeHelper.speedrunCountdownSeconds(n);

  // ──────────────────────────────────────────────
  // Blind Mode
  // ──────────────────────────────────────────────

  bool _tilesBlinded = false;
  bool get tilesBlinded => _tilesBlinded;
  final Set<Location> _blindRevealedTiles = {};
  Set<Location> get blindRevealedTiles => Set.unmodifiable(_blindRevealedTiles);
  Timer? _blindHideTimer;

  void _startBlindTimer() {
    _resetBlindState();
    final delay = GameModeHelper.blindHideDelaySeconds(n);
    _blindHideTimer = Timer(Duration(seconds: delay), () {
      _tilesBlinded = true;
      _blindRevealedTiles.clear();
      notifyListeners();
    });
  }

  void revealBlindTile(Location location) {
    if (!_tilesBlinded) return;
    _blindRevealedTiles.add(location);
    notifyListeners();
    Future.delayed(const Duration(milliseconds: 1500), () {
      _blindRevealedTiles.remove(location);
      notifyListeners();
    });
  }

  bool isTileRevealed(Location location) =>
      _blindRevealedTiles.contains(location);

  void _resetBlindState() {
    _tilesBlinded = false;
    _blindRevealedTiles.clear();
    _blindHideTimer?.cancel();
    _blindHideTimer = null;
  }

  // ──────────────────────────────────────────────
  // Marathon Mode
  // ──────────────────────────────────────────────

  int? _marathonStartSize;
  int? get marathonStartSize => _marathonStartSize;
  int? _marathonEndSize;
  int? get marathonEndSize => _marathonEndSize;
  bool _marathonRetried = false;
  bool get marathonRetried => _marathonRetried;

  void setMarathonRange(int start, int end) {
    _marathonStartSize = start;
    _marathonEndSize = end;
    storageService.set(StorageKey.marathonStartSize, start);
    storageService.set(StorageKey.marathonEndSize, end);
  }

  void _resetMarathonState() {
    _marathonStartSize = null;
    _marathonEndSize = null;
    _marathonRetried = false;
    if (_gameMode != GameMode.marathon) {
      storageService.remove(StorageKey.marathonStartSize);
      storageService.remove(StorageKey.marathonEndSize);
    }
  }

  bool get isMarathonComplete {
    if (_gameMode != GameMode.marathon || _marathonEndSize == null) {
      return false;
    }
    return n >= _marathonEndSize!;
  }

  void _advanceMarathonSize() {
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
      _resetBlindState();
      storageService.remove(StorageKey.puzzle);
      generate(forceRefresh: true);
    }
  }

  /// Flag set when a solve is detected, consumed by the post-solve handler.
  bool _onPuzzleSolved = false;

  // ──────────────────────────────────────────────

  void resetPuzzleSize(int size) {
    assert(Puzzle.supportedPuzzleSizes.contains(size));
    n = size;
    movesCount = 0;
    stopWatchSecondsOverride = 0;
    storageService.remove(StorageKey.puzzle);
    generate(forceRefresh: true);
  }

  int get correctTilesCount {
    int count = 0;
    for (final tile in tiles) {
      if (tile.isAtCorrectLocation && !tile.tileIsWhiteSpace) {
        count++;
      }
    }
    return count;
  }

  /// Getter for puzzle object
  Puzzle get puzzle => Puzzle(
        n: n,
        tiles: tiles,
        movesCount: movesCount,
      );

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

  /// Action that switches the [Location]'s => [Position]'s of the tile
  /// dragged by the user & the whitespace tile
  /// This causes the [tile.position] getter to get the correct position based on new [Location]'s
  void swapTilesAndUpdatePuzzle(Tile tile) {
    final movedTileIndex = tiles
        .indexWhere((ctile) => ctile.currentLocation == tile.currentLocation);
    final whiteSpaceTileIndex =
        tiles.indexWhere((tile) => tile.tileIsWhiteSpace);
    // Store instances of the moved tile and the white space tile before changing their locations
    final movedTile = tiles[movedTileIndex];
    final whiteSpaceTile = tiles[whiteSpaceTileIndex];

    tiles[movedTileIndex] = tiles[movedTileIndex]
        .copyWith(currentLocation: whiteSpaceTile.currentLocation);
    tiles[whiteSpaceTileIndex] =
        whiteSpaceTile.copyWith(currentLocation: movedTile.currentLocation);

    log('Number of correct tiles ${puzzle.getNumberOfCorrectTiles()} | Is solved: ${puzzle.isSolved}');

    if (tiles[movedTileIndex].isAtCorrectLocation) {
      if (puzzle.isSolved) {
        HapticFeedback.vibrate();
        _handlePuzzleSolved();
      } else {
        HapticFeedback.mediumImpact();
      }
    }

    movesCount++;
    _updatePuzzleInStorage();
    notifyListeners();
  }

  void _handlePuzzleSolved() {
    if (_gameMode == GameMode.marathon) {
      _onPuzzleSolved = true;
      _updateScoresInStorage();
      _advanceMarathonSize();
    } else {
      _updateScoresInStorage();
    }
  }

  List<Score> scores = <Score>[];

  static const int maxStorableScores = 10;

  void _updateScoresInStorage() {
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
      final savedScores = _getScoresFromStorage();
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

  List<Score> _getScoresFromStorage() {
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

  Puzzle? _getPuzzleFromStorage() {
    try {
      final puzzleData = storageService.get(StorageKey.puzzle);
      return Puzzle.fromJson(json.decode(json.encode(puzzleData)));
    } catch (e) {
      log('Error in local storage, clearing data...');
      storageService.clear();
      return null;
    }
  }

  void _updatePuzzleInStorage() {
    try {
      storageService.set(StorageKey.puzzle, puzzle.toJson());
    } catch (e) {
      log('Error updating puzzle in storage');
      log('$e');
    }
  }

  /// Generates tiles with shuffle
  void generate({bool forceRefresh = false}) {
    if (storageService.has(StorageKey.scores)) {
      scores = _getScoresFromStorage();
    }
    // Set tiles & size from locale storage only if they exist and there is no forceRefresh flag (for reset)
    if (storageService.has(StorageKey.puzzle) && !forceRefresh) {
      final stored = _getPuzzleFromStorage();
      if (stored != null) {
        tiles = stored.tiles;
        n = stored.n;
        movesCount = stored.movesCount;
        return;
      }
    }
    movesCount = 0;
    _resetBlindState();
    _generateNew();
    _updatePuzzleInStorage();
    if (_gameMode == GameMode.blind) {
      _startBlindTimer();
    }
    notifyListeners();
  }

  void _generateNew() {
    final tilesCorrectLocations = Puzzle.generateTileCorrectLocations(n);
    final tilesCurrentLocations = List<Location>.from(tilesCorrectLocations);

    tiles = Puzzle.getTilesFromLocations(
      correctLocations: tilesCorrectLocations,
      currentLocations: tilesCurrentLocations,
    );

    while (!puzzle.isSolvable() || puzzle.getNumberOfCorrectTiles() != 0) {
      tilesCurrentLocations.shuffle(random);

      tiles = Puzzle.getTilesFromLocations(
        correctLocations: tilesCorrectLocations,
        currentLocations: tilesCurrentLocations,
      );
    }
  }
}
