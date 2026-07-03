import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/puzzle.dart';
import 'package:leafy/generated/app_localizations.dart';
import 'package:leafy/helpers/game_mode_helper.dart';
import 'package:leafy/helpers/localizations_ext.dart';
import 'package:leafy/ui/core/animations/animations_manager.dart';
import 'package:leafy/ui/core/animations/fade_in_transition.dart';
import 'package:leafy/ui/core/layout/screen_type_helper.dart';
import 'package:leafy/ui/features/puzzle/ui/correct_tiles_count.dart';
import 'package:leafy/ui/features/puzzle/ui/moves_count.dart';
import 'package:leafy/ui/features/puzzle/ui/puzzle_stop_watch.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:leafy/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

/// Where the header is surfaced in the adaptive layout.
///
/// Per MD3 "show and hide" strategy (Designing Interfaces Ch.4 "Responsive
/// Disclosure"): the same stats reflow between surfaces as breakpoints change.
enum HeaderDisplay {
  /// Compact stat row for the bottom toolbar (compact/medium breakpoints).
  bottomBar,

  /// Inline labeled stats for the top rail region (expanded+ breakpoints,
  /// where the bottom bar is hidden).
  topRail,

  /// Vertical stat column for the co-planar side pane (expanded+).
  /// The pane is narrow (~360dp), so stats stack vertically instead of
  /// spreading horizontally.
  sidePane,
}

class PuzzleHeader extends StatelessWidget {
  final HeaderDisplay displayMode;

  const PuzzleHeader({super.key, this.displayMode = HeaderDisplay.bottomBar});

  @override
  Widget build(BuildContext context) {
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final colorScheme = Theme.of(context).colorScheme;
    final puzzleProvider = context.watch<PuzzleProvider>();

    final l10n = context.l10n;

    if (puzzleProvider.gameMode == GameMode.marathon) {
      return FadeInTransition(
        delay: AnimationsManager.bgLayerAnimationDuration,
        child: displayMode == HeaderDisplay.sidePane
            ? _marathonPane(colorScheme, puzzleProvider, l10n)
            : _marathonHeader(colorScheme, puzzleProvider, l10n),
      );
    }

    // Adaptive surfacing: bottom bar uses compact stats on compact/medium;
    // top rail uses the labeled expanded layout where the bottom bar hides;
    // side pane uses a vertical stat column for the narrow co-planar pane.
    return FadeInTransition(
      delay: AnimationsManager.bgLayerAnimationDuration,
      child: switch (displayMode) {
        HeaderDisplay.sidePane => _sidePaneLayout(colorScheme, l10n),
        HeaderDisplay.bottomBar
            when wc == WindowClass.compact || wc == WindowClass.medium =>
          _compactLayout(colorScheme),
        _ => const SizedBox.shrink(),
      },
    );
  }

