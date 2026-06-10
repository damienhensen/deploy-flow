class ProjectMutations {
  static const createProject = r'''
    mutation CreateProject($input: CreateProjectInput!) {
      createProject(input: $input) {
        id
        name
      }
    }
  ''';
}
