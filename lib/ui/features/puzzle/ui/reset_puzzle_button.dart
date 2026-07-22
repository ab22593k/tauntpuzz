import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafz/helpers/localizations_ext.dart';
import 'package:leafz/ui/core/animations/animations_manager.dart';
import 'package:leafz/ui/core/animations/fade_in_transition.dart';
import 'package:leafz/ui/core/dialogs/app_alert_dialog.dart';
import 'package:leafz/ui/core/app_text_styles.dart';
import 'package:leafz/ui/core/layout/screen_type_helper.dart';
import 'package:leafz/ui/features/puzzle/view_models/puzzle_notifier.dart';
import 'package:leafz/ui/features/puzzle/view_models/stop_watch_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class ResetPuzzleButton extends ConsumerWidget {
  const ResetPuzzleButton({super.key});

  void initResetPuzzle(BuildContext context, WidgetRef ref) {
    final puzzle = ref.read(puzzleProvider);
    if (puzzle.hasStarted && !puzzle.puzzle.isSolved) {
      showDialog(
        context: context,
        builder: (context) {
          return AppAlertDialog(
            title: context.l10n.resetConfirm,
            onConfirm: () {
              ref.read(stopWatchProvider.notifier).stop();
              ref.read(puzzleProvider.notifier).generate(forceRefresh: true);
            },
          );
        },
      );
    } else {
      ref.read(stopWatchProvider.notifier).stop();
      ref.read(puzzleProvider.notifier).generate(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final isExpandedPlus =
        wc == WindowClass.expanded ||
        wc == WindowClass.large ||
        wc == WindowClass.extraLarge;
    final colorScheme = Theme.of(context).colorScheme;
    ref.watch(puzzleProvider); // trigger rebuild on state changes

    if (isExpandedPlus) {
      return FadeInTransition(
        delay: AnimationsManager.bgLayerAnimationDuration,
        child: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 200),
            child: FloatingActionButton.extended(
              key: const ValueKey('reset_button'),
              onPressed: () => initResetPuzzle(context, ref),
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.zero,
              ),
              label: Text(context.l10n.reset, style: AppTextStyles.button),
            ),
          ),
        ),
      );
    }

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Tooltip(
          message: context.l10n.reset,
          child: FloatingActionButton.small(
            key: const ValueKey('reset_button'),
            onPressed: () => initResetPuzzle(context, ref),
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.zero,
            ),
            child: const HugeIcon(
              icon: HugeIcons.strokeRoundedRefresh03,
              size: 18,
            ),
          ),
        ),
      ),
    );
  }
}
