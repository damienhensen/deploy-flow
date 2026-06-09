import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/label.dart';

class SelectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final String? label;
  final Widget? description;
  final bool selected;
  final bool disabled;
  final VoidCallback? onTap;

  const SelectionCard({
    super.key,
    required this.title,
    required this.icon,
    this.label,
    this.description,
    this.selected = false,
    this.disabled = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: disabled
              ? AppColors.surfaceContainer
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          border: selected
              ? Border.all(color: AppColors.primary, width: 2)
              : Border.all(
                  color: disabled
                      ? AppColors.surfaceContainer
                      : AppColors.surfaceContainerLowest,
                  width: 2,
                ),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.05),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              height: 40,
              width: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryContainer.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
              child: Icon(icon, color: AppColors.primary),
            ),
            SizedBox(width: AppSpacing.sm),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      if (label != null) ...[
                        const Spacer(),
                        Label(text: label!, disabled: disabled),
                      ],
                    ],
                  ),
                  if (description != null) ...[
                    SizedBox(height: AppSpacing.xs),
                    description!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
