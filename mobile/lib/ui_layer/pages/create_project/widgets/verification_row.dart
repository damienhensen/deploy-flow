import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class VerificationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const VerificationRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: AppSpacing.md, color: AppColors.onSurfaceVariant),
        SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.bodyMedium?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        const Spacer(),
        Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
