import 'dart:io';

import 'package:jigsaw/helpers/duration_helper.dart';
import 'package:jigsaw/helpers/file_helper.dart';
import 'package:jigsaw/helpers/localizations_ext.dart';
import 'package:jigsaw/helpers/share_score_helper.dart';
import 'package:jigsaw/ui/core/layout/spacing.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:share_plus/share_plus.dart';

class PuzzleScore extends StatelessWidget {
  final Duration duration;
  final int movesCount;
  final int puzzleSize;

  const PuzzleScore({
    super.key,
    required this.duration,
    required this.movesCount,
    required this.puzzleSize,
  });

  int get tilesCount => (puzzleSize * puzzleSize) - 1;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(context.l10n.congratsTitle, style: AppTextStyles.displaySmall),
            const SizedBox(height: Spacing.xs),
            Text(
              context.l10n.congratsSubtitle,
              style: TextStyle(
                color: colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            const SizedBox(height: Spacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      const HugeIcon(icon: HugeIcons.strokeRoundedClock01),
                      const SizedBox(width: 5),
                      Text(
                        DurationHelper.toFormattedTime(duration),
                        style: AppTextStyles.h1Bold,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    context.l10n.movesCountLabel(movesCount),
                    style: AppTextStyles.h1Bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: Spacing.md),
          ],
        ),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () => Navigator.of(context).pop(),
                label: Text(context.l10n.restart),
                icon: const HugeIcon(icon: HugeIcons.strokeRoundedRefresh01),
              ),
            ),
            const SizedBox(width: Spacing.sm),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: () async {
                  try {
                    if (kIsWeb) {
                      await ShareScoreHelper.openLink(
                        ShareScoreHelper.getTwitterShareLink(
                          movesCount,
                          duration,
                          tilesCount,
                        ),
                      );
                    } else {
                      File file = await FileHelper.getFileFromUrl(
                        ShareScoreHelper.getPuzzleSolvedImageUrl(puzzleSize),
                      );
                      await SharePlus.instance.share(
                        ShareParams(
                          files: [XFile(file.path)],
                          text: ShareScoreHelper.getPuzzleSolvedTextMobile(
                            movesCount,
                            duration,
                            tilesCount,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    await ShareScoreHelper.openLink(
                      ShareScoreHelper.getTwitterShareLink(
                        movesCount,
                        duration,
                        tilesCount,
                      ),
                    );
                    rethrow;
                  }
                },
                label: Text(context.l10n.share),
                icon: kIsWeb
                    ? const FaIcon(FontAwesomeIcons.twitter)
                    : const HugeIcon(icon: HugeIcons.strokeRoundedShare01),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
