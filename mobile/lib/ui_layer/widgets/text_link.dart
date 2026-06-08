import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class TextLink extends StatelessWidget {
  final Text label;
  final bool external;
  final VoidCallback? onTap;

  const TextLink({
    super.key,
    required this.label,
    this.external = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: .center,
        children: [
          label,
          const SizedBox(width: AppSpacing.sm),
          Icon(
            external ? Icons.open_in_new : Icons.chevron_right,
            size: AppSpacing.md,
          ),
        ],
      ),
    );
  }
}
