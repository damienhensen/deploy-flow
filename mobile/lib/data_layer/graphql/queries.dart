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
}
