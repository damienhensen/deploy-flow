import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/status_chip.dart';

class ProjectCard extends StatelessWidget {
  final VoidCallback? onTap;

  const ProjectCard({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSpacing.md),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.md),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(AppSpacing.md),
          boxShadow: [
            BoxShadow(
              color: AppColors.onSurface.withValues(alpha: 0.05),
              blurRadius: 1.0,
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        "Portfolio",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      const Spacer(),
                      StatusChip(text: "Running"),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Row(
                        children: [
                          Icon(Icons.cloud_outlined, size: AppSpacing.md),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            "DigitalOcean",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Text(
                        "|",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.outlineVariant,
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Row(
                        children: [
                          Icon(
                            Icons.account_tree_outlined,
                            size: AppSpacing.md,
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            "main",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: AppSpacing.xs),
                  Text(
                    "Last deployed 2h ago",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            SizedBox(width: AppSpacing.sm),
            Icon(Icons.chevron_right),
          ],
        ),
      ),
    );
  }
}
