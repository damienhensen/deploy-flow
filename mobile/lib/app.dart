import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/pages/projects/projects_page.dart';
import 'package:mobile/ui_layer/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'DeployFlow',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      home: const ProjectsPage(),
    );
  }
}
