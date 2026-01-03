class Announcement {
  final String? id;
  final String author;
  final String content;
  final DateTime date;
  final bool important;
  final bool anonymous;

  Announcement(
      {this.id,
      required this.author,
      required this.content,
      required this.date,
      required this.important,
      required this.anonymous});
}
