import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/data_layer/graphql/mutations.dart';
import 'package:mobile/data_layer/graphql/queries.dart';
import 'package:mobile/data_layer/models/git_branch_deployment_check.dart';
import 'package:mobile/data_layer/models/git_branch_list_item.dart';
import 'package:mobile/data_layer/models/git_repository_list_item.dart';
import 'package:mobile/data_layer/models/project_create_response.dart';
import 'package:mobile/data_layer/models/project_list_item.dart';

class ProjectRepository {
  final GraphQLClient client;

  ProjectRepository(this.client);

  Future<List<ProjectListItem>> getProjects() async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProjectQueries.getProjects),
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List projects = result.data?['projects'] ?? [];

    return projects.map((json) => ProjectListItem.fromJson(json)).toList();
  }

  Future<List<GitRepositoryListItem>> getRepositories() async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProjectQueries.getRepositories),
        variables: {"provider": "github"},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List repositories = result.data?['gitRepositories'] ?? [];

    return repositories
        .map((json) => GitRepositoryListItem.fromJson(json))
        .toList();
  }

  Future<List<GitBranchListItem>> getBranches(String owner, String repo) async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProjectQueries.getBranches),
        variables: {"provider": "github", "owner": owner, "repo": repo},
        fetchPolicy: FetchPolicy.cacheAndNetwork,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final List branches = result.data?['gitBranches'] ?? [];

    return branches.map((json) => GitBranchListItem.fromJson(json)).toList();
  }

  Future<GitBranchDeploymentCheck> deploymentCheck(
    String owner,
    String repo,
    String branch,
  ) async {
    final result = await client.query(
      QueryOptions(
        document: gql(ProjectQueries.deploymentCheck),
        variables: {
          "provider": "github",
          "owner": owner,
          "repo": repo,
          "branch": branch,
        },
        fetchPolicy: FetchPolicy.networkOnly,
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final json = result.data!['gitBranchDeploymentCheck'];

    return GitBranchDeploymentCheck.fromJson(json);
  }

  Future<ProjectCreateResponse> createProject(
    String name,
    String repositoryUrl,
    String branch,
    String provider,
    String domain,
    String subdomain,
  ) async {
    final result = await client.mutate(
      MutationOptions(
        document: gql(ProjectMutations.createProject),
        variables: {
          "input": {
            "name": name,
            "repositoryUrl": repositoryUrl,
            "branch": branch,
            "provider": provider,
            "domain": domain,
            "subdomain": subdomain,
          },
        },
      ),
    );

    if (result.hasException) {
      throw Exception(result.exception.toString());
    }

    final json = result.data!["createProject"];

    return ProjectCreateResponse.fromJson(json);
  }
}
