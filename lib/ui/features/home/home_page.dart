import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/core/layout/jigsaw_bars.dart';
import 'package:jigsaw/ui/core/layout/jigsaw_scaffold.dart';
import 'package:jigsaw/ui/core/layout/panes.dart';
import 'package:jigsaw/ui/core/layout/spacing.dart';
import 'package:jigsaw/ui/features/drawer/app_drawer.dart';
import 'package:jigsaw/ui/features/drawer/drawer_button.dart';
import 'package:jigsaw/ui/features/puzzle/ui/puzzle_header.dart';
import 'package:jigsaw/ui/features/puzzle/ui/puzzle_view.dart';
import 'package:jigsaw/ui/features/puzzle/ui/reset_puzzle_button.dart';
import 'package:flutter/material.dart' hide DrawerButton;

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const JigsawScaffold(
      topBar: PuzzleAppBar(
        leading: DrawerButton(),
        title: 'Jigsaw',
        subtitle: 'Slide Puzzle',
        actions: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: ResetPuzzleButton(),
          )
        ],
      ),
      bottomBar: PuzzleToolbar(
        child: PuzzleHeader(),
      ),
      // Adaptive surfacing (MD3 "show and hide"):
      // On expanded+ breakpoints the bottom bar is hidden, so the stats
      // reflow into the top rail region — same information, new surface.
      topRail: PuzzleHeader(displayMode: HeaderDisplay.topRail),
      // Supporting pane (MD3 canonical "supporting pane" example):
      // On expanded+ a co-planar stats panel surfaces the labeled stats
      // alongside the focused puzzle board. The puzzle stays single-pane
      // (immersive) on compact/medium per MD3 "single-pane layouts focus
      // attention on one action or view — playing a game."
      secondaryPane: _StatsPane(),
      secondarySizing: PaneSizing.fixed,
      secondaryFixedWidth: PaneSnapPoints.narrow,
      drawer: AppDrawer(),
      body: PuzzleView(),
    );
  }
}

/// A co-planar supporting pane showing the puzzle stats.
///
/// Per MD3: "Larger layouts can simultaneously display an inbox pane and a
/// pane containing a selected conversation. Additional space doesn't just
/// mean making the same thing bigger." This pane surfaces the rich labeled
/// stats that are hidden on compact/medium.
class _StatsPane extends StatelessWidget {
  const _StatsPane();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: Spacing.sm,
        vertical: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Progress',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontFamily: AppTextStyles.primaryFontFamily,
                ),
          ),
          const SizedBox(height: Spacing.md),
          const PuzzleHeader(displayMode: HeaderDisplay.sidePane),
        ],
      ),
    );
  }
}
