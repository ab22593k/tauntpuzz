import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafy/ui/core/layout/phrase_bubble_layout.dart';
import 'package:leafy/ui/core/layout/screen_type_helper.dart';
import 'package:leafy/ui/core/app_text_styles.dart';
import 'package:leafy/ui/features/phrases/view_models/phrases_notifier.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_notifier.dart';
import 'package:leafy/ui/features/puzzle/view_models/stop_watch_notifier.dart';
import 'package:flutter/material.dart';

class PuzzleSizeItem extends ConsumerWidget {
  final int size;

  const PuzzleSizeItem({required this.size, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final colorScheme = Theme.of(context).colorScheme;
    final puzzleN = ref.watch(puzzleProvider.select((s) => s.n));
    final isSelected = puzzleN == size;

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
                ref.read(puzzleProvider.notifier).resetPuzzleSize(size);
                ref.read(stopWatchProvider.notifier).stop();
                if (size > 4) {
                  ref
                      .read(phrasesProvider.notifier)
                      .setPhraseState(PhraseState.hardPuzzleSelected);
                }
                Navigator.of(context).pop();
              }
            },
            style:
                ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: isSelected
                      ? colorScheme.primary
                      : Colors.transparent,
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
                    isSelected ? (wc == WindowClass.expanded ? 700 : 650) : 550,
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${(size * size) - 1}',
          style: AppTextStyles.labelAdaptive(
            wc,
          ).copyWith(color: colorScheme.onSurface.withValues(alpha: 0.4)),
        ),
      ],
    );
  }
}
