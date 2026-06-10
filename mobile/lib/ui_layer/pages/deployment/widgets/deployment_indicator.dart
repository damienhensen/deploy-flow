import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/deploying_progress_wave.dart';
import 'package:mobile/ui_layer/widgets/label.dart';

enum DeploymentStatusState { success, error, loading }

class DeploymentIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;
  final DeploymentStatusState status;

  const DeploymentIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
    this.status = DeploymentStatusState.loading,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercentage = currentStep / totalSteps;
    String progressString = "${(progressPercentage * 100).toStringAsFixed(0)}%";

    String deploymentString;
    Color color;

    switch (status) {
      case DeploymentStatusState.success:
        deploymentString = "Deployment Successful";
        color = AppColors.success;
        break;
      case DeploymentStatusState.error:
        deploymentString = "Deployment Failed";
        color = AppColors.error;
        break;
      case DeploymentStatusState.loading:
        deploymentString = "Deploying";
        color = AppColors.primary;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        border: Border.all(color: AppColors.surfaceContainerLowest, width: 2),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Row(
            children: [
              Text(
                deploymentString,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(color: color),
              ),
              const Spacer(),
              Label(text: "2dsa2f"),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Text(
                "Progress".toUpperCase(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const Spacer(),
              Text(
                progressString,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: color),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.xs),
          LayoutBuilder(
            builder: (context, constraints) {
              final progressWidth = constraints.maxWidth * progressPercentage;

              return Stack(
                children: [
                  Container(
                    height: AppSpacing.xs,
                    decoration: BoxDecoration(
                      color: AppColors.onPrimaryContainer,
                      borderRadius: BorderRadius.circular(AppSpacing.sm),
                    ),
                  ),

                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.sm),
                    child: SizedBox(
                      width: progressWidth,
                      height: AppSpacing.xs,
                      child: status == DeploymentStatusState.loading
                          ? DeployingProgressWave(color: color)
                          : ColoredBox(color: color),
                    ),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
