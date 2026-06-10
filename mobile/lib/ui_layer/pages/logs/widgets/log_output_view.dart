import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class LogOutputView extends StatelessWidget {
  final List<String> logLines;
  final bool expanded;
  final VoidCallback onToggle;
  final String title;

  const LogOutputView({
    super.key,
    required this.logLines,
    required this.expanded,
    required this.onToggle,
    this.title = "Terminal Output",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: BorderRadius.circular(AppSpacing.sm),
        border: Border.all(color: AppColors.surfaceContainerHighest),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          InkWell(
            onTap: onToggle,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  const Icon(Icons.terminal, color: AppColors.primary),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Text(
                    expanded ? "Collapse" : "Expand",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                  Icon(
                    expanded
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                  ),
                ],
              ),
            ),
          ),

          if (expanded)
            Container(
              width: double.infinity,
              color: AppColors.onSurface,
              padding: const EdgeInsets.all(AppSpacing.md),
              child: SelectableText(
                logLines.join("\n"),
                style: const TextStyle(
                  fontFamily: "monospace",
                  fontSize: 13,
                  height: 1.6,
                  color: AppColors.surface,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
