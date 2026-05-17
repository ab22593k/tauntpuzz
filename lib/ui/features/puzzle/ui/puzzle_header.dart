import 'package:tauntpuzz/domain/models/game_mode.dart';
import 'package:tauntpuzz/domain/models/puzzle.dart';
import 'package:tauntpuzz/helpers/game_mode_helper.dart';
import 'package:tauntpuzz/ui/core/animations/animations_manager.dart';
import 'package:tauntpuzz/ui/core/animations/fade_in_transition.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/correct_tiles_count.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/moves_count.dart';
import 'package:tauntpuzz/ui/features/puzzle/ui/puzzle_stop_watch.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

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
    final puzzleProvider = context.watch<PuzzleProvider>();

    // Marathon mode — show chain progress instead of classic header
    if (puzzleProvider.gameMode == GameMode.marathon) {
      return FadeInTransition(
        delay: AnimationsManager.bgLayerAnimationDuration,
        child: _marathonHeader(colorScheme, puzzleProvider),
      );
    }

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: isCompact
          ? _compactLayout(colorScheme)
          : _expandedLayout(colorScheme),
    );
  }

  Widget _marathonHeader(
      ColorScheme colorScheme, PuzzleProvider puzzleProvider) {
    final currentSize = puzzleProvider.n;
    final endSize = puzzleProvider.marathonEndSize ?? currentSize;
    final sizes = Puzzle.supportedPuzzleSizes;
    final currentIdx = sizes.indexOf(currentSize);
    final endIdx = sizes.indexOf(endSize);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedLink01,
          size: 16,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 6),
        Text(
          GameModeHelper.displayName(GameMode.marathon),
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontVariations: const [FontVariation('wght', 600)],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '•',
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(width: 4),
        // Chain progress: 3×3 → 4×4 → ...
        ...List.generate(endIdx + 1, (i) {
          final size = sizes[i];
          final isDone = i < currentIdx;
          final isCurrent = i == currentIdx;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    '→',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : isDone
                          ? colorScheme.tertiary.withValues(alpha: 0.15)
                          : Colors.transparent,
                  border: isCurrent
                      ? Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3))
                      : null,
                ),
                child: Text(
                  '$size\u00d7$size',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDone
                        ? colorScheme.tertiary
                        : isCurrent
                            ? colorScheme.primary
                            : colorScheme.onSurface.withValues(alpha: 0.3),
                    fontVariations: [
                      const FontVariation('wght', 700),
                    ],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  Widget _compactLayout(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const PuzzleStopWatch(),
        _statChip(
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowUpDown,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const MovesCount(),
          colorScheme,
        ),
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
        _statChip(
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowUpDown,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const MovesCount(),
          colorScheme,
        ),
        const SizedBox(width: 12),
        CorrectTilesCount(colorScheme: colorScheme),
      ],
    );
  }

  Widget _statChip(Widget iconWidget, Widget text, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
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
