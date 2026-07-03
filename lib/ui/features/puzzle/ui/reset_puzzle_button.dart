import 'package:leafy/helpers/localizations_ext.dart';
import 'package:leafy/ui/core/animations/animations_manager.dart';
import 'package:leafy/ui/core/animations/fade_in_transition.dart';
import 'package:leafy/ui/core/dialogs/app_alert_dialog.dart';
import 'package:leafy/ui/core/app_text_styles.dart';
import 'package:leafy/ui/core/layout/screen_type_helper.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:leafy/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

/// MD3 presentation-change adaptation:
/// - Compact/medium: renders as a compact app-bar action (icon-only FAB).
/// - Expanded+: renders as an extended FAB with icon + label.
///
/// Per MD3: "when a window size increases, a FAB can change to an extended
/// FAB." The same action, repositioned and resized for the breakpoint.
class ResetPuzzleButton extends StatelessWidget {
  const ResetPuzzleButton({super.key});

  void initResetPuzzle(
    BuildContext context,
    PuzzleProvider puzzleProvider,
    StopWatchProvider stopWatchProvider,
  ) {
    if (puzzleProvider.hasStarted && !puzzleProvider.puzzle.isSolved) {
      showDialog(
        context: context,
        builder: (context) {
          return AppAlertDialog(
            title: context.l10n.resetConfirm,
            onConfirm: () {
              stopWatchProvider.stop();
              puzzleProvider.generate(forceRefresh: true);
            },
          );
        },
      );
    } else {
      stopWatchProvider.stop();
      puzzleProvider.generate(forceRefresh: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final stopWatchProvider = Provider.of<StopWatchProvider>(
      context,
      listen: false,
    );
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final isExpandedPlus =
        wc == WindowClass.expanded ||
        wc == WindowClass.large ||
        wc == WindowClass.extraLarge;

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Consumer<PuzzleProvider>(
        builder: (c, puzzleProvider, _) {
          final colorScheme = Theme.of(c).colorScheme;

          if (isExpandedPlus) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 200),
                child: FloatingActionButton.extended(
                  key: const ValueKey('reset_button'),
                  onPressed: () => initResetPuzzle(
                    context,
                    puzzleProvider,
                    stopWatchProvider,
                  ),
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedRefresh03,
                    size: 18,
                  ),
                  label: Text(context.l10n.reset, style: AppTextStyles.button),
                ),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Tooltip(
              message: context.l10n.reset,
              child: FloatingActionButton.small(
                key: const ValueKey('reset_button'),
                onPressed: () =>
                    initResetPuzzle(context, puzzleProvider, stopWatchProvider),
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
          );
        },
      ),
    );
  }
}
