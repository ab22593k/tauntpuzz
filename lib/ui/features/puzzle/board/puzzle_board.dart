import 'package:tauntpuzz/domain/models/tile.dart';
import 'package:tauntpuzz/ui/core/animations/animations_manager.dart';
import 'package:tauntpuzz/ui/core/animations/pulse_transition.dart';
import 'package:tauntpuzz/ui/core/animations/scale_up_transition.dart';
import 'package:tauntpuzz/ui/features/tile/tile_animated_positioned.dart';
import 'package:tauntpuzz/ui/features/tile/tile_content.dart';
import 'package:tauntpuzz/ui/features/tile/tile_gesture_detector.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PuzzleBoard extends StatelessWidget {
  final double containerWidth;

  PuzzleBoard({super.key, required this.containerWidth});

  final FocusNode keyboardListenerFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    StopWatchProvider stopWatchProvider =
        Provider.of<StopWatchProvider>(context, listen: false);
    return ScaleUpTransition(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Consumer<PuzzleProvider>(
        builder: (c, PuzzleProvider puzzleProvider, _) => KeyboardListener(
          onKeyEvent: (event) {
            puzzleProvider.handleKeyboardEvent(event);
            if (event case KeyDownEvent()
                when puzzleProvider.movesCount == 1 &&
                    keyboardListenerFocusNode.hasFocus) {
              stopWatchProvider.start();
            }
          },
          focusNode: keyboardListenerFocusNode,
          child: Builder(
            builder: (context) {
              if (!keyboardListenerFocusNode.hasFocus) {
                FocusScope.of(context).requestFocus(keyboardListenerFocusNode);
              }
              return Center(
                child: Container(
                  key: const ValueKey('puzzle_board'),
                  width: containerWidth,
                  height: containerWidth,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.zero,
                    color: colorScheme.surfaceContainer,
                  ),
                  child: Stack(
                    children: List.generate(
                      puzzleProvider.tilesWithoutWhitespace.length,
                      (index) {
                        Tile tile =
                            puzzleProvider.tilesWithoutWhitespace[index];
                        return TileAnimatedPositioned(
                          tile: tile,
                          isPuzzleSolved: puzzleProvider.puzzle.isSolved,
                          puzzleSize: puzzleProvider.n,
                          containerWidth: containerWidth,
                          tileGestureDetector: TileGestureDetector(
                            tile: puzzleProvider.tilesWithoutWhitespace[index],
                            tileContent: PulseTransition(
                              isActive:
                                  puzzleProvider.puzzle.tileIsMovable(tile) &&
                                      !puzzleProvider.puzzle.isSolved,
                              child: TileContent(
                                tile: tile,
                                isPuzzleSolved: puzzleProvider.puzzle.isSolved,
                                puzzleSize: puzzleProvider.n,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
