import 'package:tauntpuzz/helpers/duration_helper.dart';
import 'package:tauntpuzz/domain/models/score.dart';
import 'package:tauntpuzz/ui/core/layout/spacing.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class LatestScoreItem extends StatelessWidget {
  final Score score;
  final double paddingLeft;
  final int rank;
  final bool isBest;

  const LatestScoreItem(
    this.score, {
    super.key,
    required this.paddingLeft,
    required this.rank,
    required this.isBest,
  });

  @override
  Widget build(BuildContext context) {
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;

    return Container(
      padding: EdgeInsets.only(
        left: paddingLeft,
        right: Spacing.screenHPadding + 4,
        top: Spacing.sm,
        bottom: Spacing.sm,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x1AC6C6C6),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 20,
            child: isBest
                ? Icon(Icons.star, size: 14, color: _medalColor)
                : Text(
                    '$rank',
                    style: AppTextStyles.labelAdaptive(wc).copyWith(
                      color: AppColors.onSurface.withValues(alpha: 0.3),
                      fontVariations: const [FontVariation('wght', 500)],
                    ),
                  ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 36,
            child: Text(
              '${score.puzzleSize}\u00d7${score.puzzleSize}',
              style: AppTextStyles.bodyAdaptive(wc).copyWith(
                color: AppColors.onSurface.withValues(alpha: 0.8),
                fontVariations: const [FontVariation('wght', 500)],
              ),
            ),
          ),
          const Spacer(),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.schedule,
                  size: 11, color: AppColors.onSurface.withValues(alpha: 0.4)),
              const SizedBox(width: 3),
              Text(
                DurationHelper.toFormattedTime(
                    Duration(seconds: score.secondsElapsed)),
                style: AppTextStyles.labelAdaptive(wc).copyWith(
                  color: AppColors.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.swap_vert,
                  size: 11, color: AppColors.onSurface.withValues(alpha: 0.4)),
              const SizedBox(width: 3),
              Text(
                '${score.movesCount}',
                style: AppTextStyles.labelAdaptive(wc).copyWith(
                  color: AppColors.onSurface.withValues(alpha: 0.7),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color get _medalColor {
    if (score.movesCount <= 30) return const Color(0xffb8860b);
    if (score.movesCount <= 60) return const Color(0xff595959);
    return AppColors.onSurface.withValues(alpha: 0.5);
  }
}
