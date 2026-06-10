import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:mobile/data_layer/graphql/graphql_client.dart';
import 'package:mobile/data_layer/repositories/auth_repository.dart';
import 'package:mobile/data_layer/repositories/project_repository.dart';
import 'package:mobile/data_layer/services/auth_service.dart';
import 'package:mobile/ui_layer/providers/auth_provider.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/providers/projects_provider.dart';
import 'package:provider/provider.dart';

void main() {
  final graphQLClient = DeployFlowGraphQLClient.create(AuthRepository());

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: graphQLClient),
        ChangeNotifierProvider(
          create: (_) => AuthProvider(
            authRepository: AuthRepository(),
            authService: AuthService(),
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => ProjectsProvider(ProjectRepository(graphQLClient)),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              CreateProjectProvider(ProjectRepository(graphQLClient)),
        ),
      ],
      child: const App(),
    ),
  );
}
