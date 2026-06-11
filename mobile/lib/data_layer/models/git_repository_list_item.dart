class GitRepositoryListItem {
  final String id;
  final String name;
  final String owner;
  final String url;
  final String defaultBranch;
  final String updatedAt;
  final String visibility;

  GitRepositoryListItem({
    required this.id,
    required this.name,
    required this.owner,
    required this.url,
    required this.defaultBranch,
    required this.updatedAt,
    required this.visibility,
  });

  factory GitRepositoryListItem.fromJson(Map<String, dynamic> json) {
    return GitRepositoryListItem(
      id: json['id'],
      name: json['name'],
      owner: json['owner'],
      url: json['url'],
      defaultBranch: json['defaultBranch'],
      updatedAt: json['updatedAt'],
      visibility: json['visibility'],
    );
  }
}
