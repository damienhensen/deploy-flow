class GitBranchDeploymentCheck {
  final bool hasDockerCompose;
  final String composeFilePath;

  GitBranchDeploymentCheck({
    required this.hasDockerCompose,
    required this.composeFilePath,
  });

  factory GitBranchDeploymentCheck.fromJson(Map<String, dynamic> json) {
    return GitBranchDeploymentCheck(
      hasDockerCompose: json['hasDockerCompose'],
      composeFilePath: json['composeFilePath'],
    );
  }
}
