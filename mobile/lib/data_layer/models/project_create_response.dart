class ProjectCreateResponse {
  final String id;
  final String name;

  ProjectCreateResponse({required this.id, required this.name});

  factory ProjectCreateResponse.fromJson(Map<String, dynamic> json) {
    return ProjectCreateResponse(id: json['id'], name: json['name']);
  }
}
