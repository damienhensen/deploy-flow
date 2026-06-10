import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/pages/login/widgets/login_body.dart';
import 'package:mobile/ui_layer/pages/projects/projects_page.dart';
import 'package:mobile/ui_layer/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<AuthProvider>();

    if (viewModel.isAuthenticated) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ProjectsPage()),
        );
      });
    }

    return Scaffold(body: LoginBody());
  }
}
