import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive/hive.dart';

import '../../domain/entities/song.dart';

part 'song_model.g.dart';

@HiveType(typeId: 3)
class SongModel extends HiveObject {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String lyrics;

  @HiveField(3)
  final DateTime updatedAt;

  @HiveField(4)
  final bool deleted;

  SongModel({
    this.id,
    required this.title,
    required this.lyrics,
    required this.updatedAt,
    this.deleted = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'lyrics': lyrics,
      'deleted': deleted,
      'updated_at': FieldValue.serverTimestamp(),
    };
  }

  factory SongModel.fromMap(
    Map<String, dynamic> map, {
    required String id,
  }) {
    final ts = map['updated_at'] as Timestamp?;

    return SongModel(
      id: id,
      title: map['title'] ?? '',
      lyrics: map['lyrics'] ?? '',
      updatedAt: ts?.toDate() ?? DateTime.fromMillisecondsSinceEpoch(0),
      deleted: map['deleted'] == true,
    );
  }

  factory SongModel.fromEntity(Song entity) {
    return SongModel(
      id: entity.id,
      title: entity.title,
      lyrics: entity.lyrics,
      updatedAt: DateTime.now(),
    );
  }

  Song toEntity() {
    return Song(
      id: id,
      title: title,
      lyrics: lyrics,
    );
  }
}
