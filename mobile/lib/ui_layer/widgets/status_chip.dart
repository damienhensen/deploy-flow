import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class StatusChip extends StatelessWidget {
  final String text;
  final VoidCallback? onTap;

  const StatusChip({super.key, required this.text, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(999),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(999),
          border: Border.all(color: AppColors.success),
        ),
        child: Row(
          children: [
            Container(
              width: AppSpacing.sm,
              height: AppSpacing.sm,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            SizedBox(width: AppSpacing.xs),
            Text(
              text,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: AppColors.success),
            ),
          ],
        ),
      ),
    );
  }
}
