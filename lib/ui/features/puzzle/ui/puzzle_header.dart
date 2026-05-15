import 'package:tauntpuzz/ui/core/animations/animations_manager.dart';
import 'package:tauntpuzz/ui/core/animations/fade_in_transition.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/correct_tiles_count.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/moves_count.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/puzzle_stop_watch.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
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

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: isCompact ? _compactLayout : _expandedLayout,
    );
  }

  Widget get _compactLayout {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const PuzzleStopWatch(),
        _statChip(Icons.swap_vert, const MovesCount()),
        const CorrectTilesCount(),
      ],
    );
  }

  Widget get _expandedLayout {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashtronaut', style: AppTextStyles.headlineSmall),
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
        _statChip(Icons.swap_vert, const MovesCount()),
        const SizedBox(width: 12),
        const CorrectTilesCount(),
      ],
    );
  }

  Widget _statChip(IconData icon, Widget text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: AppColors.onSurface.withValues(alpha: 0.6)),
        const SizedBox(width: 4),
        DefaultTextStyle(
          style: AppTextStyles.labelSmall.copyWith(color: AppColors.onSurface),
          child: text,
        ),
      ],
    );
  }
}
