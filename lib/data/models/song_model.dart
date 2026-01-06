import 'package:hive/hive.dart';

import '../../domain/entities/song.dart';

part 'song_model.g.dart';

@HiveType(typeId: 2)
class SongModel extends HiveObject {
  @HiveField(0)
  String? id;

  @HiveField(1)
  String title;

  @HiveField(2)
  String lyrics;

  SongModel({this.id, required this.title, required this.lyrics});

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Lyrics': lyrics,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map, String? docId) {
    return SongModel(
      id: docId,
      title: map['Title'] ?? '',
      lyrics: map['Lyrics'] ?? '',
    );
  }

  factory SongModel.fromEntity(Song entity) {
    return SongModel(
      id: entity.id,
      title: entity.title,
      lyrics: entity.lyrics,
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
