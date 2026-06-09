import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:provider/provider.dart';

class CreateProjectPage extends StatelessWidget {
  const CreateProjectPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<CreateProjectProvider>();
    bool isLastStep = viewModel.currentStep == viewModel.totalSteps;

    return Scaffold(
      body: viewModel.currentStepWidget,
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: Theme.of(context).colorScheme.outlineVariant,
              ),
            ),
          ),
          child: Row(
            children: [
              OutlinedButton(
                onPressed: () => viewModel.previousStep(context),
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(120, 52)),
                  side: WidgetStatePropertyAll(
                    BorderSide(
                      color: AppColors.surfaceContainerHigh,
                      width: 1.5,
                    ),
                  ),
                ),
                child: Text(
                  "Back",
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
              ),

              const Spacer(),

              FilledButton(
                onPressed: () => viewModel.nextStep(context),
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size(120, 52)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (isLastStep) ...[
                      Icon(Icons.rocket_launch),
                      SizedBox(width: AppSpacing.sm),
                    ],
                    isLastStep ? Text("Create Project") : Text("Next"),
                    if (!isLastStep) ...[
                      SizedBox(width: AppSpacing.sm),
                      Icon(Icons.arrow_forward),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
