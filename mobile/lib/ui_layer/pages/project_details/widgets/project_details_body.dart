import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/logs/logs_page.dart';
import 'package:mobile/ui_layer/widgets/activity.dart';
import 'package:mobile/ui_layer/pages/project_details/widgets/project_configuration_card.dart';
import 'package:mobile/ui_layer/pages/project_details/widgets/project_status_card.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/icon_link.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetails extends StatelessWidget {
  const ProjectDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return DeployFlowSliverPage(
      title: Text(
        "Command Center",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
        IconButton(onPressed: () {}, icon: Icon(Icons.more_vert)),
      ],
      header: Column(
        crossAxisAlignment: .start,
        children: [
          Text("Portfolio", style: Theme.of(context).textTheme.headlineLarge),
          SizedBox(height: AppSpacing.lg),
          ProjectStatusCard(),
        ],
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.only(
            top: AppSpacing.sm,
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.md,
          ),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                Text(
                  "Update available • 1 commit behind",
                  style: Theme.of(
                    context,
                  ).textTheme.labelMedium?.copyWith(color: AppColors.primary),
                  textAlign: .center,
                ),
                SizedBox(height: AppSpacing.lg),
                SizedBox(
                  height: 72,
                  child: FilledButton.icon(
                    onPressed: () {},
                    icon: Icon(Icons.rocket_launch),
                    label: Text("Update Deployment"),
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.refresh),
                              SizedBox(height: AppSpacing.sm),
                              Text("Redeploy"),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: SizedBox(
                        width: 96,
                        height: 96,
                        child: OutlinedButton(
                          onPressed: () {},
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.power_settings_new),
                              SizedBox(height: AppSpacing.sm),
                              Text("Reboot"),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.lg),
                IconLink(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse("https://damienhensen.nl"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  label: "Open Website",
                  icon: Icons.public,
                  external: true,
                ),
                SizedBox(height: AppSpacing.sm),
                IconLink(
                  onPressed: () async {
                    await launchUrl(
                      Uri.parse("https://github.com/damienhensen/portfolio"),
                      mode: LaunchMode.externalApplication,
                    );
                  },
                  label: "Open Repository",
                  icon: Icons.code,
                  external: true,
                ),
                SizedBox(height: AppSpacing.sm),
                IconLink(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LogsPage()),
                    );
                  },
                  label: "View Logs",
                  icon: Icons.terminal,
                ),
                SizedBox(height: AppSpacing.lg),
                ProjectConfigurationCard(),
                SizedBox(height: AppSpacing.lg),
                Text(
                  "Recent Activity",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: AppSpacing.md),
                Activity(
                  label: "Deployment Completed",
                  timestamp: "2 minutes ago",
                ),
                SizedBox(height: AppSpacing.md),
                Activity(label: "Restarted", timestamp: "Yesterday"),
                SizedBox(height: AppSpacing.md),
                Activity(label: "Created Project", timestamp: "7 days ago"),
                SizedBox(height: AppSpacing.lg),
                const Divider(),
                SizedBox(height: AppSpacing.lg),
                Text(
                  "Danger Zone".toUpperCase(),
                  style: Theme.of(
                    context,
                  ).textTheme.headlineSmall?.copyWith(color: AppColors.error),
                  textAlign: .center,
                ),
                SizedBox(height: AppSpacing.md),
                OutlinedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    side: const WidgetStatePropertyAll(
                      BorderSide(color: AppColors.error, width: 1.5),
                    ),
                  ),
                  child: Text(
                    "Delete Project",
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.error),
                  ),
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  "This action is permanent and cannot be undone",
                  style: Theme.of(context).textTheme.bodySmall,
                  textAlign: .center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
