import 'package:jigsaw/ui/core/layout/puzzle_layout.dart';
import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:jigsaw/ui/core/layout/spacing.dart';
import 'package:jigsaw/ui/features/puzzle/board/puzzle_board.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
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
        final screenTypeHelper = ScreenTypeHelper(windowWidth, windowHeight);
        final puzzleLayout = PuzzleLayout(
          screenTypeHelper: screenTypeHelper,
          screenWidth: windowWidth,
          screenHeight: windowHeight,
        );
        final containerWidth = puzzleLayout.containerWidth;

        return Center(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Spacing.puzzleMargin(screenTypeHelper.windowClass),
            ),
            child: screenTypeHelper.windowClass == WindowClass.compact ||
                    screenTypeHelper.windowClass == WindowClass.medium
                ? Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Spacer(),
                      PuzzleBoard(
                        containerWidth: containerWidth,
                        windowClass: screenTypeHelper.windowClass,
                      ),
                      const Spacer(),
                    ],
                  )
                : Align(
                    alignment: const Alignment(0, -0.45),
                    child: PuzzleBoard(
                      containerWidth: containerWidth,
                      windowClass: screenTypeHelper.windowClass,
                    ),
                  ),
          ),
        );
      },
    );
  }
}
