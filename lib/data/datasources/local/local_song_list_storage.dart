import 'package:hive/hive.dart';
import 'package:pelgrim/data/models/song_model.dart';

class LocalSongListStorage {
  static const String _boxName = "songBox";
  static const String _syncKey = "lastSync_";

  Future<void> updateLocalSongs(String groupId, List<SongModel> remoteSongs) async {
    final box = await Hive.openBox(_boxName);

    final dynamic rawData = box.get(groupId);
    Map<String, SongModel> localMap = {};

    if (rawData != null) {
      for (var s in List<SongModel>.from(rawData)) {
        localMap[s.id!] = s;
      }
    }

    for (var song in remoteSongs) {
      localMap[song.id!] = song;
    }

    await box.put(groupId, localMap.values.toList());
    await box.put("$_syncKey$groupId", DateTime.now().millisecondsSinceEpoch);
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

  Future<DateTime?> getLastSync(String groupId) async {
    final box = await Hive.openBox(_boxName);
    final int? ms = box.get("$_syncKey$groupId");
    return ms != null ? DateTime.fromMillisecondsSinceEpoch(ms) : null;
  }
}
