import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/domain/entities/announcement.dart';

class AnnouncementModel {
  final String? id;
  final String author;
  final String content;
  final DateTime date;
  final bool important;
  final bool anonymous;

  AnnouncementModel(
      {this.id,
      required this.author,
      required this.content,
      required this.date,
      required this.important,
      required this.anonymous});

  Map<String, dynamic> toMap() {
    return {
      'Author': author,
      'Content': content,
      'Date': Timestamp.fromDate(date),
      'Important': important,
      'Anonymous': anonymous
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> json, String docId) {
    return AnnouncementModel(
        id: docId,
        author: (json['Author'] ?? '').replaceAll(RegExp(r'\s+'), ' ').trim(),
        content: json['Content'] ?? '',
        date: (json['Date'] as Timestamp?)?.toDate() ?? DateTime.now(),
        important: json['Important'],
        anonymous: json['Anonymous']);
  }

  factory AnnouncementModel.fromEntity(Announcement entity) {
    return AnnouncementModel(
      id: entity.id,
      author: entity.author,
      content: entity.content,
      date: entity.date,
      important: entity.important,
      anonymous: entity.anonymous,
    );
  }

  Announcement toEntity() {
    return Announcement(
      id: id,
      author: author,
      content: content,
      date: date,
      important: important,
      anonymous: anonymous,
    );
  }
}
