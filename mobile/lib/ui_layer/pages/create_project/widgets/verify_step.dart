import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/pre_flight_check.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/project_verification_card.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/step_indicator.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/activity.dart';
import 'package:mobile/ui_layer/widgets/selection_card.dart';
import 'package:provider/provider.dart';

class VerifyStep extends StatelessWidget {
  const VerifyStep({super.key});

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
            "Ready to Deploy",
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            "Verify your project details before we launch.",
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
                ProjectVerificationCard(),
                SizedBox(height: AppSpacing.lg),
                Text(
                  "Pre-flight Checks",
                  style: Theme.of(context).textTheme.headlineMedium,
                ),
                SizedBox(height: AppSpacing.md),
                PreFlightCheck(label: "Repository accessible", success: true),
                SizedBox(height: AppSpacing.md),
                PreFlightCheck(
                  label: "Docker Compose not detected",
                  success: false,
                ),
                SizedBox(height: AppSpacing.md),
                PreFlightCheck(label: "Permissions verified", success: true),
                SizedBox(height: AppSpacing.md),
                PreFlightCheck(label: "Ready for deployment", success: true),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
