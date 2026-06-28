import 'package:jigsaw/helpers/localizations_ext.dart';
import 'package:jigsaw/ui/core/animations/animations_manager.dart';
import 'package:jigsaw/ui/core/animations/fade_in_transition.dart';
import 'package:jigsaw/ui/core/dialogs/app_alert_dialog.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/stop_watch_provider.dart';
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
    final stopWatchProvider =
        Provider.of<StopWatchProvider>(context, listen: false);
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;
    final isExpandedPlus = wc == WindowClass.expanded ||
        wc == WindowClass.large ||
        wc == WindowClass.extraLarge;

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Consumer<PuzzleProvider>(
        builder: (c, puzzleProvider, _) {
          if (isExpandedPlus) {
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: FloatingActionButton.extended(
                key: const ValueKey('reset_button'),
                onPressed: () =>
                    initResetPuzzle(context, puzzleProvider, stopWatchProvider),
                icon: const HugeIcon(
                  icon: HugeIcons.strokeRoundedRefresh03,
                  size: 18,
                ),
                label: Text(context.l10n.reset, style: AppTextStyles.button),
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.only(top: 20),
            child: Tooltip(
              message: 'Reset (R)',
              child: ElevatedButton(
                key: const ValueKey('reset_button'),
                onPressed: () =>
                    initResetPuzzle(context, puzzleProvider, stopWatchProvider),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedRefresh03,
                      size: 18,
                    ),
                    const SizedBox(width: 7),
                    Text(context.l10n.reset, style: AppTextStyles.button),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
