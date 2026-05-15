import 'package:tauntpuzz/domain/models/puzzle.dart';
import 'package:tauntpuzz/ui/features/drawer/puzzle_size_item.dart';
import 'package:tauntpuzz/ui/core/layout/spacing.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class PuzzleSizeSettings extends StatelessWidget {
  const PuzzleSizeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;
    double drawerStartPadding = padding.left == 0 ? Spacing.md : padding.left;

    return Container(
      padding: EdgeInsets.only(
        right: Spacing.md,
        left: drawerStartPadding,
        top: Spacing.md,
        bottom: Spacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x26C6C6C6),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.grid_view_rounded,
                size: 16,
                color: AppColors.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text('Puzzle Size', style: AppTextStyles.titleAdaptive(wc)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'Choose your grid',
            style: AppTextStyles.bodyAdaptive(wc).copyWith(
              color: AppColors.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: AppColors.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.zero,
            ),
            child: Text(
              'Resets progress',
              style: AppTextStyles.labelAdaptive(wc).copyWith(
                color: AppColors.error.withValues(alpha: 0.8),
                fontStyle: FontStyle.italic,
                fontVariations: const [FontVariation('wght', 600)],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: List.generate(
              Puzzle.supportedPuzzleSizes.length,
              (index) => Expanded(
                child: Padding(
                  padding: EdgeInsetsDirectional.only(
                    end: index < Puzzle.supportedPuzzleSizes.length - 1
                        ? Spacing.xs / 2
                        : 0,
                    start: index > 0 ? Spacing.xs / 2 : 0,
                  ),
                  child: PuzzleSizeItem(
                    size: Puzzle.supportedPuzzleSizes[index],
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
