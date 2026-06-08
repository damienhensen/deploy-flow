import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/status_card_item.dart';

class ProjectConfigurationCard extends StatelessWidget {
  const ProjectConfigurationCard({super.key});

  @override
  Widget build(BuildContext context) {
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
          Text(
            "Configuration",
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: StatusCardItem(
                  label: "Repository",
                  value: "damienhensen/portfolio",
                ),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: StatusCardItem(label: "Branch", value: "main"),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: StatusCardItem(label: "Provider", value: "DigitalOcean"),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: StatusCardItem(
                  label: "Environment",
                  value: "Production",
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Expanded(
                child: StatusCardItem(label: "Region", value: "Amsterdam"),
              ),
              SizedBox(width: AppSpacing.lg),
              Expanded(
                child: StatusCardItem(
                  label: "Domain",
                  value: "damienhensen.nl",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
