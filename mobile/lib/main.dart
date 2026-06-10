import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:mobile/data_layer/graphql/graphql_client.dart';
import 'package:mobile/data_layer/repositories/project_repository.dart';
import 'package:mobile/ui_layer/providers/auth_provider.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:mobile/ui_layer/providers/projects_provider.dart';
import 'package:provider/provider.dart';

void main() {
  final graphQLClient = DeployFlowGraphQLClient.create();

  runApp(
    MultiProvider(
      providers: [
        Provider.value(value: graphQLClient),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(
          create: (_) => ProjectsProvider(ProjectRepository(graphQLClient)),
        ),
        ChangeNotifierProvider(create: (_) => CreateProjectProvider()),
      ],
      child: const App(),
    ),
  );
}
