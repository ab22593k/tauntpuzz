import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/ui/core/animations/animations_manager.dart';
import 'package:leafy/ui/core/animations/pulse_transition.dart';
import 'package:leafy/ui/core/animations/scale_up_transition.dart';
import 'package:leafy/ui/core/layout/screen_type_helper.dart';
import 'package:leafy/ui/features/tile/tile_animated_positioned.dart';
import 'package:leafy/ui/features/tile/tile_content.dart';
import 'package:leafy/ui/features/tile/tile_gesture_detector.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:leafy/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class PuzzleBoard extends StatelessWidget {
  final double containerWidth;
  final WindowClass windowClass;

  PuzzleBoard({
    super.key,
    required this.containerWidth,
    this.windowClass = WindowClass.expanded,
  });

  final FocusNode keyboardListenerFocusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    StopWatchProvider stopWatchProvider = Provider.of<StopWatchProvider>(
      context,
      listen: false,
    );
    return ScaleUpTransition(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Consumer<PuzzleProvider>(
        builder: (c, PuzzleProvider puzzleProvider, _) => KeyboardListener(
          onKeyEvent: (event) {
            if (event case KeyDownEvent(:var physicalKey)) {
              if (physicalKey == PhysicalKeyboardKey.keyR) {
                stopWatchProvider.stop();
                puzzleProvider.generate(forceRefresh: true);
                return;
              }
              if (physicalKey == PhysicalKeyboardKey.keyD) {
                final scaffold = Scaffold.maybeOf(context);
                if (scaffold != null) {
                  if (scaffold.isDrawerOpen) {
                    Navigator.of(context).pop();
                  } else {
                    scaffold.openDrawer();
                  }
                }
                return;
              }
            }
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
              final isSolved = puzzleProvider.puzzle.isSolved;
              final tileWidth = containerWidth / puzzleProvider.n;
              final isBlind = puzzleProvider.gameMode == GameMode.blind;
              final tilesBlinded = puzzleProvider.tilesBlinded;

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
                        final tile =
                            puzzleProvider.tilesWithoutWhitespace[index];
                        final tileIsMovable = puzzleProvider.puzzle
                            .tileIsMovable(tile);
                        final isBlindContentHidden =
                            isBlind &&
                            tilesBlinded &&
                            !puzzleProvider.isTileRevealed(
                              tile.currentLocation,
                            ) &&
                            !isSolved;
                        return TileAnimatedPositioned(
                          tile: tile,
                          puzzleSize: puzzleProvider.n,
                          tileWidth: tileWidth,
                          tileGestureDetector: TileGestureDetector(
                            tile: tile,
                            tileContent: PulseTransition(
                              isActive: tileIsMovable && !isSolved,
                              child: TileContent(
                                tile: tile,
                                isPuzzleSolved: isSolved,
                                puzzleSize: puzzleProvider.n,
                                isBlindContentHidden: isBlindContentHidden,
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
