import 'package:tauntpuzz/domain/models/score.dart';
import 'package:tauntpuzz/ui/features/drawer/latest_score_item.dart';
import 'package:tauntpuzz/ui/core/layout/spacing.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestScores extends StatelessWidget {
  const LatestScores({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;
    final double paddingLeft = padding.left == 0 ? Spacing.md : padding.left;

    return Selector<PuzzleProvider, List<Score>>(
      selector: (c, puzzleProvider) => puzzleProvider.scores.reversed.toList(),
      builder: (c, List<Score> scores, child) => Container(
        padding: const EdgeInsets.only(top: Spacing.md, bottom: Spacing.sm),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(
                left: paddingLeft,
                right: Spacing.screenHPadding,
                bottom: Spacing.sm,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.emoji_events_outlined,
                    size: 16,
                    color: AppColors.stellarWhite.withValues(alpha: 0.6),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Latest Scores',
                    style: AppTextStyles.titleAdaptive(wc).copyWith(
                      color: AppColors.stellarWhite.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
            ),
            if (scores.isEmpty)
              _emptyState(paddingLeft, wc)
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: scores.length,
                itemBuilder: (c, i) => LatestScoreItem(
                  scores[i],
                  paddingLeft: paddingLeft,
                  rank: i + 1,
                  isBest: i == 0,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _emptyState(double paddingLeft, WindowClass wc) {
    return Container(
      margin: EdgeInsets.only(
        left: paddingLeft,
        right: Spacing.screenHPadding,
        top: Spacing.sm,
      ),
      padding: const EdgeInsets.all(Spacing.md),
      decoration: BoxDecoration(
        color: AppColors.stellarWhite.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.stellarWhite.withValues(alpha: 0.08),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            Icons.rocket_outlined,
            size: 28,
            color: AppColors.stellarWhite.withValues(alpha: 0.2),
          ),
          const SizedBox(height: 8),
          Text(
            'Solve your first puzzle!',
            style: AppTextStyles.bodyAdaptive(wc).copyWith(
              color: AppColors.stellarWhite.withValues(alpha: 0.4),
              fontVariations: const [FontVariation('wght', 380)],
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'Scores will appear here',
            style: AppTextStyles.bodyAdaptive(wc).copyWith(
              color: AppColors.stellarWhite.withValues(alpha: 0.25),
              fontVariations: const [FontVariation('wght', 360)],
            ),
          ),
        ],
      ),
    );
  }
}
