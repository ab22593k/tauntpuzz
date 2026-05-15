import 'dart:io';
import 'dart:ui';

import 'package:dashtronaut/presentation/drawer/app_version_section.dart';
import 'package:dashtronaut/presentation/drawer/drawer_app_info.dart';
import 'package:dashtronaut/presentation/drawer/latest_scores.dart';
import 'package:dashtronaut/presentation/drawer/puzzle_size_settings.dart';
import 'package:dashtronaut/presentation/layout/spacing.dart';
import 'package:dashtronaut/presentation/styles/app_colors.dart';
import 'package:dashtronaut/presentation/styles/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    double drawerStartPadding =
        mediaQuery.padding.left == 0 ? Spacing.md : mediaQuery.padding.left;

    return SafeArea(
      left: false,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 8, sigmaX: 8),
          child: Transform(
            transform: Matrix4.translationValues(-2, 0, 0),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final drawerWidth = constraints.maxWidth > 600
                    ? 500.0
                    : mediaQuery.size.width * 0.8;

                return Container(
                  width: drawerWidth,
                  margin: kIsWeb ||
                          Platform.isAndroid ||
                          Platform.isMacOS ||
                          Platform.isLinux
                      ? const EdgeInsets.symmetric(vertical: 20)
                      : EdgeInsets.only(
                          top: mediaQuery.orientation == Orientation.landscape
                              ? mediaQuery.padding.bottom
                              : 0),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    borderRadius: const BorderRadiusDirectional.only(
                        topEnd: Radius.circular(15),
                        bottomEnd: Radius.circular(15)),
                    border: Border.all(width: 2, color: Colors.white),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                            left: drawerStartPadding,
                            right: Spacing.md,
                            top: Spacing.md,
                            bottom: Spacing.md),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Dashtronaut',
                              style: AppTextStyles.title,
                            ),
                            IconButton(
                              onPressed: () {
                                if (Scaffold.of(context).isDrawerOpen) {
                                  Navigator.of(context).pop();
                                }
                              },
                              icon: const Icon(Icons.close),
                            ),
                          ],
                        ),
                      ),
                      const Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
                              PuzzleSizeSettings(),
                              LatestScores(),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(
                            left: drawerStartPadding,
                            right: Spacing.md,
                            top: Spacing.md,
                            bottom: Spacing.md),
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          border: Border(
                              top: BorderSide(color: Colors.white, width: 2)),
                        ),
                        child: const Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AppVersionSection(),
                            SizedBox(height: 5),
                            DrawerAppInfo(),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
