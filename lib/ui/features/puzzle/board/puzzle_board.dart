import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/ui/core/animations/animations_manager.dart';
import 'package:leafy/ui/core/animations/pulse_transition.dart';
import 'package:leafy/ui/core/animations/scale_up_transition.dart';
import 'package:leafy/ui/core/layout/screen_type_helper.dart';
import 'package:leafy/ui/features/tile/tile_animated_positioned.dart';
import 'package:leafy/ui/features/tile/tile_content.dart';
import 'package:leafy/ui/features/tile/tile_gesture_detector.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_notifier.dart';
import 'package:leafy/ui/features/puzzle/view_models/stop_watch_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PuzzleBoard extends ConsumerStatefulWidget {
  final double containerWidth;
  final WindowClass windowClass;

  const PuzzleBoard({
    super.key,
    required this.containerWidth,
    this.windowClass = WindowClass.expanded,
  });

  @override
  ConsumerState<PuzzleBoard> createState() => _PuzzleBoardState();
}

class _PuzzleBoardState extends ConsumerState<PuzzleBoard> {
  final FocusNode keyboardListenerFocusNode = FocusNode();

  @override
  void dispose() {
    keyboardListenerFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final puzzleState = ref.watch(puzzleProvider);
    final tileWidth = widget.containerWidth / puzzleState.n;
    final isSolved = puzzleState.puzzle.isSolved;
    final isBlind = puzzleState.gameMode == GameMode.blind;
    final tilesBlinded = puzzleState.tilesBlinded;

    return ScaleUpTransition(
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutBack,
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: KeyboardListener(
        onKeyEvent: (event) {
          if (event case KeyDownEvent(:var physicalKey)) {
            if (physicalKey == PhysicalKeyboardKey.keyR) {
              ref.read(stopWatchProvider.notifier).stop();
              ref.read(puzzleProvider.notifier).generate(forceRefresh: true);
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
          ref.read(puzzleProvider.notifier).handleKeyboardEvent(event);
          if (event case KeyDownEvent()
              when puzzleState.movesCount == 1 &&
                  keyboardListenerFocusNode.hasFocus) {
            ref.read(stopWatchProvider.notifier).start();
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
                width: widget.containerWidth,
                height: widget.containerWidth,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: colorScheme.surfaceContainer,
                ),
                child: Stack(
                  children: List.generate(
                    puzzleState.tilesWithoutWhitespace.length,
                    (index) {
                      final tile = puzzleState.tilesWithoutWhitespace[index];
                      final tileIsMovable = puzzleState.puzzle.tileIsMovable(
                        tile,
                      );
                      final isBlindContentHidden =
                          isBlind &&
                          tilesBlinded &&
                          !puzzleState.isTileRevealed(tile.currentLocation) &&
                          !isSolved;
                      return TileAnimatedPositioned(
                        tile: tile,
                        puzzleSize: puzzleState.n,
                        tileWidth: tileWidth,
                        tileGestureDetector: TileGestureDetector(
                          tile: tile,
                          tileContent: PulseTransition(
                            isActive: tileIsMovable && !isSolved,
                            child: TileContent(
                              tile: tile,
                              isPuzzleSolved: isSolved,
                              puzzleSize: puzzleState.n,
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
    );
  }
}
