import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:mobile/data_layer/graphql/mutations.dart';
import 'package:mobile/data_layer/graphql/queries.dart';
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

  Future<ProjectCreateResponse> createProject(
    String name,
    String repositoryUrl,
    String branch,
    String provider,
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
