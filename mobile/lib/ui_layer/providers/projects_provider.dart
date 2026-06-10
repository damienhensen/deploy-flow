import 'package:flutter/material.dart';
import 'package:mobile/data_layer/models/project_list_item.dart';
import 'package:mobile/data_layer/repositories/project_repository.dart';

class ProjectsProvider extends ChangeNotifier {
  final ProjectRepository repository;

  ProjectsProvider(this.repository);

  bool isLoading = false;
  String? error;
  List<ProjectListItem> projects = [];

  Future<void> loadProjects() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      projects = await repository.getProjects();
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }
}
