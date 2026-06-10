class ProjectListItem {
  final String id;
  final String name;
  final String branch;
  final String provider;

  ProjectListItem({
    required this.id,
    required this.name,
    required this.branch,
    required this.provider,
  });

  factory ProjectListItem.fromJson(Map<String, dynamic> json) {
    return ProjectListItem(
      id: json['id'],
      name: json['name'],
      branch: json['branch'],
      provider: json['provider'],
    );
  }
}
