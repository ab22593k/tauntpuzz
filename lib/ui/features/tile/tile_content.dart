import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/domain/models/tile.dart';
import 'package:tauntpuzz/ui/core/animations/animations_manager.dart';
import 'package:tauntpuzz/ui/core/layout/puzzle_layout.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';

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
                  ? AppColors.surfaceContainerHighest
                  : AppColors.surfaceContainerLow,
              borderRadius: BorderRadius.zero,
              border: Border.all(
                color: AppColors.outlineVariant.withValues(alpha: 0.2),
                width: 0.5,
              ),
            ),
            child: Center(
              child: Text(
                '${widget.tile.value}',
                style: (MediaQuery.of(context).size.width < 576
                        ? AppTextStyles.tileMobile
                        : AppTextStyles.tile)
                    .copyWith(
                        fontSize: PuzzleLayout.tileTextSize(widget.puzzleSize),
                        color: AppColors.onSurface),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
