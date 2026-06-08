import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/pages/projects/widgets/projects_body.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Scaffold(body: ProjectsBody()));
  }
}
