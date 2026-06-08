import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';

class StatusCardItem extends StatelessWidget {
  final String label;
  final String value;
  final Widget? valueWidget;
  final CrossAxisAlignment alignment;

  const StatusCardItem({
    super.key,
    required this.label,
    required this.value,
    this.valueWidget,
    this.alignment = .start,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: alignment,
      children: [
        Text(
          label.toUpperCase(),
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: AppColors.onSurfaceVariant),
        ),
        valueWidget ??
            Text(value, style: Theme.of(context).textTheme.labelLarge),
      ],
    );
  }
}
