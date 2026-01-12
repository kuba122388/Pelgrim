import 'package:hive/hive.dart';
import 'package:pelgrim/data/models/song_model.dart';

class LocalSongListStorage {
  static const String _boxName = "songBox";

  Future<void> saveSongs(List<SongModel> songList, String groupId) async {
    final box = await Hive.openBox(_boxName);
    await box.put(groupId, songList);
  }

  Future<List<SongModel>?> getSongList(String groupId) async {
    final box = await Hive.openBox(_boxName);
    final rawData = box.get(groupId);

    if (rawData == null) return null;

    try {
      return List<SongModel>.from(rawData);
    } catch (e) {
      print("Błąd rzutowania listy z Hive: $e");
      return null;
    }
  }

  Future<void> clearSongList(String groupId) async {
    final box = await Hive.openBox<List<SongModel>>(_boxName);
    await box.delete(groupId);
  }
}
