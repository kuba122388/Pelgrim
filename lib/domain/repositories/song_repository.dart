import 'package:pelgrim/domain/entities/song.dart';

abstract class SongRepository {
  Future<List<Song>> getSongList(String groupName);

  Future<void> addSong(String groupName, Song song);

  Future<void> editSong(String groupName, Song song);

  Future<void> deleteSong(String groupName, String songId);

  Future<void> requestSong(String groupName, Song song);

  Stream<Song> watchPlayingNow(String groupName);
}
