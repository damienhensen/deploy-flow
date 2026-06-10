import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/pages/deployment/widgets/deployment_body.dart';
import 'package:mobile/ui_layer/pages/logs/logs_page.dart';
import 'package:mobile/ui_layer/pages/project_details/project_details_page.dart';
import 'package:mobile/ui_layer/theme/app_colors.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';
import 'package:mobile/ui_layer/widgets/text_link.dart';

class DeploymentPage extends StatelessWidget {
  const DeploymentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: DeploymentBody(),
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.open_in_new),
                label: const Text("Open Website"),
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(52)),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              OutlinedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LogsPage()),
                  );
                },
                icon: const Icon(Icons.terminal),
                label: const Text("View Logs"),
                style: const ButtonStyle(
                  minimumSize: WidgetStatePropertyAll(Size.fromHeight(52)),
                ),
              ),

              const SizedBox(height: AppSpacing.md),

              Center(
                child: TextLink(
                  icon: false,
                  label: Text(
                    "Back to Project",
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.labelLarge?.copyWith(color: AppColors.primary),
                  ),
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProjectDetailsPage(),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
