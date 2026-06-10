import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class TextLink extends StatelessWidget {
  final Text label;
  final bool external;
  final bool icon;
  final VoidCallback? onTap;

  const TextLink({
    super.key,
    required this.label,
    this.external = true,
    this.icon = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min, // important
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          label,
          if (icon) ...[
            const SizedBox(width: AppSpacing.sm),
            Icon(
              external ? Icons.open_in_new : Icons.chevron_right,
              size: AppSpacing.md,
            ),
          ],
        ],
      ),
    );
  }
}
