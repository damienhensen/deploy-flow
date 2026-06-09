import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/step_indicator.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/selection_card.dart';
import 'package:provider/provider.dart';

class BranchStep extends StatelessWidget {
  const BranchStep({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateProjectProvider>();

    return DeployFlowSliverPage(
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
      ],
      header: Column(
        crossAxisAlignment: .start,
        children: [
          StepIndicator(
            currentStep: viewModel.currentStep,
            totalSteps: viewModel.totalSteps,
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            "Choose Branch",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Select which branch should be deployed.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList.separated(
            itemCount: viewModel.branches.length,
            itemBuilder: (context, idx) {
              String branch = viewModel.branches[idx];

              String branchName = branch;

              return SelectionCard(
                onTap: () {
                  viewModel.setBranch(branchName);
                },
                title: branchName,
                icon: Icons.account_tree_outlined,
                selected: branchName == viewModel.selectedBranch,
                label: "2h ago",
                description: Text(
                  "damienhensen",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
