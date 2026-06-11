import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/verification_row.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:provider/provider.dart';

class ProjectVerificationCard extends StatelessWidget {
  const ProjectVerificationCard({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateProjectProvider>();
    final selectedRepo = viewModel.selectedRepository!;
    final selectedBranch = viewModel.selectedBranch!;

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
                child: Icon(Icons.rocket_launch, color: AppColors.primary),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Launch Manifest",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      "Production Environment",
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
            ],
          ),
          Divider(height: AppSpacing.xl),
          VerificationRow(
            icon: Icons.folder_outlined,
            label: "Repository",
            value: selectedRepo.name,
          ),
          SizedBox(height: AppSpacing.sm),
          VerificationRow(
            icon: Icons.account_tree_outlined,
            label: "Branch",
            value: selectedBranch.name,
          ),
          SizedBox(height: AppSpacing.sm),
          VerificationRow(
            icon: Icons.cloud_outlined,
            label: "Provider",
            value: viewModel.selectedProvider,
          ),
          SizedBox(height: AppSpacing.sm),
          VerificationRow(
            icon: Icons.public,
            label: "Domain",
            value: viewModel.domainPreview,
          ),
        ],
      ),
    );
  }
}
