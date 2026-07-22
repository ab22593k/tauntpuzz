import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafz/ui/core/app_text_styles.dart';
import 'package:leafz/ui/features/puzzle/view_models/puzzle_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class CorrectTilesCount extends ConsumerWidget {
  final ColorScheme? colorScheme;
  final bool showIcon;

  const CorrectTilesCount({super.key, this.colorScheme, this.showIcon = true});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final cs = colorScheme ?? Theme.of(context).colorScheme;
    final state = ref.watch(puzzleProvider);
    final total = state.tiles.length - 1;
    final correct = state.correctTilesCount;
    final ratio = total > 0 ? correct / total : 0.0;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      transitionBuilder: (child, anim) =>
          FadeTransition(opacity: anim, child: child),
      child: Row(
        key: ValueKey(correct),
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[_progressIcon(ratio, cs), const SizedBox(width: 4)],
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
          color: Colors.white,
        ),
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
          color: colorScheme.onSurface.withValues(alpha: 0.54),
        ),
      ),
      _ => HugeIcon(
        icon: HugeIcons.strokeRoundedCheckmarkCircle01,
        size: 14,
        color: color,
      ),
    };
  }
}
