import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class IconLink extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool external;
  final VoidCallback? onPressed;

  const IconLink({
    super.key,
    required this.label,
    this.icon,
    this.external = false,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      child: Row(
        mainAxisAlignment: .start,
        children: [
          if (icon != null)
            Icon(icon, size: AppSpacing.lg, color: AppColors.primary),
          const SizedBox(width: AppSpacing.sm),
          Text(label),
          const Spacer(),
          Icon(external ? Icons.open_in_new : Icons.chevron_right),
        ],
      ),
    );
  }
}
