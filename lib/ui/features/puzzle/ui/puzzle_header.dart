import 'package:tauntpuzz/ui/core/animations/animations_manager.dart';
import 'package:tauntpuzz/ui/core/animations/fade_in_transition.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/correct_tiles_count.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/moves_count.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/puzzle_stop_watch.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class PuzzleHeader extends StatelessWidget {
  final double containerWidth;
  final WindowClass windowClass;

  const PuzzleHeader({
    super.key,
    required this.containerWidth,
    required this.windowClass,
  });

  @override
  Widget build(BuildContext context) {
    final isCompact = windowClass == WindowClass.compact;
    final colorScheme = Theme.of(context).colorScheme;

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: isCompact
          ? _compactLayout(colorScheme)
          : _expandedLayout(colorScheme),
    );
  }

  Widget _compactLayout(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const PuzzleStopWatch(),
        _statChip(Icons.swap_vert, const MovesCount(), colorScheme),
        CorrectTilesCount(colorScheme: colorScheme),
      ],
    );
  }

  Widget _expandedLayout(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('tauntpuzz', style: AppTextStyles.headlineSmall),
            SizedBox(height: 2),
            Text(
              'Solve This Slide Puzzle..',
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
        const Spacer(),
        const PuzzleStopWatch(),
        const SizedBox(width: 12),
        _statChip(Icons.swap_vert, const MovesCount(), colorScheme),
        const SizedBox(width: 12),
        CorrectTilesCount(colorScheme: colorScheme),
      ],
    );
  }

  Widget _statChip(IconData icon, Widget text, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon,
            size: 14, color: colorScheme.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 4),
        DefaultTextStyle(
          style:
              AppTextStyles.labelSmall.copyWith(color: colorScheme.onSurface),
          child: text,
        ),
      ],
    );
  }
}
