class Announcement {
  final String? id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final bool important;
  final bool anonymous;

  Announcement({
    this.id,
    required this.authorId,
    required this.authorName,
    required this.content,
    required this.createdAt,
    required this.important,
    required this.anonymous,
  });
}
