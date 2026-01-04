import 'package:pelgrim/data/models/song_model.dart';
import 'package:pelgrim/data/datasources/song_datasource.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class SongRepositoryImpl extends SongRepository {
  final SongDataSource _songService;

  SongRepositoryImpl(this._songService);

  @override
  Future<void> addSong(String groupName, Song song) async {
    try {
      await _songService.addSong(groupName, SongModel.fromEntity(song));
    } catch (e) {
      throw Exception("Nie udało się dodać piosenki: $e");
    }
  }

  @override
  Future<void> editSong(String groupName, Song song) async {
    try {
      await _songService.editSong(groupName, SongModel.fromEntity(song));
    } catch (e) {
      throw Exception("Nie udało się edytować piosenki: $e");
    }
  }

  @override
  Future<void> deleteSong(String groupName, String songId) async {
    try {
      await _songService.deleteSong(groupName, songId);
    } catch (e) {
      throw Exception("Nie udało się usunąć piosenki: $e");
    }
  }

  @override
  Future<List<Song>> getSongList(String groupName) async {
    try {
      List<SongModel> list = await _songService.loadSongs(groupName);
      return list.map((s) => s.toEntity()).toList();
    } catch (e) {
      throw Exception("Wystąpił problem z załadowaniem piosenek: $e");
    }
  }

  @override
  Stream<Song> watchPlayingNow(String groupName) {
    try {
      return _songService.watchPlayingNow(groupName).map((s) => s.toEntity());
    } catch (e) {
      throw Exception("Wystąpił problem ze śledzeniem strumienia: $e");
    }
  }

  @override
  Future<void> requestSong(String groupName, Song song) async {
    try {
      await _songService.requestSong(groupName, SongModel.fromEntity(song));
    } catch (e) {
      throw Exception("Wystąpił problem z strumieniowaniem piosenki: $e");
    }
  }
}
