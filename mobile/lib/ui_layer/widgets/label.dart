import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class Label extends StatelessWidget {
  final String text;
  final bool disabled;

  const Label({super.key, required this.text, this.disabled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: disabled
            ? AppColors.surfaceContainerHighest
            : AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.xs),
      ),
      child: Text(
        text,
        style: Theme.of(
          context,
        ).textTheme.labelSmall?.copyWith(color: AppColors.onSurfaceVariant),
      ),
    );
  }
}
