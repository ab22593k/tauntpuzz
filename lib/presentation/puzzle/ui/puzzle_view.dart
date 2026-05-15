import 'package:dashtronaut/presentation/background/widgets/background_stack.dart';
import 'package:dashtronaut/presentation/dash/dash_rive_animation.dart';
import 'package:dashtronaut/presentation/layout/dash_layout.dart';
import 'package:dashtronaut/presentation/layout/phrase_bubble_layout.dart';
import 'package:dashtronaut/presentation/layout/puzzle_layout.dart';
import 'package:dashtronaut/presentation/layout/screen_type_helper.dart';
import 'package:dashtronaut/presentation/phrases/animated_phrase_bubble.dart';
import 'package:dashtronaut/presentation/puzzle/board/puzzle_board.dart';
import 'package:dashtronaut/providers/puzzle_provider.dart';
import 'package:dashtronaut/providers/stop_watch_provider.dart';
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
        final screenWidth = constraints.maxWidth;
        final screenHeight = constraints.maxHeight;
        final padding = MediaQuery.of(context).padding;
        final screenTypeHelper = ScreenTypeHelper(screenWidth, screenHeight);
        final puzzleLayout = PuzzleLayout(
          screenTypeHelper: screenTypeHelper,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          paddingLeft: padding.left,
          paddingTop: padding.top,
        );
        final containerWidth = puzzleLayout.containerWidth;
        final dashLayout = DashLayout(
          screenTypeHelper: screenTypeHelper,
          screenWidth: screenWidth,
          screenHeight: screenHeight,
          containerWidth: containerWidth,
        );
        final phraseBubbleLayout = PhraseBubbleLayout(
          screenTypeHelper: screenTypeHelper,
          dashSize: dashLayout.size,
          dashPosition: dashLayout.position,
        );

        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Stack(
              children: [
                BackgroundStack(size: Size(screenWidth, screenHeight)),
                ...puzzleLayout.buildUIElements,
                PuzzleBoard(containerWidth: containerWidth),
                DashRiveAnimation(dashLayout: dashLayout),
                AnimatedPhraseBubble(
                  phraseBubbleLayout: phraseBubbleLayout,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
