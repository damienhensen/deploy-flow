import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/step_indicator.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/selection_card.dart';
import 'package:provider/provider.dart';

class DomainStep extends StatelessWidget {
  const DomainStep({super.key});

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
            "Custom Domain",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Would you like to attach a custom domain?",
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                SelectionCard(
                  onTap: () {
                    viewModel.setUsingCustomDomain(false);
                  },
                  title: "Skip for now",
                  icon: Icons.do_disturb_alt,
                  selected: !viewModel.usingCustomDomain,
                  description: Text(
                    "Use the default system-generated URL (e.g., project-123.deployflow.app).",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                SelectionCard(
                  onTap: () {
                    viewModel.setUsingCustomDomain(true);
                  },
                  title: "Use custom domain",
                  icon: Icons.public,
                  selected: viewModel.usingCustomDomain,
                  description: Text(
                    "Point your own professional domain to this deployment.",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
                if (viewModel.usingCustomDomain) ...[
                  const SizedBox(height: AppSpacing.lg),
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(AppSpacing.md),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.onSurface.withValues(alpha: 0.05),
                          blurRadius: 1.0,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: .start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Preview: ",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            Text(
                              viewModel.domainPreview,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "Domain",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            TextField(
                              onChanged: (String domain) =>
                                  viewModel.setDomain(domain),
                              decoration: InputDecoration(
                                hintText: "example.com",
                                prefixIcon: Icon(Icons.public),
                                fillColor: AppColors.surfaceContainerLowest,
                                hintStyle: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Column(
                          crossAxisAlignment: .start,
                          children: [
                            Text(
                              "Subdomain",
                              style: Theme.of(context).textTheme.labelLarge,
                            ),
                            SizedBox(height: AppSpacing.sm),
                            TextField(
                              onChanged: (String subdomain) =>
                                  viewModel.setSubdomain(subdomain),
                              decoration: InputDecoration(
                                hintText: "app",
                                prefixIcon: Icon(
                                  Icons.subdirectory_arrow_right,
                                ),
                                fillColor: AppColors.surfaceContainerLowest,
                                hintStyle: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(
                                      color: AppColors.onSurfaceVariant
                                          .withValues(alpha: 0.5),
                                    ),
                              ),
                            ),
                            SizedBox(height: AppSpacing.sm),
                            Text(
                              "Leave empty for root domain.",
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontStyle: FontStyle.italic),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
