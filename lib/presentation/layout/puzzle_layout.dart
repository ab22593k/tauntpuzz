import 'dart:io';

import 'package:dashtronaut/presentation/drawer/drawer_button.dart';
import 'package:dashtronaut/presentation/layout/layout_delegate.dart';
import 'package:dashtronaut/presentation/layout/screen_type_helper.dart';
import 'package:dashtronaut/presentation/layout/spacing.dart';
import 'package:dashtronaut/presentation/puzzle/ui/puzzle_header.dart';
import 'package:dashtronaut/presentation/puzzle/ui/reset_puzzle_button.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' hide DrawerButton;

class PuzzleLayout implements LayoutDelegate {
  @override
  final ScreenTypeHelper screenTypeHelper;
  final double screenWidth;
  final double screenHeight;
  final double paddingLeft;
  final double paddingTop;
  final bool isWideLayout;

  PuzzleLayout({
    required this.screenTypeHelper,
    required this.screenWidth,
    required this.screenHeight,
    required this.paddingLeft,
    required this.paddingTop,
  }) : isWideLayout = screenTypeHelper.isWideLayout;

  double get containerWidth {
    switch (screenTypeHelper.type) {
      case ScreenType.xSmall:
      case ScreenType.small:
        return screenWidth - Spacing.screenHPadding * 2;
      case ScreenType.medium:
        if (isWideLayout) {
          return screenHeight - Spacing.screenHPadding * 2;
        } else {
          return 500;
        }
      case ScreenType.large:
        return 500;
    }
  }

  double get distanceOutsidePuzzle {
    double effectiveHeight = isWideLayout ? screenWidth : screenHeight;
    return ((effectiveHeight - containerWidth) / 2) + containerWidth;
  }

  static const double tilePadding = 4;

  static double? tileTextSize(int puzzleSize) {
    return puzzleSize > 5
        ? 20
        : puzzleSize > 4
            ? 25
            : puzzleSize > 3
                ? 30
                : null;
  }

  List<Widget> get horizontalPuzzleUIElements {
    return [
      Positioned(
        width: distanceOutsidePuzzle -
            containerWidth -
            paddingLeft -
            (!kIsWeb && Platform.isAndroid ? Spacing.md : 0),
        top: !kIsWeb && Platform.isAndroid
            ? paddingTop + Spacing.md
            : paddingTop,
        left: !kIsWeb && Platform.isAndroid ? Spacing.md : paddingLeft,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const DrawerButton(),
            const SizedBox(height: 20),
            PuzzleHeader(containerWidth: containerWidth),
            const ResetPuzzleButton(),
          ],
        ),
      ),
    ];
  }

  List<Widget> get verticalPuzzleUIElements {
    return [
      Positioned(
        top: kIsWeb
            ? Spacing.md
            : !kIsWeb &&
                    (Platform.isAndroid || Platform.isMacOS || Platform.isLinux)
                ? paddingTop + Spacing.md
                : paddingTop,
        left: Spacing.screenHPadding,
        child: const DrawerButton(),
      ),
      Positioned(
        bottom: distanceOutsidePuzzle,
        width: containerWidth,
        left: (screenWidth - containerWidth) / 2,
        child: PuzzleHeader(containerWidth: containerWidth),
      ),
      Positioned(
        top: distanceOutsidePuzzle,
        right: 0,
        left: (screenWidth - containerWidth) / 2,
        child: const Align(
          alignment: Alignment.centerLeft,
          child: ResetPuzzleButton(),
        ),
      ),
    ];
  }

  List<Widget> get buildUIElements {
    return isWideLayout ? horizontalPuzzleUIElements : verticalPuzzleUIElements;
  }
}
