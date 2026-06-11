import 'package:flutter/material.dart';
import 'package:mobile/data_layer/models/git_branch_deployment_check.dart';
import 'package:mobile/data_layer/models/git_branch_list_item.dart';
import 'package:mobile/data_layer/models/git_repository_list_item.dart';
import 'package:mobile/data_layer/repositories/project_repository.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/branch_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/domain_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/provider_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/repository_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/verify_step.dart';
import 'package:mobile/ui_layer/pages/deployment/deployment_page.dart';
import 'package:mobile/ui_layer/pages/project_details/project_details_page.dart';
import 'package:mobile/ui_layer/providers/projects_provider.dart';
import 'package:provider/provider.dart';

class CreateProjectProvider extends ChangeNotifier {
  final ProjectRepository repository;

  CreateProjectProvider(this.repository);

  // Net State
  bool isLoading = false;
  String? error;

  bool hasDockerCompose = false;

  final List<Widget> _steps = [
    RepositoryStep(),
    BranchStep(),
    ProviderStep(),
    DomainStep(),
    VerifyStep(),
  ];

  // Local State
  List<GitRepositoryListItem> _availableRepositories = [];
  List<GitBranchListItem> _availableBranches = [];
  final List<String> _availableProviders = ["DigitalOcean"];
  final List<String> _comingProviders = ["TransIP", "AWS", "Hetzner"];

  GitRepositoryListItem? _selectedRepository;
  GitBranchListItem? _selectedBranch;
  late String _selectedProvider = _availableProviders[0];
  bool _usingCustomDomain = false;
  String _domain = "";
  String _subdomain = "";

  int _currentStep = 0;

  int get totalSteps => _steps.length;
  int get currentStep => _currentStep + 1;
  Widget get currentStepWidget => _steps[_currentStep];

  GitRepositoryListItem? get selectedRepository => _selectedRepository;
  List<GitRepositoryListItem> get repositories => _availableRepositories;

  GitBranchListItem? get selectedBranch => _selectedBranch;
  List<GitBranchListItem> get branches => _availableBranches;

  String get selectedProvider => _selectedProvider;
  Map<String, bool> get providers => {
    for (final provider in _availableProviders) provider: false,
    for (final provider in _comingProviders) provider: true,
  };

  bool get usingCustomDomain => _usingCustomDomain;
  String get domain => _domain;
  String get subdomain => _subdomain;
  String get domainPreview => _domain.isNotEmpty
      ? (_subdomain.isNotEmpty ? "$_subdomain.$_domain" : _domain)
      : "${_selectedRepository?.name.toLowerCase()}-xyz.deployflow.app";

  // Setters
  void setRepository(GitRepositoryListItem repository) {
    _selectedRepository = repository;
    notifyListeners();
  }

  void setBranch(GitBranchListItem branch) {
    _selectedBranch = branch;
    notifyListeners();
  }

  void setProvider(String provider) {
    _selectedProvider = provider;
    notifyListeners();
  }

  void setUsingCustomDomain(bool useCustomDomain) {
    _usingCustomDomain = useCustomDomain;
    notifyListeners();
  }

  void setDomain(String domain) {
    _domain = domain;
    notifyListeners();
  }

  void setSubdomain(String subdomain) {
    _subdomain = subdomain;
    notifyListeners();
  }

  // Methods
  void nextStep(BuildContext context) async {
    if (currentStep == totalSteps) {
      if (await createProject()) {
        if (!context.mounted) return;

        // Reload projects
        context.read<ProjectsProvider>().loadProjects();

        if (hasDockerCompose) {
          // Navigate to deployment page
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const DeploymentPage()),
          );
        } else {
          // Navigate to project page
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ProjectDetailsPage()),
          );
        }

        // Reset state
        _currentStep = 0;
        _selectedRepository = _availableRepositories[0];
        _selectedBranch = _availableBranches[0];
        _selectedProvider = _availableProviders[0];
        _usingCustomDomain = false;
        _domain = "";
        _subdomain = "";

        notifyListeners();
      }

      return;
    }

    if (_currentStep == 0) {
      loadBranches();
    }

    if (currentStep == totalSteps - 1) {
      deploymentCheck();
    }

    _currentStep += 1;
    notifyListeners();
  }

  void previousStep(BuildContext context) {
    if (_currentStep == 0) return Navigator.pop(context);

    _currentStep -= 1;
    notifyListeners();
  }

  // Load data
  Future<void> loadRepositories() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      _availableRepositories = await repository.getRepositories();
      _selectedRepository = _availableRepositories[0];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  Future<void> loadBranches() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      if (_selectedRepository == null) return;

      _availableBranches = await repository.getBranches(
        _selectedRepository!.owner,
        _selectedRepository!.name,
      );
      _selectedBranch = _availableBranches[0];
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  Future<void> deploymentCheck() async {
    isLoading = true;
    error = null;
    hasDockerCompose = false;
    notifyListeners();

    try {
      if (_selectedRepository == null) return;
      if (_selectedBranch == null) return;

      GitBranchDeploymentCheck check = await repository.deploymentCheck(
        _selectedRepository!.owner,
        _selectedRepository!.name,
        _selectedBranch!.name,
      );

      hasDockerCompose = check.hasDockerCompose;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }

    notifyListeners();
  }

  // Create project / Start deployment
  Future<bool> createProject() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await repository.createProject(
        _selectedRepository!.name,
        _selectedRepository!.url,
        _selectedBranch!.name,
        _selectedProvider,
        _domain,
        _subdomain,
      );
      return true;
    } catch (e) {
      error = e.toString();
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
