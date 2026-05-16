import 'package:tauntpuzz/generated/app_localizations.dart';
import 'package:tauntpuzz/helpers/localizations_ext.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
import 'package:tauntpuzz/ui/core/layout/screen_type_helper.dart';
import 'package:tauntpuzz/ui/core/layout/spacing.dart';
import 'package:tauntpuzz/ui/core/locale_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({super.key});

  static const _languages = [
    _Language(code: 'en', label: 'English'),
    _Language(code: 'fr', label: 'Français'),
    _Language(code: 'ar', label: 'العربية'),
  ];

  @override
  Widget build(BuildContext context) {
    final wc =
        ScreenTypeHelper(MediaQuery.sizeOf(context).width, 0).windowClass;
    final padding = MediaQuery.paddingOf(context);
    final drawerStartPadding = padding.left == 0 ? Spacing.md : padding.left;
    final localeProvider = context.watch<LocaleProvider>();

    return Container(
      padding: EdgeInsets.only(
        right: Spacing.md,
        left: drawerStartPadding,
        top: Spacing.md,
        bottom: Spacing.md,
      ),
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Color(0x26C6C6C6),
            width: 1,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.language_rounded,
                size: 16,
                color: AppColors.onSurface.withValues(alpha: 0.6),
              ),
              const SizedBox(width: 6),
              Text(context.l10n.language,
                  style: AppTextStyles.titleAdaptive(wc)),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            context.l10n.switchLanguage,
            style: AppTextStyles.bodyAdaptive(wc).copyWith(
              color: AppColors.onSurface.withValues(alpha: 0.5),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              ...List.generate(_languages.length, (index) {
                final lang = _languages[index];
                final currentCode = localeProvider.locale?.languageCode;
                final isSelected = currentCode == lang.code ||
                    (currentCode == null &&
                        AppLocalizations.of(context)?.localeName == lang.code);
                return Expanded(
                  child: Padding(
                    padding: EdgeInsetsDirectional.only(
                      end: index < _languages.length - 1 ? Spacing.xs / 2 : 0,
                      start: index > 0 ? Spacing.xs / 2 : 0,
                    ),
                    child: _LanguageButton(
                      label: lang.label,
                      isSelected: isSelected,
                      onTap: () {
                        if (isSelected) return;
                        localeProvider.setLocale(Locale(lang.code));
                      },
                    ),
                  ),
                );
              }),
            ],
          ),
        ],
      ),
    );
  }
}

class _Language {
  final String code;
  final String label;
  const _Language({required this.code, required this.label});
}

class _LanguageButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _LanguageButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isSelected ? AppColors.primary : Colors.transparent,
      borderRadius: BorderRadius.zero,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.zero,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            border: Border.all(
              color: isSelected
                  ? AppColors.primary
                  : AppColors.outlineVariant.withValues(alpha: 0.5),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                fontVariations: const [FontVariation('wght', 600)],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
