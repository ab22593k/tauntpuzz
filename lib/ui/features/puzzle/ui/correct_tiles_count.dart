import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class CorrectTilesCount extends StatelessWidget {
  final ColorScheme? colorScheme;

  const CorrectTilesCount({super.key, this.colorScheme});

  @override
  Widget build(BuildContext context) {
    final cs = colorScheme ?? Theme.of(context).colorScheme;

    return Consumer<PuzzleProvider>(
      builder: (c, puzzleProvider, _) {
        final total = puzzleProvider.puzzle.tiles.length - 1;
        final correct = puzzleProvider.correctTilesCount;
        final ratio = total > 0 ? correct / total : 0.0;

        return AnimatedSwitcher(
          duration: const Duration(milliseconds: 400),
          transitionBuilder: (child, anim) => FadeTransition(
            opacity: anim,
            child: child,
          ),
          child: Row(
            key: ValueKey(correct),
            mainAxisSize: MainAxisSize.min,
            children: [
              _progressIcon(ratio, cs),
              const SizedBox(width: 4),
              Text(
                '$correct/$total',
                style: AppTextStyles.labelSmall.copyWith(
                  color: _progressColor(ratio, cs),
                  fontVariations: const [FontVariation('wght', 700)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Color _progressColor(double ratio, ColorScheme colorScheme) =>
      switch (ratio) {
        >= 1.0 => const Color(0xff2e7d32),
        >= 0.75 => const Color(0xffb8860b),
        >= 0.5 => colorScheme.secondary,
        _ => colorScheme.primary,
      };

  Widget _progressIcon(double ratio, ColorScheme colorScheme) {
    final color = _progressColor(ratio, colorScheme);
    return switch (ratio) {
      >= 1.0 => Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.zero,
          ),
          child: const HugeIcon(
              icon: HugeIcons.strokeRoundedStarAward01,
              size: 10,
              color: Colors.white),
        ),
      >= 0.75 => Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.zero,
            border: Border.all(color: color, width: 1.5),
          ),
          child: HugeIcon(
              icon: HugeIcons.strokeRoundedCheckmarkCircle01,
              size: 10,
              color: colorScheme.onSurface.withValues(alpha: 0.54)),
        ),
      _ => HugeIcon(
          icon: HugeIcons.strokeRoundedCheckmarkCircle01,
          size: 14,
          color: color),
    };
  }
}
