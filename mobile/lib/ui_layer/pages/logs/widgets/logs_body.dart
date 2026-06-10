import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/layouts/deploy_flow_sliver_page.dart';
import 'package:mobile/ui_layer/pages/logs/widgets/log_output_view.dart';
import 'package:mobile/ui_layer/theme/app_spacing.dart';

class LogsBody extends StatelessWidget {
  const LogsBody({super.key});

  @override
  Widget build(BuildContext context) {
    bool expanded = true;

    return DeployFlowSliverPage(
      title: Text(
        "Portfolio - Logs",
        style: Theme.of(context).textTheme.headlineMedium,
      ),
      actions: [
        IconButton(onPressed: () {}, icon: Icon(Icons.notifications_none)),
      ],
      slivers: [
        SliverPadding(
          padding: const EdgeInsets.all(AppSpacing.md),
          sliver: SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: .stretch,
              children: [
                LogOutputView(
                  expanded: expanded,
                  onToggle: () {},
                  logLines: const [
                    r"$ docker compose up -d",
                    "",
                    'Creating network "app_default"...',
                    'Creating app_db_1 ... done',
                    'Creating app_backend_1 ... done',
                    '',
                    'backend_1 exited with code 1',
                    '',
                    'Error: Cannot find module "/app/server.js"',
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
