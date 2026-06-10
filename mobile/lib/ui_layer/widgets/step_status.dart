import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

enum StepStatusState { success, error, loading, pending }

class StepStatus extends StatelessWidget {
  final String label;
  final String? description;
  final StepStatusState status;

  const StepStatus({
    super.key,
    required this.label,
    required this.status,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    late final Color backgroundColor;
    Border? border;
    Widget? child;

    switch (status) {
      case StepStatusState.loading:
        backgroundColor = AppColors.primary.withValues(alpha: 0.15);
        child = const Center(
          child: SizedBox(
            width: AppSpacing.md,
            height: AppSpacing.md,
            child: CircularProgressIndicator(
              strokeWidth: 1,
              color: AppColors.primary,
            ),
          ),
        );
        break;

      case StepStatusState.success:
        backgroundColor = AppColors.success.withValues(alpha: 0.15);
        child = const Icon(
          Icons.check,
          color: AppColors.success,
          size: AppSpacing.md,
        );
        break;

      case StepStatusState.error:
        backgroundColor = AppColors.error.withValues(alpha: 0.15);
        child = const Icon(
          Icons.close,
          color: AppColors.error,
          size: AppSpacing.md,
        );
        break;

      case StepStatusState.pending:
        backgroundColor = AppColors.surfaceContainerLow;
        border = Border.all(color: AppColors.surfaceContainerHighest);
        child = null;
        break;
    }

    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppSpacing.xl),
            border: border,
          ),
          child: child,
        ),
        const SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            if (description != null) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(description!, style: Theme.of(context).textTheme.bodySmall),
            ],
          ],
        ),
      ],
    );
  }
}
