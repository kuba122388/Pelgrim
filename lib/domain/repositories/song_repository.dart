import 'package:pelgrim/domain/entities/song.dart';

abstract class SongRepository {
  Stream<List<Song>> getSongs(String groupId);

  Future<List<Song>> getLocalSongList(String groupId);

  Future<DateTime?> getLastSync(String groupId);

  Future<void> addSong(String groupId, Song song);

  Future<void> editSong(String groupId, Song song);

  Future<Song?> getSong(String groupId, String songId);

  Future<void> deleteSong(String groupId, String songId);

  Future<void> streamSong(String groupId, Song song);

  Stream<Song?> getPlayingNowStream(String groupId);
}
