import 'package:tauntpuzz/ui/core/layout/phrase_bubble_layout.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:tauntpuzz/ui/features/phrases/view_models/phrases_provider.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleSizeItem extends StatelessWidget {
  final int size;

  const PuzzleSizeItem({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;
    StopWatchProvider stopWatchProvider =
        Provider.of<StopWatchProvider>(context, listen: false);
    PhrasesProvider phrasesProvider =
        Provider.of<PhrasesProvider>(context, listen: false);

    return Consumer<PuzzleProvider>(
      builder: (c, puzzleProvider, _) {
        bool isSelected = puzzleProvider.n == size;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              child: ElevatedButton(
                onPressed: () {
                  if (!isSelected) {
                    puzzleProvider.resetPuzzleSize(size);
                    stopWatchProvider.stop();
                    if (size > 4) {
                      phrasesProvider
                          .setPhraseState(PhraseState.hardPuzzleSelected);
                    }
                    if (Scaffold.of(context).hasDrawer &&
                        Scaffold.of(context).isDrawerOpen) {
                      Navigator.of(context).pop();
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                    side: BorderSide(
                      width: isSelected ? 2 : 1,
                      color: isSelected
                          ? AppColors.stellarWhite
                          : AppColors.stellarWhite.withValues(alpha: 0.3),
                    ),
                  ),
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor:
                      isSelected ? AppColors.stellarWhite : Colors.transparent,
                  elevation: 0,
                ).copyWith(
                  elevation: WidgetStateProperty.resolveWith((states) {
                    if (isSelected) return 4;
                    if (states.contains(WidgetState.hovered)) return 3;
                    if (states.contains(WidgetState.pressed)) return 6;
                    return 0;
                  }),
                  shadowColor: WidgetStateProperty.all(
                    AppColors.nebulaPurple.withValues(alpha: 0.4),
                  ),
                ),
                child: Text(
                  '$size\u00d7$size',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? AppColors.primaryContainer
                        : AppColors.stellarWhite,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w400,
                    fontVariations: [
                      FontVariation(
                          'wght',
                          isSelected
                              ? (wc == WindowClass.expanded ? 700 : 650)
                              : 550),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(size * size) - 1}',
              style: AppTextStyles.labelAdaptive(wc).copyWith(
                color: AppColors.stellarWhite.withValues(alpha: 0.4),
              ),
            ),
          ],
        );
      },
    );
  }
}
