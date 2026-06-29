import 'package:jigsaw/helpers/duration_helper.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class PuzzleStopWatch extends StatelessWidget {
  final bool showIcon;

  const PuzzleStopWatch({super.key, this.showIcon = true});

  Widget _textWidget(String text, Color color) {
    return Text(
      text,
      style: AppTextStyles.titleMedium.copyWith(
        color: color,
        fontVariations: const [FontVariation('wght', 700)],
      ),
    );
  }

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

          return showIcon
              ? Row(
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
                    _textWidget(
                      DurationHelper.toFormattedTime(
                        Duration(seconds: remaining),
                      ),
                      isCritical ? colorScheme.error : colorScheme.onSurface,
                    ),
                  ],
                )
              : _textWidget(
                  DurationHelper.toFormattedTime(Duration(seconds: remaining)),
                  isCritical ? colorScheme.error : colorScheme.onSurface,
                );
        }

        // Classic count-up display
        final duration = Duration(seconds: stopWatchProvider.secondsElapsed);

        return showIcon
            ? Row(
                children: [
                  const HugeIcon(
                    icon: HugeIcons.strokeRoundedClock01,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  _textWidget(
                    DurationHelper.toFormattedTime(duration),
                    colorScheme.onSurface,
                  ),
                ],
              )
            : _textWidget(
                DurationHelper.toFormattedTime(duration),
                colorScheme.onSurface,
              );
      },
    );
  }
}
