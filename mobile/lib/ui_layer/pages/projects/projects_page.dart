import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/pages/projects/widgets/projects_body.dart';
import 'package:mobile/ui_layer/providers/projects_provider.dart';
import 'package:provider/provider.dart';

class ProjectsPage extends StatefulWidget {
  const ProjectsPage({super.key});

  @override
  State<StatefulWidget> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProjectsProvider>().loadProjects();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: ProjectsBody());
  }
}
