import 'package:flutter/material.dart';
import 'package:mobile/data_layer/repositories/project_repository.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/branch_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/domain_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/provider_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/repository_step.dart';
import 'package:mobile/ui_layer/pages/create_project/widgets/verify_step.dart';
import 'package:mobile/ui_layer/pages/deployment/deployment_page.dart';
import 'package:mobile/ui_layer/providers/projects_provider.dart';
import 'package:provider/provider.dart';

class CreateProjectProvider extends ChangeNotifier {
  final ProjectRepository repository;

  CreateProjectProvider(this.repository);

  // Net State
  bool isLoading = false;
  String? error;

  final List<Widget> _steps = [
    RepositoryStep(),
    BranchStep(),
    ProviderStep(),
    DomainStep(),
    VerifyStep(),
  ];

  // Local State
  final List<String> _availableRepositories = ["Portfolio", "FixMyCity"];
  final List<String> _availableBranches = ["main", "develop", "feat/auth"];
  final List<String> _availableProviders = ["DigitalOcean"];
  final List<String> _comingProviders = ["TransIP", "AWS", "Hetzner"];

  late String _selectedRepository = _availableRepositories[0];
  late String _selectedBranch = _availableBranches[0];
  late String _selectedProvider = _availableProviders[0];
  bool _usingCustomDomain = false;
  String _domain = "";
  String _subdomain = "";

  int _currentStep = 0;

  int get totalSteps => _steps.length;
  int get currentStep => _currentStep + 1;
  Widget get currentStepWidget => _steps[_currentStep];

  String get selectedRepository => _selectedRepository;
  List<String> get repositories => _availableRepositories;

  String get selectedBranch => _selectedBranch;
  List<String> get branches => _availableBranches;

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
      : "${_selectedRepository.toLowerCase()}-xyz.deployflow.app";

  // Setters
  void setRepository(String repository) {
    _selectedRepository = repository;
    notifyListeners();
  }

  void setBranch(String branch) {
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

        // Navigate to deployment page
        await Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const DeploymentPage()),
        );

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

    _currentStep += 1;
    notifyListeners();
  }

  void previousStep(BuildContext context) {
    if (_currentStep == 0) return Navigator.pop(context);

    _currentStep -= 1;
    notifyListeners();
  }

  // Create project / Start deployment
  Future<bool> createProject() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      await repository.createProject(
        "placeholder",
        _selectedRepository,
        _selectedBranch,
        _selectedProvider,
      );
      return true;
    } catch (e) {
      error = e.toString();
      debugPrint(e.toString());
      return false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
