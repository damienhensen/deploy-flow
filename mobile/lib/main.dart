import 'package:flutter/material.dart';
import 'package:mobile/app.dart';
import 'package:mobile/ui_layer/providers/create_project_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CreateProjectProvider()),
      ],
      child: const App(),
    ),
  );
}
