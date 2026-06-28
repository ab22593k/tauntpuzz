import 'package:jigsaw/ui/core/layout/phrase_bubble_layout.dart';
import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/features/phrases/view_models/phrases_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PuzzleSizeItem extends StatelessWidget {
  final int size;

  const PuzzleSizeItem({required this.size, super.key});

  @override
  Widget build(BuildContext context) {
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;
    final colorScheme = Theme.of(context).colorScheme;
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
                key: ValueKey('puzzle_size_$size'),
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
                    borderRadius: BorderRadius.zero,
                    side: BorderSide(
                      width: isSelected ? 2 : 1,
                      color: isSelected
                          ? colorScheme.primary
                          : colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  ),
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor:
                      isSelected ? colorScheme.primary : Colors.transparent,
                  elevation: 0,
                ).copyWith(
                  elevation: WidgetStateProperty.resolveWith((states) {
                    return 0;
                  }),
                  shadowColor: WidgetStateProperty.all(Colors.transparent),
                ),
                child: Text(
                  '$size\u00d7$size',
                  style: AppTextStyles.labelLarge.copyWith(
                    color: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
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
                color: colorScheme.onSurface.withValues(alpha: 0.4),
              ),
            ),
          ],
        );
      },
    );
  }
}
