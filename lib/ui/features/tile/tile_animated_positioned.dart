import 'package:leafz/domain/models/tile.dart';
import 'package:leafz/ui/core/animations/animations_manager.dart';
import 'package:flutter/material.dart';

class TileAnimatedPositioned extends StatelessWidget {
  final Tile tile;
  final int puzzleSize;
  final Widget tileGestureDetector;
  final double tileWidth;

  const TileAnimatedPositioned({
    super.key,
    required this.tile,
    required this.puzzleSize,
    required this.tileGestureDetector,
    required this.tileWidth,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedPositioned(
      duration: AnimationsManager.tileMove.duration,
      curve: AnimationsManager.tileMove.curve,
      width: tileWidth,
      height: tileWidth,
      left: (tile.currentLocation.x - 1) * tileWidth,
      top: (tile.currentLocation.y - 1) * tileWidth,
      child: tileGestureDetector,
    );
  }
}
