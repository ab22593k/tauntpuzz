import 'dart:convert';
import 'dart:developer';
import 'dart:math' show Random;

import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/location.dart';
import 'package:leafy/domain/models/puzzle.dart';
import 'package:leafy/domain/models/score.dart';
import 'package:leafy/domain/models/tile.dart';
import 'package:leafy/data/services/storage_service.dart';
import 'package:leafy/ui/features/puzzle/view_models/game_mode_strategy.dart';
import 'package:leafy/ui/features/puzzle/view_models/classic_game_mode_strategy.dart';
import 'package:leafy/ui/features/puzzle/view_models/speedrun_game_mode_strategy.dart';
import 'package:leafy/ui/features/puzzle/view_models/blind_game_mode_strategy.dart';
import 'package:leafy/ui/features/puzzle/view_models/marathon_game_mode_strategy.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Provides puzzle state + game-mode-specific lifecycle via strategy pattern.
///
/// ## Architecture
/// Each [GameMode] has a corresponding [GameModeStrategy] that holds
/// mode-specific state (blind, marathon, speedrun) and responds to lifecycle
/// events (puzzle generated, tile moved, solved, mode activate/deactivate).
///
/// Adding a new mode:
/// 1. Add a [GameMode] enum value
/// 2. Create a strategy class extending [GameModeStrategy]
/// 3. Register it in [_strategies]
/// 4. Add exhaustive cases in [GameModeHelper], drawer badges, icons, etc.
class PuzzleProvider extends ChangeNotifier implements GameModeStrategyHost {
  // ──────────────────────────────────────────────
  // Strategy registry
  // ──────────────────────────────────────────────

  final Map<GameMode, GameModeStrategy> _strategies;

  GameModeStrategy get _strategy => _strategies[gameMode]!;

  // ──────────────────────────────────────────────
  // Constructor
  // ──────────────────────────────────────────────

  PuzzleProvider(this.storageService)
    : _strategies = {
        GameMode.classic: ClassicGameModeStrategy(),
        GameMode.speedrun: SpeedrunGameModeStrategy(),
        GameMode.blind: BlindGameModeStrategy(),
        GameMode.marathon: MarathonGameModeStrategy(),
      } {
    _restoreGameMode();
    _strategy.onActivate(this);
  }

  @override
  final StorageService storageService;

  /// One dimensional size of the puzzle => size = n x n (Default = 4x4)
  @override
  int n = Puzzle.supportedPuzzleSizes[1];

  /// Random value used in shuffling tiles
  final Random random = Random();

  /// List of tiles of the puzzle
  late List<Tile> _tiles;

  List<Tile> get tiles => _tiles;

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
  Puzzle get puzzle => Puzzle(n: n, tiles: tiles, movesCount: movesCount);

  void _invalidateBoardState() {
    _cachedTilesWithoutWhitespace = null;
    _cachedCorrectTilesCount = null;
  }

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
    _strategy.onDeactivate(this);
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

  // ──────────────────────────────────────────────
  // Mode-specific state delegation
  // ──────────────────────────────────────────────

  // Speedrun

  @override
  int stopWatchSecondsOverride = 0;

  int get speedrunCountdownSeconds => _strategy.speedrunCountdownSeconds;

  // Blind

  bool get tilesBlinded => _strategy.tilesBlinded;
  Set<Location> get blindRevealedTiles => _strategy.blindRevealedTiles;
  bool isTileRevealed(Location location) => _strategy.isTileRevealed(location);
  void revealBlindTile(Location location) =>
      _strategy.revealBlindTile(location);
  void startBlindTimer() => _strategy.startBlindTimer();
  void resetBlindState() => _strategy.resetBlindState();

  // Marathon

  int? get marathonStartSize => _strategy.marathonStartSize;
  int? get marathonEndSize => _strategy.marathonEndSize;
  bool get marathonRetried => _strategy.marathonRetried;
  bool get isMarathonComplete => _strategy.isMarathonComplete;
  void setMarathonRange(int start, int end) =>
      _strategy.setMarathonRange(start, end);
  void resetMarathonState() => _strategy.resetMarathonState();
  void readyMarathonAdvance() => _strategy.readyMarathonAdvance();
  void advanceMarathonSize() => _strategy.advanceMarathonSize(this);

  // ──────────────────────────────────────────────
  // Core puzzle logic (inlined from PuzzleMixinCore)
  // ──────────────────────────────────────────────

  /// Action that switches the [Location]'s => [Position]'s of the tile
  /// dragged by the user & the whitespace tile.
  /// This causes the [tile.position] getter to get the correct position
  /// based on new [Location]'s.
  void swapTilesAndUpdatePuzzle(Tile tile) {
    final movedTileIndex = tiles.indexWhere(
      (ctile) => ctile.currentLocation == tile.currentLocation,
    );
    final whiteSpaceTileIndex = tiles.indexWhere(
      (tile) => tile.tileIsWhiteSpace,
    );
    // Store instances of the moved tile and the white space tile
    // before changing their locations
    final movedTile = tiles[movedTileIndex];
    final whiteSpaceTile = tiles[whiteSpaceTileIndex];

    tiles[movedTileIndex] = tiles[movedTileIndex].copyWith(
      currentLocation: whiteSpaceTile.currentLocation,
    );
    tiles[whiteSpaceTileIndex] = whiteSpaceTile.copyWith(
      currentLocation: movedTile.currentLocation,
    );

    invalidateBoardState();

    log(
      'Number of correct tiles ${puzzle.getNumberOfCorrectTiles()} | Is solved: ${puzzle.isSolved}',
    );

    if (tiles[movedTileIndex].isAtCorrectLocation) {
      if (puzzle.isSolved) {
        HapticFeedback.vibrate();
        handlePuzzleSolved();
      } else {
        HapticFeedback.mediumImpact();
      }
    }

    movesCount++;
    _strategy.onTileMoved(this);
    updatePuzzleInStorage();
    notifyListeners();
  }

  /// Generates tiles with shuffle. Restores from storage unless
  /// [forceRefresh] is true.
  @override
  void generate({bool forceRefresh = false}) {
    if (storageService.has(StorageKey.scores)) {
      scores = getScoresFromStorage();
    }
    // Set tiles & size from locale storage only if they exist and there is
    // no forceRefresh flag (for reset)
    if (storageService.has(StorageKey.puzzle) && !forceRefresh) {
      final stored = getPuzzleFromStorage();
      if (stored != null) {
        tiles = stored.tiles;
        n = stored.n;
        movesCount = stored.movesCount;
        return;
      }
    }
    movesCount = 0;
    _generateNew();
    updatePuzzleInStorage();
    _strategy.onPuzzleGenerated(this);
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

      invalidateBoardState();
    }
  }

  /// Called when a puzzle is solved. Saves scores then delegates
  /// mode-specific behavior to the active strategy.
  void handlePuzzleSolved() {
    updateScoresInStorage();
    _strategy.onPuzzleSolved(this);
  }

  // ──────────────────────────────────────────────
  // Orchestration (inlined from PuzzleMixinOrchestrator)
  // ──────────────────────────────────────────────

  /// Switches to the given [mode], resets mode-specific state, and
  /// generates a fresh puzzle board.
  void setGameMode(GameMode mode) {
    if (_gameMode == mode) return;
    final old = _strategy;
    _gameMode = mode;
    old.onDeactivate(this);
    storageService.set(StorageKey.gameMode, mode.name);
    movesCount = 0;
    stopWatchSecondsOverride = 0;
    storageService.remove(StorageKey.puzzle);
    generate(forceRefresh: true);
    _strategy.onActivate(this);
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
