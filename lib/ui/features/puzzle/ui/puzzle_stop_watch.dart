import 'package:tauntpuzz/helpers/duration_helper.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:tauntpuzz/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class PuzzleStopWatch extends StatelessWidget {
  const PuzzleStopWatch({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<StopWatchProvider>(
      builder: (c, stopWatchProvider, _) {
        Duration duration = Duration(seconds: stopWatchProvider.secondsElapsed);

        return Row(
          children: [
            const HugeIcon(icon: HugeIcons.strokeRoundedClock01, size: 16),
            const SizedBox(width: 4),
            Text(
              DurationHelper.toFormattedTime(duration),
              style: AppTextStyles.titleMedium.copyWith(
                color: colorScheme.onSurface,
                fontVariations: const [FontVariation('wght', 700)],
              ),
            ),
          ],
        );
      },
    );
  }
}
