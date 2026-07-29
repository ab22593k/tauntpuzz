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
      final text = DurationHelper.toFormattedTime(Duration(seconds: remaining));
      final textColor = isCritical ? colorScheme.error : colorScheme.onSurface;
      final iconColor = isCritical
          ? colorScheme.error
          : isExpired
          ? colorScheme.onSurface.withValues(alpha: 0.4)
          : colorScheme.onSurface;

      return _timerDisplay(
        icon: HugeIcon(
          icon: isExpired
              ? HugeIcons.strokeRoundedStopWatch
              : HugeIcons.strokeRoundedTimer01,
          size: 16,
          color: iconColor,
        ),
        text: text,
        textColor: textColor,
      );
    }

    final text = DurationHelper.toFormattedTime(
      Duration(seconds: sw.secondsElapsed),
    );
    return _timerDisplay(
      icon: const HugeIcon(icon: HugeIcons.strokeRoundedClock01, size: 16),
      text: text,
      textColor: colorScheme.onSurface,
    );
  }

  Widget _timerDisplay({
    required Widget icon,
    required String text,
    required Color textColor,
  }) {
    if (!showIcon) return _textWidget(text, textColor);
    return Row(
      children: [icon, const SizedBox(width: 4), _textWidget(text, textColor)],
    );
  }
}
