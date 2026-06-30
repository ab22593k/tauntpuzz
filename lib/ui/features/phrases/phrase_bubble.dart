import 'package:jigsaw/helpers/localizations_ext.dart';
import 'package:jigsaw/ui/core/layout/phrase_bubble_layout.dart';
import 'package:jigsaw/ui/core/layout/spacing.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/features/phrases/view_models/phrases_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PhraseBubble extends StatelessWidget {
  final PhraseState state;

  const PhraseBubble({super.key, required this.state})
    : assert(state != PhraseState.none);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Stack(
      clipBehavior: Clip.none,
      children: [
        Positioned(
          right: -12,
          top: -4,
          child: Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: -21,
          top: -8,
          child: Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Positioned(
          right: -28,
          top: -11,
          child: Container(
            width: 4,
            height: 4,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: Spacing.md,
            vertical: Spacing.sm,
          ),
          constraints: const BoxConstraints(maxWidth: 180),
          decoration: BoxDecoration(
            color: colorScheme.primary,
            borderRadius: BorderRadius.zero,
            boxShadow: [
              BoxShadow(
                color: colorScheme.primary.withValues(alpha: 0.15),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Consumer<PhrasesProvider>(
            builder: (c, phrasesProvider, _) {
              String phrase = phrasesProvider.getPhrase(state, c.l10n);

              return Text(
                phrase,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.h2.copyWith(
                  color: colorScheme.onPrimary,
                  fontWeight: FontWeight.w700,
                  fontSize: phrase.length > 20 ? 16 : 20,
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
