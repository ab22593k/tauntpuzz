import 'package:lullaby/helpers/localizations_ext.dart';
import 'package:lullaby/ui/core/animations/animations_manager.dart';
import 'package:lullaby/ui/core/animations/fade_in_transition.dart';
import 'package:lullaby/ui/core/dialogs/app_alert_dialog.dart';
import 'package:lullaby/ui/core/app_text_styles.dart';
import 'package:lullaby/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:lullaby/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

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
    StopWatchProvider stopWatchProvider =
        Provider.of<StopWatchProvider>(context, listen: false);

    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: Consumer<PuzzleProvider>(
        builder: (c, puzzleProvider, _) => Padding(
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
        ),
      ),
    );
  }
}
