import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CorrectTilesCount extends StatelessWidget {
  const CorrectTilesCount({super.key});

  @override
  Widget build(BuildContext context) {
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
              _progressIcon(ratio),
              const SizedBox(width: 4),
              Text(
                '$correct/$total',
                style: AppTextStyles.labelSmall.copyWith(
                  color: _progressColor(ratio),
                  fontVariations: const [FontVariation('wght', 700)],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static Color _progressColor(double ratio) {
    if (ratio >= 1.0) return const Color(0xff66bb6a);
    if (ratio >= 0.75) return const Color(0xffffc107);
    if (ratio >= 0.5) return AppColors.secondary;
    return AppColors.primary;
  }

  Widget _progressIcon(double ratio) {
    final color = _progressColor(ratio);

    if (ratio >= 1.0) {
      return Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(3),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.5), blurRadius: 4),
          ],
        ),
        child: const Icon(Icons.star, size: 10, color: Colors.white),
      );
    }
    if (ratio >= 0.75) {
      return Container(
        width: 14,
        height: 14,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: color, width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withValues(alpha: 0.3), blurRadius: 3),
          ],
        ),
        child: const Icon(Icons.check, size: 10, color: Colors.white70),
      );
    }
    return Icon(Icons.check_circle_outline, size: 14, color: color);
  }
}
