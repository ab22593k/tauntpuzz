import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MovesCount extends StatelessWidget {
  const MovesCount({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Selector<PuzzleProvider, int>(
      selector: (c, puzzleProvider) => puzzleProvider.movesCount,
      builder: (c, int movesCount, _) => RichText(
        text: TextSpan(
          text: 'Moves: ',
          style:
              AppTextStyles.labelMedium.copyWith(color: colorScheme.onSurface),
          children: <TextSpan>[
            TextSpan(
              text: '$movesCount',
              style: AppTextStyles.labelMedium.copyWith(
                color: colorScheme.onSurface,
                fontVariations: const [FontVariation('wght', 700)],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
