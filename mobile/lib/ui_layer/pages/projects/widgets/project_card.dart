import 'package:flutter/material.dart';
import 'package:mobile/data_layer/models/project_list_item.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/status_chip.dart';

class ProjectCard extends StatelessWidget {
  final ProjectListItem project;
  final VoidCallback? onTap;

  const ProjectCard({super.key, required this.project, this.onTap});

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
                        project.name,
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
                            project.provider,
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
                            project.branch,
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
