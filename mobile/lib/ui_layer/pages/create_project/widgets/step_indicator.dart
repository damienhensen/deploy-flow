import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    double progressPercentage = currentStep / totalSteps;
    String progressString = "${(progressPercentage * 100).toStringAsFixed(0)}%";

    return Column(
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Text(
              "Step $currentStep of $totalSteps".toUpperCase(),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const Spacer(),
            Text(
              progressString,
              style: Theme.of(
                context,
              ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
            ),
          ],
        ),
        SizedBox(height: AppSpacing.xs),
        Stack(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: AppSpacing.xs,
              decoration: BoxDecoration(
                color: AppColors.onPrimaryContainer,
                borderRadius: BorderRadius.circular(AppSpacing.sm),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: MediaQuery.of(context).size.width * progressPercentage,
                height: AppSpacing.xs,
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppSpacing.sm),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
