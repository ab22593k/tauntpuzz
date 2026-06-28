import 'package:jigsaw/domain/models/tile.dart';
import 'package:jigsaw/ui/core/animations/animations_manager.dart';
import 'package:jigsaw/ui/core/layout/puzzle_layout.dart';
import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TileContent extends StatefulWidget {
  final Tile tile;
  final bool isPuzzleSolved;
  final int puzzleSize;

  const TileContent({
    super.key,
    required this.tile,
    required this.isPuzzleSolved,
    required this.puzzleSize,
  });

  @override
  State<TileContent> createState() => _TileContentState();
}

class _TileContentState extends State<TileContent>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late Animation<double> _scale;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: AnimationsManager.tileHover.duration,
    );

    _scale = AnimationsManager.tileHover.tween.animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AnimationsManager.tileHover.curve,
      ),
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return MouseRegion(
      onEnter: (_) {
        if (!widget.isPuzzleSolved) {
          _animationController.forward();
        }
      },
      onExit: (_) {
        if (!widget.isPuzzleSolved) {
          _animationController.reverse();
        }
      },
      child: ScaleTransition(
        scale: _scale,
        child: Padding(
          padding: const EdgeInsets.all(1.5),
          child: Container(
            decoration: BoxDecoration(
              color: widget.tile.isAtCorrectLocation
                  ? colorScheme.surfaceContainerHighest
                  : colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Center(
              child: _buildTileLabel(colorScheme),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTileLabel(ColorScheme colorScheme) {
    // Check if tile content should be hidden in blind mode
    final puzzleProvider = context.watch<PuzzleProvider>();
    final isBlind = puzzleProvider.gameMode.name == 'blind';
    final tileIsRevealed =
        isBlind && puzzleProvider.isTileRevealed(widget.tile.currentLocation);

    final screenWidth = MediaQuery.of(context).size.width;
    final wc = ScreenTypeHelper(screenWidth, 0).windowClass;

    if (isBlind &&
        puzzleProvider.tilesBlinded &&
        !tileIsRevealed &&
        !widget.isPuzzleSolved) {
      return Icon(
        Icons.help_outline,
        size: (PuzzleLayout.tileTextSize(wc, widget.puzzleSize) ?? 24) * 0.6,
        color: colorScheme.onSurface.withValues(alpha: 0.25),
      );
    }

    return Text(
      '${widget.tile.value}',
      style: AppTextStyles.tileAdaptive(wc).copyWith(
        fontSize: PuzzleLayout.tileTextSize(wc, widget.puzzleSize),
        color: colorScheme.onSurface,
      ),
    );
  }
}
