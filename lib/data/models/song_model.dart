class SongModel {
  String? docId;
  String title;
  String lyrics;

  SongModel({this.docId, required this.title, required this.lyrics});

  Map<String, dynamic> toMap() {
    return {
      'Title': title,
      'Lyrics': lyrics,
    };
  }

  factory SongModel.fromMap(Map<String, dynamic> map, docId) {
    return SongModel(
      docId: docId,
      title: map['Title'] ?? '',
      lyrics: map['Lyrics'] ?? '',
    );
  }
}
