import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class Activity extends StatelessWidget {
  final String label;
  final String timestamp;

  const Activity({super.key, required this.label, required this.timestamp});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(Icons.check_circle_outline, color: AppColors.primary),
        SizedBox(width: AppSpacing.sm),
        Column(
          crossAxisAlignment: .start,
          children: [
            Text(label, style: Theme.of(context).textTheme.labelLarge),
            Text(timestamp, style: Theme.of(context).textTheme.bodySmall),
          ],
        ),
      ],
    );
  }
}
