import 'package:pelgrim/domain/entities/song.dart';

class SongModel {
  String? id;
  String title;
  String lyrics;

  SongModel({this.id, required this.title, required this.lyrics});

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Lyrics': lyrics,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map, docId) {
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
