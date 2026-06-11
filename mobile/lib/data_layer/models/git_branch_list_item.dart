class GitBranchListItem {
  final String name;
  final String updatedAt;
  final String lastCommitAuthorName;

  GitBranchListItem({
    required this.name,
    required this.updatedAt,
    required this.lastCommitAuthorName,
  });

  factory GitBranchListItem.fromJson(Map<String, dynamic> json) {
    return GitBranchListItem(
      name: json['name'],
      updatedAt: json['updatedAt'],
      lastCommitAuthorName: json['lastCommitAuthorName'],
    );
  }
}
