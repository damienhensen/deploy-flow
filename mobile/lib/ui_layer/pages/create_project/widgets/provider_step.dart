import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/step_indicator.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/selection_card.dart';
import 'package:provider/provider.dart';

class ProviderStep extends StatelessWidget {
  const ProviderStep({super.key});

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
            "Choose Provider",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Select where DeployFlow should deploy your application.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverList.separated(
            itemCount: viewModel.providers.length,
            itemBuilder: (context, idx) {
              MapEntry<String, bool> project = viewModel.providers.entries
                  .elementAt(idx);

              String projectName = project.key;
              bool projectDisabled = project.value;

              return SelectionCard(
                onTap: () {
                  // Disabled
                  if (projectDisabled) return;

                  viewModel.setProvider(projectName);
                },
                title: projectName,
                icon: Icons.cloud_outlined,
                selected: projectName == viewModel.selectedProvider,
                label: projectDisabled ? "SOON" : null,
                disabled: projectDisabled,
              );
            },
            separatorBuilder: (_, _) => const SizedBox(height: AppSpacing.md),
          ),
        ),
      ],
    );
  }
}
