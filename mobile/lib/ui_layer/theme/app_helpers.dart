class AppHelpers {
  static String timeAgo(String date) {
    final updatedAt = DateTime.parse(date);

    final difference = DateTime.now().difference(updatedAt);

    if (difference.inSeconds < 60) {
      return "just now";
    }

    if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return "$minutes minute${minutes == 1 ? "" : "s"} ago";
    }

    if (difference.inHours < 24) {
      final hours = difference.inHours;
      return "$hours hour${hours == 1 ? "" : "s"} ago";
    }

    if (difference.inDays < 30) {
      final days = difference.inDays;
      return "$days day${days == 1 ? "" : "s"} ago";
    }

    if (difference.inDays < 365) {
      final months = difference.inDays ~/ 30;
      return "$months month${months == 1 ? "" : "s"} ago";
    }

    final years = difference.inDays ~/ 365;
    return "$years year${years == 1 ? "" : "s"} ago";
  }
}
