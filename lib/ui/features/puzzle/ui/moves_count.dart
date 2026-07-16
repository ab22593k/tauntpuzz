import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafy/helpers/localizations_ext.dart';
import 'package:leafy/ui/core/app_text_styles.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_notifier.dart';
import 'package:flutter/material.dart';

class MovesCount extends ConsumerWidget {
  const MovesCount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final movesCount = ref.watch(puzzleProvider.select((s) => s.movesCount));

    return RichText(
      text: TextSpan(
        text: '${context.l10n.moves}: ',
        style: AppTextStyles.labelMedium.copyWith(color: colorScheme.onSurface),
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
    );
  }
}
