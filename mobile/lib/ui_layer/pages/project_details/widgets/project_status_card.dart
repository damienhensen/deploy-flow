import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/status_card_item.dart';
import 'package:mobile/ui_layer/widgets/status_chip.dart';
import 'package:mobile/ui_layer/widgets/text_link.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectStatusCard extends StatelessWidget {
  const ProjectStatusCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(AppSpacing.md),
        boxShadow: [
          BoxShadow(
            color: AppColors.onSurface.withValues(alpha: 0.05),
            blurRadius: 1.0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Deployment Status",
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const Spacer(),
              StatusChip(text: "Running"),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              StatusCardItem(label: "Last Deployment", value: "2 minutes ago"),
              StatusCardItem(
                label: "Current Branch",
                value: "main",
                alignment: .end,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            mainAxisAlignment: .spaceBetween,
            children: [
              StatusCardItem(label: "Last commit", value: "20 seconds ago"),
              StatusCardItem(
                label: "Deployed Commit",
                value: "dd74f61c",
                valueWidget: TextLink(
                  label: Text(
                    "6e1f5f3",
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                  ),
                  onTap: () async {
                    await launchUrl(
                      Uri.parse(
                        "https://github.com/damienhensen/portfolio/commit/6e1f5f3a27fe4932ea2ae7d5f5b1d2fdb0bfadad",
                      ),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                ),
                alignment: .end,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
