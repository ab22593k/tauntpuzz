import 'dart:ui';

import 'package:jigsaw/helpers/localizations_ext.dart';
import 'package:jigsaw/ui/core/layout/spacing.dart';
import 'package:jigsaw/ui/core/app_text_styles.dart';
import 'package:flutter/material.dart';

class AppAlertDialog extends StatelessWidget {
  final String? title;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final Widget? content;
  final EdgeInsets insetPadding;

  const AppAlertDialog({
    super.key,
    this.title,
    this.onConfirm,
    this.onCancel,
    this.content,
    this.insetPadding = const EdgeInsets.symmetric(
      horizontal: 40.0,
      vertical: 24.0,
    ),
  }) : assert(content == null ? title != null && onConfirm != null : true);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      scrollable: true,
      insetPadding: insetPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.zero,
        side: BorderSide(color: colorScheme.outlineVariant, width: 0.5),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.zero,
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 12, sigmaX: 12),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                  horizontal: Spacing.screenHPadding,
                  vertical: Spacing.md,
                ),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.zero,
                  color: colorScheme.surfaceContainerLowest,
                ),
                child:
                    content ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: AppTextStyles.bodyLarge.copyWith(
                              height: 1.5,
                            ),
                          ),
                        const SizedBox(height: 40),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () {
                                  if (onConfirm != null) {
                                    onConfirm!();
                                  }
                                  Navigator.of(context).pop();
                                },
                                child: Text(context.l10n.yes),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            Expanded(
                              child: ElevatedButton(
                                onPressed:
                                    onCancel ??
                                    () => Navigator.of(context).pop(),
                                child: Text(context.l10n.cancel),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
