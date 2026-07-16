import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/tile.dart';
import 'package:leafy/ui/core/animations/animations_manager.dart';
import 'package:leafy/ui/core/layout/phrase_bubble_layout.dart';
import 'package:leafy/ui/features/puzzle/share-dialog/puzzle_share_dialog.dart';
import 'package:leafy/ui/features/phrases/view_models/phrases_notifier.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_notifier.dart';
import 'package:leafy/ui/features/puzzle/view_models/stop_watch_notifier.dart';
import 'package:flutter/material.dart';

class TileGestureDetector extends ConsumerWidget {
  final Tile tile;
  final Widget tileContent;

  const TileGestureDetector({
    super.key,
    required this.tile,
    required this.tileContent,
  });

  Future<void> _showPuzzleSolvedDialog(
    BuildContext context,
    WidgetRef ref,
    int secondsElapsed,
  ) async {
    final puzzleState = ref.read(puzzleProvider);
    await showDialog(
      context: context,
      builder: (c) {
        return PuzzleSolvedDialog(
          puzzleSize: puzzleState.n,
          movesCount: puzzleState.movesCount,
          solvingDuration: Duration(seconds: secondsElapsed),
        );
      },
    );
  }

  void _swapTilesAndUpdatePuzzle(BuildContext context, WidgetRef ref) {
    ref.read(puzzleProvider.notifier).swapTilesAndUpdatePuzzle(tile);

    final puzzleState = ref.read(puzzleProvider);

    if (puzzleState.movesCount == 1) {
      if (puzzleState.gameMode == GameMode.speedrun) {
        final seconds = puzzleState.speedrunCountdownSeconds;
        ref.read(stopWatchProvider.notifier).configureCountdown(seconds);
      }
      ref.read(stopWatchProvider.notifier).start();
      ref
          .read(phrasesProvider.notifier)
          .setPhraseState(PhraseState.puzzleStarted);
    } else if (puzzleState.puzzle.isSolved) {
      ref
          .read(phrasesProvider.notifier)
          .setPhraseState(PhraseState.puzzleSolved);
      Future.delayed(AnimationsManager.phraseBubbleTotalAnimationDuration, () {
        if (!context.mounted) return;
        ref.read(phrasesProvider.notifier).setPhraseState(PhraseState.none);
      });

      Future.delayed(AnimationsManager.puzzleSolvedDialogDelay, () {
        if (!context.mounted) return;
        int secondsElapsed = ref.read(stopWatchProvider).secondsElapsed;
        ref.read(stopWatchProvider.notifier).stop();
        _showPuzzleSolvedDialog(context, ref, secondsElapsed).then((_) {
          if (!context.mounted) return;
          ref.read(puzzleProvider.notifier).generate(forceRefresh: true);
        });
      });
    } else {
      final phrasesState = ref.read(phrasesProvider);
      if (phrasesState.phraseState case var state
          when state != PhraseState.none) {
        if (state
            case PhraseState.puzzleStarted ||
                PhraseState.dashTapped ||
                PhraseState.puzzleSolved) {
          Future.delayed(
            AnimationsManager.phraseBubbleTotalAnimationDuration,
            () {
              if (!context.mounted) return;
              ref
                  .read(phrasesProvider.notifier)
                  .setPhraseState(PhraseState.none);
            },
          );
        } else {
          ref.read(phrasesProvider.notifier).setPhraseState(PhraseState.none);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final puzzleState = ref.read(puzzleProvider);

    return IgnorePointer(
      ignoring: tile.tileIsWhiteSpace || puzzleState.puzzle.isSolved,
      child: GestureDetector(
        key: ValueKey('tile_${tile.value}'),
        onHorizontalDragEnd: (details) {
          bool canMoveRight =
              details.velocity.pixelsPerSecond.dx >= 0 &&
              puzzleState.puzzle.tileIsLeftOfWhiteSpace(tile);
          bool canMoveLeft =
              details.velocity.pixelsPerSecond.dx <= 0 &&
              puzzleState.puzzle.tileIsRightOfWhiteSpace(tile);
          bool tileIsMovable = puzzleState.puzzle.tileIsMovable(tile);
          if (tileIsMovable && (canMoveLeft || canMoveRight)) {
            _swapTilesAndUpdatePuzzle(context, ref);
          }
        },
        onVerticalDragEnd: (details) {
          bool canMoveUp =
              details.velocity.pixelsPerSecond.dy <= 0 &&
              puzzleState.puzzle.tileIsBottomOfWhiteSpace(tile);
          bool canMoveDown =
              details.velocity.pixelsPerSecond.dy >= 0 &&
              puzzleState.puzzle.tileIsTopOfWhiteSpace(tile);
          bool tileIsMovable = puzzleState.puzzle.tileIsMovable(tile);
          if (tileIsMovable && (canMoveUp || canMoveDown)) {
            _swapTilesAndUpdatePuzzle(context, ref);
          }
        },
        onTap: () {
          if (puzzleState.gameMode == GameMode.blind &&
              puzzleState.tilesBlinded &&
              !puzzleState.isTileRevealed(tile.currentLocation)) {
            ref
                .read(puzzleProvider.notifier)
                .revealBlindTile(tile.currentLocation);
          }
          bool tileIsMovable = puzzleState.puzzle.tileIsMovable(tile);
          if (tileIsMovable) {
            _swapTilesAndUpdatePuzzle(context, ref);
          }
        },
        child: tileContent,
      ),
    );
  }
}
