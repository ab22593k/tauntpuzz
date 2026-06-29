import 'package:jigsaw/domain/models/game_mode.dart';
import 'package:jigsaw/helpers/game_mode_helper.dart';
import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/puzzle_provider.dart';
import 'package:jigsaw/ui/features/puzzle/view_models/stop_watch_provider.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:provider/provider.dart';

class GameModeItem extends StatelessWidget {
  final GameMode mode;

  const GameModeItem({required this.mode, super.key});

  @override
  Widget build(BuildContext context) {
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final colorScheme = Theme.of(context).colorScheme;

    return Consumer<PuzzleProvider>(
      builder: (context, puzzleProvider, _) {
        final isSelected = puzzleProvider.gameMode == mode;
        final isLocked = puzzleProvider.isModeLocked && !isSelected;

        return Padding(
          padding: const EdgeInsets.only(bottom: 6),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              key: ValueKey('game_mode_${mode.name}'),
              onPressed: isLocked
                  ? null
                  : () {
                      if (!isSelected) {
                        final stopWatch = Provider.of<StopWatchProvider>(
                          context,
                          listen: false,
                        );
                        stopWatch.stop();
                        puzzleProvider.setGameMode(mode);
                        if (Scaffold.of(context).hasDrawer &&
                            Scaffold.of(context).isDrawerOpen) {
                          Navigator.of(context).pop();
                        }
                      }
                    },
              style:
                  ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero,
                      side: BorderSide(
                        width: isSelected ? 2 : 1,
                        color: isSelected
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                    minimumSize: const Size.fromHeight(48),
                    backgroundColor: isSelected
                        ? colorScheme.primary
                        : Colors.transparent,
                    foregroundColor: isSelected
                        ? colorScheme.onPrimary
                        : colorScheme.onSurface,
                    elevation: 0,
                  ).copyWith(
                    elevation: WidgetStateProperty.resolveWith((_) => 0),
                    shadowColor: WidgetStateProperty.all(Colors.transparent),
                    overlayColor: WidgetStateProperty.resolveWith((states) {
                      if (states.contains(WidgetState.hovered)) {
                        return (isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface)
                            .withValues(alpha: 0.08);
                      }
                      return null;
                    }),
                  ),
              child: Row(
                children: [
                  _modeIcon(isSelected, colorScheme),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          GameModeHelper.displayName(mode),
                          style: AppTextStyles.labelLarge.copyWith(
                            color: isSelected
                                ? colorScheme.onPrimary
                                : colorScheme.onSurface,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.w500,
                            fontVariations: [
                              FontVariation('wght', isSelected ? 700 : 550),
                            ],
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          GameModeHelper.description(mode),
                          style: AppTextStyles.bodyAdaptive(wc).copyWith(
                            color: isSelected
                                ? colorScheme.onPrimary.withValues(alpha: 0.7)
                                : colorScheme.onSurface.withValues(alpha: 0.45),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: HugeIcon(
                        icon: HugeIcons.strokeRoundedCheckmarkCircle01,
                        size: 16,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _modeIcon(bool isSelected, ColorScheme colorScheme) {
    final color = isSelected
        ? colorScheme.onPrimary
        : colorScheme.onSurface.withValues(alpha: 0.6);

    return switch (mode) {
      GameMode.classic => HugeIcon(
        icon: HugeIcons.strokeRoundedPuzzle,
        size: 20,
        color: color,
      ),
      GameMode.speedrun => HugeIcon(
        icon: HugeIcons.strokeRoundedTimer01,
        size: 20,
        color: color,
      ),
      GameMode.blind => HugeIcon(
        icon: HugeIcons.strokeRoundedEye,
        size: 20,
        color: color,
      ),
      GameMode.marathon => HugeIcon(
        icon: HugeIcons.strokeRoundedLink01,
        size: 20,
        color: color,
      ),
    };
  }
}
