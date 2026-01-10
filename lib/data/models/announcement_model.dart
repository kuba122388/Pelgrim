import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/domain/entities/announcement.dart';

class AnnouncementModel {
  final String? id;
  final String authorId;
  final String authorName;
  final String content;
  final DateTime createdAt;
  final bool isImportant;
  final bool isAnonymous;

  AnnouncementModel(
      {this.id,
      required this.authorId,
      required this.authorName,
      required this.content,
      required this.createdAt,
      required this.isImportant,
      required this.isAnonymous});

  Map<String, dynamic> toMap() {
    return {
      'authorId': authorId,
      'authorName': authorName,
      'content': content,
      'createdAt': Timestamp.fromDate(createdAt),
      'isImportant': isImportant,
      'isAnonymous': isAnonymous
    };
  }

  factory AnnouncementModel.fromMap(Map<String, dynamic> json, String docId) {
    return AnnouncementModel(
      id: docId,
      authorId: (json['authorId']) ?? '',
      authorName: json['authorName'] ?? '',
      content: json['content'] ?? '',
      createdAt: (json['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      isImportant: json['isImportant'] ?? false,
      isAnonymous: json['isAnonymous'] ?? false,
    );
  }

  factory AnnouncementModel.fromEntity(Announcement entity) {
    return AnnouncementModel(
      id: entity.id,
      authorId: entity.authorId,
      authorName: entity.authorName,
      content: entity.content,
      createdAt: entity.createdAt,
      isImportant: entity.important,
      isAnonymous: entity.anonymous,
    );
  }

  Announcement toEntity() {
    return Announcement(
      id: id,
      authorId: authorId,
      authorName: authorName,
      content: content,
      createdAt: createdAt,
      important: isImportant,
      anonymous: isAnonymous,
    );
  }
}
