import 'package:tauntpuzz/helpers/localizations_ext.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class DrawerAppInfo extends StatelessWidget {
  const DrawerAppInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: context.l10n.builtWith,
        style: AppTextStyles.bodySmall.copyWith(
          color: AppColors.onSurface,
          fontVariations: [const FontVariation('wght', 380)],
        ),
        children: <TextSpan>[
          TextSpan(
            text: 'Flutter ',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w700,
              fontVariations: [const FontVariation('wght', 700)],
            ),
          ),
        ],
      ),
    );
  }
}
