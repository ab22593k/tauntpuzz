import 'package:tauntpuzz/ui/core/layout/spacing.dart';
import 'package:tauntpuzz/ui/features/background/background_stack.dart';
import 'package:tauntpuzz/ui/core/layout/puzzle_layout.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/features/puzzle/board/puzzle_board.dart';
import 'package:tauntpuzz/ui/features/drawer/drawer_button.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/puzzle_header.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/reset_puzzle_button.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart' hide DrawerButton;
import 'package:provider/provider.dart';

class PuzzleView extends StatefulWidget {
  const PuzzleView({super.key});

  @override
  State<PuzzleView> createState() => _PuzzleViewState();
}

class _PuzzleViewState extends State<PuzzleView> {
  late PuzzleProvider puzzleProvider;
  late StopWatchProvider stopWatchProvider;

  @override
  void initState() {
    puzzleProvider = Provider.of<PuzzleProvider>(context, listen: false);
    stopWatchProvider = Provider.of<StopWatchProvider>(context, listen: false);
    if (puzzleProvider.hasStarted) {
      stopWatchProvider.start();
    }
    super.initState();
  }

  @override
  void dispose() {
    stopWatchProvider.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final windowWidth = constraints.maxWidth;
        final windowHeight = constraints.maxHeight;
        final padding = MediaQuery.paddingOf(context);
        final screenTypeHelper = ScreenTypeHelper(windowWidth, windowHeight);
        final puzzleLayout = PuzzleLayout(
          screenTypeHelper: screenTypeHelper,
          screenWidth: windowWidth,
          screenHeight: windowHeight,
        );
        final containerWidth = puzzleLayout.containerWidth;
        final overlayPad = Spacing.overlayPadding(screenTypeHelper.windowClass);
        final colorScheme = Theme.of(context).colorScheme;

        return Stack(
          children: [
            BackgroundStack(size: Size(windowWidth, windowHeight)),
            Positioned(
              top: padding.top + overlayPad,
              left: padding.left + overlayPad,
              child: const DrawerButton(),
            ),
            Center(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal:
                      Spacing.puzzleMargin(screenTypeHelper.windowClass),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Spacer(),
                    PuzzleBoard(containerWidth: containerWidth),
                    const Spacer(),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: padding.bottom + overlayPad,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: overlayPad * 2,
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: overlayPad,
                    vertical: overlayPad * 0.5,
                  ),
                  decoration: BoxDecoration(
                    color:
                        colorScheme.surfaceContainerLow.withValues(alpha: 0.90),
                    borderRadius: BorderRadius.zero,
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.15),
                    ),
                  ),
                  child: PuzzleHeader(
                    containerWidth: containerWidth,
                    windowClass: screenTypeHelper.windowClass,
                  ),
                ),
              ),
            ),
            Positioned(
              top: padding.top + overlayPad,
              right: padding.right + overlayPad,
              child: const ResetPuzzleButton(),
            ),
          ],
        );
      },
    );
  }
}
