import 'dart:developer';
import 'dart:math' show Random;

import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/domain/models/location.dart';
import 'package:tauntpuzz/domain/models/puzzle.dart';
import 'package:tauntpuzz/domain/models/score.dart';
import 'package:tauntpuzz/domain/models/tile.dart';
import 'package:tauntpuzz/data/services/storage_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// Mixin containing the core puzzle logic — tile swapping, puzzle generation,
/// board state management, and the puzzle-solved dispatch.
///
/// Must be applied **after** [PuzzleMixinBlind] (for `resetBlindState` /
/// `startBlindTimer`) and [PuzzleMixinMarathon] (for
/// `readyMarathonAdvance` / `advanceMarathonSize`) in the `with` clause.
mixin PuzzleMixinCore on ChangeNotifier {
  // ──────────────────────────────────────────────
  // Abstract — provided by PuzzleProvider and/or other mixins
  // ──────────────────────────────────────────────

  List<Tile> get tiles;
  set tiles(List<Tile> v);
  StorageService get storageService;
  List<Score> get scores;
  set scores(List<Score> v);
  int get n;
  set n(int v);
  int get movesCount;
  set movesCount(int v);
  Random get random;
  GameMode get gameMode;
  Puzzle get puzzle;
  void resetBlindState();
  void startBlindTimer();
  void readyMarathonAdvance();
  void advanceMarathonSize();
  void updateScoresInStorage();
  Puzzle? getPuzzleFromStorage();
  void updatePuzzleInStorage();
  List<Score> getScoresFromStorage();

  // ──────────────────────────────────────────────
  // Core puzzle logic
  // ──────────────────────────────────────────────

  /// Action that switches the [Location]'s => [Position]'s of the tile
  /// dragged by the user & the whitespace tile.
  /// This causes the [tile.position] getter to get the correct position
  /// based on new [Location]'s.
  void swapTilesAndUpdatePuzzle(Tile tile) {
    final movedTileIndex = tiles
        .indexWhere((ctile) => ctile.currentLocation == tile.currentLocation);
    final whiteSpaceTileIndex =
        tiles.indexWhere((tile) => tile.tileIsWhiteSpace);
    // Store instances of the moved tile and the white space tile
    // before changing their locations
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
        handlePuzzleSolved();
      } else {
        HapticFeedback.mediumImpact();
      }
    }

    movesCount++;
    updatePuzzleInStorage();
    notifyListeners();
  }

  /// Generates tiles with shuffle. Restores from storage unless
  /// [forceRefresh] is true.
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
    resetBlindState();
    _generateNew();
    updatePuzzleInStorage();
    if (gameMode == GameMode.blind) {
      startBlindTimer();
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

  /// Called when a puzzle is solved. Dispatches to the appropriate
  /// handling based on the current [gameMode].
  void handlePuzzleSolved() {
    if (gameMode == GameMode.marathon) {
      readyMarathonAdvance();
      updateScoresInStorage();
      advanceMarathonSize();
    } else {
      updateScoresInStorage();
    }
  }
}
