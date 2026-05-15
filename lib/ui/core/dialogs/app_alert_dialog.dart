import 'dart:ui';

import 'package:tauntpuzz/ui/core/layout/spacing.dart';
import 'package:tauntpuzz/ui/core/app_colors.dart';
import 'package:tauntpuzz/ui/core/app_text_styles.dart';
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
    this.insetPadding =
        const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0),
  }) : assert(content == null ? title != null && onConfirm != null : true);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.transparent,
      contentPadding: const EdgeInsets.all(0),
      scrollable: true,
      insetPadding: insetPadding,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(color: Colors.white, width: 2),
      ),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(18),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 12, sigmaX: 12),
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(
                    horizontal: Spacing.screenHPadding, vertical: Spacing.md),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  color: AppColors.surfaceContainerHigh,
                ),
                child: content ??
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style:
                                AppTextStyles.bodyLarge.copyWith(height: 1.5),
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
                                child: const Text('Yes'),
                              ),
                            ),
                            const SizedBox(width: Spacing.sm),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: onCancel ??
                                    () => Navigator.of(context).pop(),
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        )
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
