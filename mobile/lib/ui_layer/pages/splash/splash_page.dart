import 'package:flutter/material.dart';
import 'package:mobile/ui_layer/pages/login/login_page.dart';
import 'package:mobile/ui_layer/pages/projects/projects_page.dart';
import 'package:mobile/ui_layer/pages/splash/widgets/splash_body.dart';
import 'package:mobile/ui_layer/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkAuth();
    });
  }

  Future<void> _checkAuth() async {
    final auth = context.read<AuthProvider>();

    await auth.checkSession();

    if (!mounted) return;

    if (auth.isAuthenticated) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProjectsPage()),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashBody());
  }
}
