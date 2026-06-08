import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/projects/widgets/project_card.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/filter_status_chip.dart';

class ProjectsBody extends StatelessWidget {
  const ProjectsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final selectedFilter = "All";

    return DeployFlowSliverPage(
      title: "DeployFlow",
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
      ],
      header: Column(
        crossAxisAlignment: .start,
        children: [
          Text("Projects", style: Theme.of(context).textTheme.headlineLarge),
          Text(
            "Manage and deploy your infrastructure.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          SizedBox(height: AppSpacing.lg),
          FilledButton.icon(
            onPressed: () {},
            icon: Icon(Icons.add),
            label: Text("Create Project"),
          ),
        ],
      ),
      stickyHeader: Column(
        children: [
          TextField(
            decoration: InputDecoration(
              hintText: "Search projects...",
              prefixIcon: Icon(Icons.search),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                FilterStatusChip(
                  text: "All",
                  selected: selectedFilter == "All",
                  onTap: () {},
                ),
                SizedBox(width: AppSpacing.sm),

                FilterStatusChip(
                  text: "Running",
                  selected: selectedFilter == "Running",
                  onTap: () {},
                ),
                SizedBox(width: AppSpacing.sm),

                FilterStatusChip(
                  text: "Deploying",
                  selected: selectedFilter == "Deploying",
                  onTap: () {},
                ),
                SizedBox(width: AppSpacing.sm),

                FilterStatusChip(
                  text: "Stopped",
                  selected: selectedFilter == "Stopped",
                  onTap: () {},
                ),
                SizedBox(width: AppSpacing.sm),

                FilterStatusChip(
                  text: "Failed",
                  selected: selectedFilter == "Failed",
                  onTap: () {},
                ),
              ],
            ),
          ),
        ],
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList.separated(
            itemCount: 10,
            itemBuilder: (context, idx) {
              return ProjectCard();
            },
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
