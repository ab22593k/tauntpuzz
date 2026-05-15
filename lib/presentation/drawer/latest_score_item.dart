import 'package:dashtronaut/helpers/duration_helper.dart';
import 'package:dashtronaut/models/score.dart';
import 'package:dashtronaut/presentation/layout/spacing.dart';
import 'package:flutter/material.dart';

class LatestScoreItem extends StatelessWidget {
  final Score score;
  final double paddingLeft;

  const LatestScoreItem(this.score, {super.key, required this.paddingLeft});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: paddingLeft,
        right: Spacing.screenHPadding,
        top: Spacing.sm,
        bottom: Spacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
            bottom: BorderSide(
                color: Colors.white.withValues(alpha: 0.5), width: 0.5)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text('${score.puzzleSize}x${score.puzzleSize}'),
          ),
          Expanded(
            child: Text(DurationHelper.toFormattedTime(
                Duration(seconds: score.secondsElapsed))),
          ),
          Expanded(
            child: Text('${score.movesCount} Moves'),
          ),
        ],
      ),
    );
  }
}
