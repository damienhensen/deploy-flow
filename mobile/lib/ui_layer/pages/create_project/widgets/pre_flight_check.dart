import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class PreFlightCheck extends StatelessWidget {
  final String label;
  final bool success;

  const PreFlightCheck({super.key, required this.label, required this.success});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 32,
          width: 32,
          decoration: BoxDecoration(
            color: success
                ? AppColors.success.withValues(alpha: 0.15)
                : AppColors.error.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(AppSpacing.xl),
          ),
          child: Icon(
            success ? Icons.check : Icons.close,
            color: success ? AppColors.success : AppColors.error,
            size: AppSpacing.md,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
          ],
        ),
      ],
    );
  }
}
