import 'dart:io';
import 'dart:ui';

import 'package:tauntpuzz/ui/features/drawer/app_version_section.dart';
import 'package:tauntpuzz/ui/features/drawer/drawer_app_info.dart';
import 'package:tauntpuzz/ui/features/drawer/latest_scores.dart';
import 'package:tauntpuzz/ui/features/drawer/puzzle_size_settings.dart';
import 'package:tauntpuzz/ui/core/layout/spacing.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final screenSize = MediaQuery.sizeOf(context);
    final isWide = screenSize.width > 600;
    double drawerStartPadding = padding.left == 0 ? Spacing.md : padding.left;

    return SafeArea(
      left: false,
      child: ClipRRect(
        borderRadius: const BorderRadiusDirectional.only(
            topEnd: Radius.circular(18), bottomEnd: Radius.circular(18)),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 16, sigmaX: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final drawerWidth =
                  constraints.maxWidth > 600 ? 500.0 : screenSize.width * 0.82;

              return Container(
                width: drawerWidth,
                margin: kIsWeb ||
                        Platform.isAndroid ||
                        Platform.isMacOS ||
                        Platform.isLinux
                    ? const EdgeInsets.symmetric(vertical: 16)
                    : EdgeInsets.only(
                        top: screenSize.width > screenSize.height
                            ? padding.bottom
                            : 0),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh.withValues(alpha: 0.95),
                  borderRadius: const BorderRadiusDirectional.only(
                      topEnd: Radius.circular(18),
                      bottomEnd: Radius.circular(18)),
                  border: Border.all(
                    width: isWide ? 2 : 1.5,
                    color: AppColors.stellarWhite.withValues(alpha: 0.6),
                  ),
                ),
                child: Column(
                  children: [
                    _DrawerHeader(drawerStartPadding: drawerStartPadding),
                    const Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            PuzzleSizeSettings(),
                            SizedBox(height: 8),
                            LatestScores(),
                          ],
                        ),
                      ),
                    ),
                    _DrawerFooter(drawerStartPadding: drawerStartPadding),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  final double drawerStartPadding;

  const _DrawerHeader({required this.drawerStartPadding});

  @override
  Widget build(BuildContext context) {
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;

    return Container(
      padding: EdgeInsets.only(
        left: drawerStartPadding,
        right: Spacing.md,
        top: Spacing.md,
        bottom: Spacing.sm,
      ),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: AppColors.stellarWhite.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: AppColors.nebulaPurple,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: AppColors.stellarWhite.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
            child: const Center(
              child: Text('D', style: AppTextStyles.titleMedium),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Dashtronaut',
                    style: (wc == WindowClass.compact
                            ? AppTextStyles.titleMedium
                            : AppTextStyles.titleLarge)
                        .copyWith(
                      fontVariations: const [FontVariation('wght', 700)],
                    )),
                const SizedBox(height: 1),
                Text(
                  'Slide Puzzle Game',
                  style: AppTextStyles.bodyAdaptive(wc).copyWith(
                    fontVariations: const [FontVariation('wght', 400)],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              if (Scaffold.of(context).isDrawerOpen) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.close),
            style: IconButton.styleFrom(
              foregroundColor: AppColors.stellarWhite.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerFooter extends StatelessWidget {
  final double drawerStartPadding;

  const _DrawerFooter({required this.drawerStartPadding});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        left: drawerStartPadding,
        right: Spacing.md,
        top: Spacing.sm,
        bottom: Spacing.md + MediaQuery.paddingOf(context).bottom / 2,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: AppColors.stellarWhite.withValues(alpha: 0.2),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          const Expanded(child: AppVersionSection()),
          const SizedBox(width: 8),
          const DrawerAppInfo(),
          const Spacer(),
          Icon(
            Icons.rocket_launch_outlined,
            size: 16,
            color: AppColors.stellarWhite.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
