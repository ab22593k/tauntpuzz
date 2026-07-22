import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:leafz/helpers/duration_helper.dart';
import 'package:leafz/ui/core/app_text_styles.dart';
import 'package:leafz/ui/features/puzzle/view_models/stop_watch_notifier.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class PuzzleStopWatch extends ConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final colorScheme = Theme.of(context).colorScheme;
    final sw = ref.watch(stopWatchProvider);

    if (sw.isCountDown) {
      final remaining = sw.countdownRemaining;
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
                  DurationHelper.toFormattedTime(Duration(seconds: remaining)),
                  isCritical ? colorScheme.error : colorScheme.onSurface,
                ),
              ],
            )
          : _textWidget(
              DurationHelper.toFormattedTime(Duration(seconds: remaining)),
              isCritical ? colorScheme.error : colorScheme.onSurface,
            );
    }

    final duration = Duration(seconds: sw.secondsElapsed);
    return showIcon
        ? Row(
            children: [
              const HugeIcon(icon: HugeIcons.strokeRoundedClock01, size: 16),
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
  }
}
