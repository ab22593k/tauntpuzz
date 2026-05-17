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
        // Speedrun countdown display
        if (stopWatchProvider.isCountDown) {
          final remaining = stopWatchProvider.countdownRemaining;
          final isCritical = remaining <= 10 && remaining > 0;
          final isExpired = remaining <= 0;

          return Row(
            children: [
              HugeIcon(
                icon: isExpired
                    ? HugeIcons.strokeRoundedStopWatch
                    : HugeIcons.strokeRoundedTimer01,
                size: 16,
                color: isCritical
                    ? colorScheme.error
                    : isExpired
                        ? colorScheme.onSurface.withValues(alpha: 0.4)
                        : colorScheme.onSurface,
              ),
              const SizedBox(width: 4),
              Text(
                DurationHelper.toFormattedTime(Duration(seconds: remaining)),
                style: AppTextStyles.titleMedium.copyWith(
                  color: isCritical ? colorScheme.error : colorScheme.onSurface,
                  fontVariations: const [FontVariation('wght', 700)],
                ),
              ),
            ],
          );
        }

        // Classic count-up display
        final duration = Duration(seconds: stopWatchProvider.secondsElapsed);

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