  Widget _marathonHeader(
    ColorScheme colorScheme,
    PuzzleProvider puzzleProvider,
    AppLocalizations l10n,
  ) {
    final currentSize = puzzleProvider.n;
    final endSize = puzzleProvider.marathonEndSize ?? currentSize;
    final sizes = Puzzle.supportedPuzzleSizes;
    final currentIdx = sizes.indexOf(currentSize);
    final endIdx = sizes.indexOf(endSize);

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        HugeIcon(
          icon: HugeIcons.strokeRoundedLink01,
          size: 16,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        const SizedBox(width: 6),
        Text(
          GameModeHelper.localizedName(GameMode.marathon, l10n),
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.6),
            fontVariations: const [FontVariation('wght', 600)],
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '\u2022',
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ),
        const SizedBox(width: 4),
        ...List.generate(endIdx + 1, (i) {
          final size = sizes[i];
          final isDone = i < currentIdx;
          final isCurrent = i == currentIdx;
          return Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (i > 0)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Text(
                    '\u2192',
                    style: AppTextStyles.labelSmall.copyWith(
                      color: colorScheme.onSurface.withValues(alpha: 0.2),
                    ),
                  ),
                ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: isCurrent
                      ? colorScheme.primary.withValues(alpha: 0.15)
                      : isDone
                      ? colorScheme.tertiary.withValues(alpha: 0.15)
                      : Colors.transparent,
                  border: isCurrent
                      ? Border.all(
                          color: colorScheme.primary.withValues(alpha: 0.3),
                        )
                      : null,
                ),
                child: Text(
                  '$size\u00d7$size',
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isDone
                        ? colorScheme.tertiary
                        : isCurrent
                        ? colorScheme.primary
                        : colorScheme.onSurface.withValues(alpha: 0.3),
                    fontVariations: [const FontVariation('wght', 700)],
                  ),
                ),
              ),
            ],
          );
        }),
      ],
    );
  }

  /// Marathon progress for the narrow side pane — wraps chips vertically
  /// and shows just the linked-mode indicator + a compact progress column.
  Widget _marathonPane(
    ColorScheme colorScheme,
    PuzzleProvider puzzleProvider,
    AppLocalizations l10n,
  ) {
    final currentSize = puzzleProvider.n;
    final endSize = puzzleProvider.marathonEndSize ?? currentSize;
    final sizes = Puzzle.supportedPuzzleSizes;
    final currentIdx = sizes.indexOf(currentSize);
    final endIdx = sizes.indexOf(endSize);

    return Wrap(
      spacing: 4,
      runSpacing: 6,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            HugeIcon(
              icon: HugeIcons.strokeRoundedLink01,
              size: 16,
              color: colorScheme.onSurface.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 6),
            Text(
              GameModeHelper.localizedName(GameMode.marathon, l10n),
              style: AppTextStyles.labelSmall.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.6),
                fontVariations: const [FontVariation('wght', 600)],
              ),
            ),
          ],
        ),
        ...List.generate(endIdx + 1, (i) {
          final size = sizes[i];
          final isDone = i < currentIdx;
          final isCurrent = i == currentIdx;
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
            decoration: BoxDecoration(
              color: isCurrent
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : isDone
                  ? colorScheme.tertiary.withValues(alpha: 0.15)
                  : Colors.transparent,
              border: isCurrent
                  ? Border.all(
                      color: colorScheme.primary.withValues(alpha: 0.3),
                    )
                  : null,
            ),
            child: Text(
              '$size\u00d7$size',
              style: AppTextStyles.labelSmall.copyWith(
                color: isDone
                    ? colorScheme.tertiary
                    : isCurrent
                    ? colorScheme.primary
                    : colorScheme.onSurface.withValues(alpha: 0.3),
                fontVariations: [const FontVariation('wght', 700)],
              ),
            ),
          );
        }),
      ],
    );
  }

  Widget _compactLayout(ColorScheme colorScheme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const PuzzleStopWatch(),
        _statChip(
          HugeIcon(
            icon: HugeIcons.strokeRoundedArrowUpDown,
            size: 14,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          const MovesCount(),
          colorScheme,
        ),
        CorrectTilesCount(colorScheme: colorScheme),
      ],
    );
  }

  /// Vertical stat column for the narrow co-planar side pane (~360dp).
  ///
  /// Each stat is a single row (icon + label + value). Stacks vertically
  /// instead of the horizontal spread used in [_expandedLayout].
  Widget _sidePaneLayout(ColorScheme colorScheme, AppLocalizations l10n) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _labeledStatRow(
          icon: const HugeIcon(icon: HugeIcons.strokeRoundedClock01, size: 16),
          label: l10n.time,
          child: const PuzzleStopWatch(showIcon: false),
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _labeledStatRow(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedArrowUpDown,
            size: 16,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          label: l10n.moves,
          child: const MovesCount(),
          colorScheme: colorScheme,
        ),
        const SizedBox(height: 16),
        _labeledStatRow(
          icon: HugeIcon(
            icon: HugeIcons.strokeRoundedCheckmarkCircle01,
            size: 16,
            color: colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          label: l10n.correct,
          child: CorrectTilesCount(colorScheme: colorScheme, showIcon: false),
          colorScheme: colorScheme,
        ),
      ],
    );
  }

  /// A single horizontal row for a labeled stat in the side pane.
  Widget _labeledStatRow({
    required Widget icon,
    required String label,
    required Widget child,
    required ColorScheme colorScheme,
  }) {
    return Row(
      children: [
        icon,
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.labelSmall.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.5),
                  fontVariations: const [FontVariation('wght', 600)],
                ),
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 1),
              DefaultTextStyle(
                style: AppTextStyles.titleMedium.copyWith(
                  color: colorScheme.onSurface,
                  fontVariations: const [FontVariation('wght', 700)],
                ),
                child: child,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _statChip(Widget iconWidget, Widget text, ColorScheme colorScheme) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget,
        const SizedBox(width: 4),
        DefaultTextStyle(
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurface,
          ),
          child: text,
        ),
      ],
    );
  }
}
