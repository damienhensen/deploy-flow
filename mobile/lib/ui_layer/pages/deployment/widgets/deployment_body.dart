import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/deployment/widgets/deployment_indicator.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/step_status.dart';

class DeploymentBody extends StatelessWidget {
  const DeploymentBody({super.key});

  @override
  Widget build(BuildContext context) {
    return DeployFlowSliverPage(
      title: Text(
        "Portfolio",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
      ],
      header: Column(
        crossAxisAlignment: .start,
        children: [DeploymentIndicator(currentStep: 4, totalSteps: 7, status: DeploymentStatusState.loading,)],
      ),
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                StepStatus(
                  label: "Creating server",
                  description: "Completed in 12s",
                  status: StepStatusState.success,
                ),
                SizedBox(height: AppSpacing.md),
                StepStatus(
                  label: "Waiting for IP",
                  description: "Completed in 4s",
                  status: StepStatusState.success,
                ),
                SizedBox(height: AppSpacing.md),
                StepStatus(
                  label: "Configuring SSH",
                  description: "Completed in 8s",
                  status: StepStatusState.success,
                ),
                SizedBox(height: AppSpacing.md),
                StepStatus(
                  label: "Installing Docker",
                  description: "Completed in 45s",
                  status: StepStatusState.success,
                ),
                SizedBox(height: AppSpacing.md),
                StepStatus(
                  label: "Cloning Repository",
                  status: StepStatusState.loading,
                ),
                SizedBox(height: AppSpacing.md),
                StepStatus(
                  label: "Starting Containers",
                  status: StepStatusState.pending,
                ),
                SizedBox(height: AppSpacing.md),
                StepStatus(
                  label: "Health Checks",
                  status: StepStatusState.pending,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
