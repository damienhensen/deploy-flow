import 'package:flutter/material.dart';
import 'package:mobile/data_layer/models/git_repository_list_item.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/step_indicator.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_helpers.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/selection_card.dart';
import 'package:provider/provider.dart';

class RepositoryStep extends StatelessWidget {
  const RepositoryStep({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateProjectProvider>();

    return DeployFlowSliverPage(
      title: Text(
        "Create Project",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
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
            "Choose Repository",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Select the repository you want to deploy to the production environment.",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      slivers: [
        viewModel.isLoading
            ? SliverFillRemaining(
                hasScrollBody: false,
                child: Column(
                  mainAxisAlignment: .center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: AppSpacing.lg),
                    Text("Loading repositories..."),
                  ],
                ),
              )
            : SliverPadding(
                padding: const EdgeInsets.all(AppSpacing.md),
                sliver: SliverList.separated(
                  itemCount: viewModel.repositories.length,
                  itemBuilder: (context, idx) {
                    GitRepositoryListItem repository =
                        viewModel.repositories[idx];

                    String repositoryName = repository.name;
                    bool selected =
                        repository.id == viewModel.selectedRepository!.id;

                    return SelectionCard(
                      onTap: () {
                        viewModel.setRepository(repository);
                      },
                      title: repositoryName,
                      icon: Icons.folder_outlined,
                      selected: selected,
                      label: repository.visibility,
                      description: Row(
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.account_tree_outlined,
                                size: AppSpacing.md,
                              ),
                              SizedBox(width: AppSpacing.xs),
                              Text(
                                repository.defaultBranch,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            "•",
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(color: AppColors.outlineVariant),
                          ),
                          SizedBox(width: AppSpacing.xs),
                          Text(
                            "Updated ${AppHelpers.timeAgo(repository.updatedAt)}",
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        ],
                      ),
                    );
                  },
                  separatorBuilder: (_, _) =>
                      const SizedBox(height: AppSpacing.md),
                ),
              ),
      ],
    );
  }
}
