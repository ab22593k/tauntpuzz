import 'package:leafy/domain/models/game_mode.dart';
import 'package:leafy/domain/models/puzzle.dart';
import 'package:leafy/helpers/localizations_ext.dart';
import 'package:leafy/ui/features/drawer/game_mode_item.dart';
import 'package:leafy/ui/core/layout/spacing.dart';
import 'package:leafy/ui/core/layout/screen_type_helper.dart';
import 'package:leafy/ui/core/app_text_styles.dart';
import 'package:leafy/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class GameModeSettings extends StatelessWidget {
  const GameModeSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final colorScheme = Theme.of(context).colorScheme;
    final double drawerStartPadding = padding.left == 0
        ? Spacing.md
        : padding.left;

    return Container(
      padding: EdgeInsets.only(
        right: Spacing.md,
        left: drawerStartPadding,
        top: Spacing.sm,
        bottom: Spacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              HugeIcon(
                icon: HugeIcons.strokeRoundedGameController01,
                size: 16,
                color: colorScheme.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(
                context.l10n.gameMode,
                style: AppTextStyles.titleAdaptive(wc),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.chooseMode,
            style: AppTextStyles.bodyAdaptive(
              wc,
            ).copyWith(color: colorScheme.onSurface.withValues(alpha: 0.5)),
          ),
          const SizedBox(height: 10),
          Column(
            children: [
              for (final mode in GameMode.values) GameModeItem(mode: mode),
            ],
          ),
          const _MarathonRangeSelector(),
        ],
      ),
    );
  }
}

class _MarathonRangeSelector extends StatelessWidget {
  const _MarathonRangeSelector();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final sizes = Puzzle.supportedPuzzleSizes;

    return Consumer<PuzzleProvider>(
      builder: (context, puzzleProvider, _) {
        if (puzzleProvider.gameMode != GameMode.marathon) {
          return const SizedBox.shrink();
        }

        int startSize = puzzleProvider.marathonStartSize ?? sizes.first;
        int endSize = puzzleProvider.marathonEndSize ?? sizes.last;

        return Padding(
          padding: const EdgeInsets.only(top: 8),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.zero,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  context.l10n.range,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: _SizeDropdown(
                        label: context.l10n.from,
                        value: startSize,
                        sizes: sizes,
                        onChanged: (v) {
                          if (v > endSize) return;
                          puzzleProvider.setMarathonRange(v, endSize);
                          if (puzzleProvider.n < v ||
                              puzzleProvider.n > endSize) {
                            puzzleProvider.resetPuzzleSize(v);
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedArrowRight01,
                        size: 16,
                        color: colorScheme.onSurface.withValues(alpha: 0.4),
                      ),
                    ),
                    Expanded(
                      child: _SizeDropdown(
                        label: context.l10n.to,
                        value: endSize,
                        sizes: sizes,
                        onChanged: (v) {
                          if (v < startSize) return;
                          puzzleProvider.setMarathonRange(startSize, v);
                          if (puzzleProvider.n < startSize ||
                              puzzleProvider.n > v) {
                            puzzleProvider.resetPuzzleSize(startSize);
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _SizeDropdown extends StatelessWidget {
  final String label;
  final int value;
  final List<int> sizes;
  final ValueChanged<int> onChanged;

  const _SizeDropdown({
    required this.label,
    required this.value,
    required this.sizes,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    const crossSymbol = '\u00d7';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyles.labelSmall.copyWith(
            color: colorScheme.onSurface.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 4),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          decoration: const BoxDecoration(borderRadius: BorderRadius.zero),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: value,
              isExpanded: true,
              dropdownColor: colorScheme.surfaceContainer,
              style: AppTextStyles.labelLarge.copyWith(
                color: colorScheme.onSurface,
              ),
              items: sizes.map((s) {
                return DropdownMenuItem(
                  value: s,
                  child: Text('$s$crossSymbol$s'),
                );
              }).toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}
