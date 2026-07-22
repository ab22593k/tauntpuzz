import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafz/helpers/localizations_ext.dart';
import 'package:leafz/ui/core/layout/phrase_bubble_layout.dart';
import 'package:leafz/ui/core/layout/spacing.dart';
import 'package:leafz/ui/core/app_text_styles.dart';
import 'package:leafz/ui/features/phrases/view_models/phrases_notifier.dart';
import 'package:flutter/material.dart';

class PhraseBubble extends ConsumerWidget {
  final PhraseState state;

  const PhraseBubble({super.key, required this.state})
    : assert(state != PhraseState.none);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final phrasesNotifier = ref.read(phrasesProvider.notifier);

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
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
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
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
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
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.zero,
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
                color: colorScheme.onSurface.withValues(alpha: 0.04),
                blurRadius: 40,
                spreadRadius: 0,
              ),
            ],
          ),
          child: ref.watch(phrasesProvider).phraseState != PhraseState.none
              ? Text(
                  phrasesNotifier.getPhrase(state, context.l10n),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.h2.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                )
              : const SizedBox.shrink(),
        ),
      ],
    );
  }
}
