import 'dart:io';
import 'dart:ui';

import 'package:jigsaw/helpers/localizations_ext.dart';
import 'package:jigsaw/ui/features/drawer/app_version_section.dart';
import 'package:jigsaw/ui/features/drawer/dark_mode_toggle.dart';
import 'package:jigsaw/ui/features/drawer/drawer_app_info.dart';
import 'package:jigsaw/ui/features/drawer/game_mode_settings.dart';
import 'package:jigsaw/ui/features/drawer/language_picker.dart';
import 'package:jigsaw/ui/features/drawer/latest_scores.dart';
import 'package:jigsaw/ui/features/drawer/puzzle_size_settings.dart';
import 'package:jigsaw/ui/core/layout/spacing.dart';
import 'package:jigsaw/ui/core/layout/screen_type_helper.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final padding = MediaQuery.paddingOf(context);
    final screenSize = MediaQuery.sizeOf(context);
    final isWide = screenSize.width > 600;
    double drawerStartPadding = padding.left == 0 ? Spacing.md : padding.left;
    final colorScheme = Theme.of(context).colorScheme;

    return SafeArea(
      left: false,
      child: ClipRRect(
        borderRadius: BorderRadius.zero,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaY: 16, sigmaX: 16),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final drawerWidth = constraints.maxWidth > 600
                  ? 500.0
                  : screenSize.width * 0.82;

              return Container(
                width: drawerWidth,
                margin:
                    kIsWeb ||
                        Platform.isAndroid ||
                        Platform.isMacOS ||
                        Platform.isLinux
                    ? const EdgeInsets.symmetric(vertical: 16)
                    : EdgeInsets.only(
                        top: screenSize.width > screenSize.height
                            ? padding.bottom
                            : 0,
                      ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerLow.withValues(
                    alpha: 0.95,
                  ),
                  borderRadius: BorderRadius.zero,
                  border: Border(
                    right: BorderSide(
                      width: isWide ? 1 : 1,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.15),
                    ),
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
                            GameModeSettings(),
                            LanguagePicker(),
                            DarkModeToggle(),
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
    final wc = ScreenTypeHelper(
      MediaQuery.sizeOf(context).width,
      0,
    ).windowClass;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: drawerStartPadding,
        right: Spacing.md,
        top: Spacing.md,
        bottom: Spacing.sm,
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.zero,
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
                Text(
                  context.l10n.appTitle,
                  style:
                      (wc == WindowClass.compact
                              ? AppTextStyles.titleMedium
                              : AppTextStyles.titleLarge)
                          .copyWith(
                            fontVariations: const [FontVariation('wght', 700)],
                          ),
                ),
                const SizedBox(height: 1),
                Text(
                  context.l10n.appSubtitle,
                  style: AppTextStyles.bodyAdaptive(wc).copyWith(
                    fontVariations: const [FontVariation('wght', 400)],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const HugeIcon(icon: HugeIcons.strokeRoundedCancel01),
            style: IconButton.styleFrom(
              foregroundColor: colorScheme.onSurface.withValues(alpha: 0.7),
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
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: EdgeInsets.only(
        left: drawerStartPadding,
        right: Spacing.md,
        top: Spacing.sm,
        bottom: Spacing.md + MediaQuery.paddingOf(context).bottom / 2,
      ),
      child: Row(
        children: [
          const Expanded(child: AppVersionSection()),
          const SizedBox(width: 8),
          const DrawerAppInfo(),
          const Spacer(),
          HugeIcon(
            icon: HugeIcons.strokeRoundedRocket01,
            size: 16,
            color: colorScheme.onSurface.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}
