class ProjectQueries {
  static const getProjects = r'''
    query GetProjects {
      projects {
        id
        name
        branch
        provider
      }
    }
  ''';

  static const getRepositories = r'''
    query GetRepositories($provider: String!) {
      gitRepositories(provider: $provider) {
        id
        name
        owner
        url
        defaultBranch
        updatedAt
        visibility
      }
    }
  ''';

  static const getBranches = r"""
    query GetBranches($provider: String!, $owner: String!, $repo: String!) {
      gitBranches(
        provider: $provider,
        owner: $owner,
        repo: $repo
      ) {
        name
        updatedAt
        lastCommitAuthorName
      }
    }
  """;

  static const deploymentCheck = r"""
    query DeploymentCheck($provider: String!, $owner: String!, $repo: String!, $branch: String!) {
      gitBranchDeploymentCheck(
        provider: $provider,
        owner: $owner,
        repo: $repo,
        branch: $branch,
      ) {
        hasDockerCompose
        composeFilePath
      }
    }
  """;
}
