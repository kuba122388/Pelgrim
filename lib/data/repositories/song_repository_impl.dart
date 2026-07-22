import 'dart:async';

import 'package:pelgrim/core/errors/repository_exception.dart';
import 'package:pelgrim/data/datasources/local/local_song_list_storage.dart';
import 'package:pelgrim/data/datasources/remote/song_data_source.dart';
import 'package:pelgrim/data/models/song_model.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class SongRepositoryImpl extends SongRepository {
  final SongDataSource _songDataSource;
  final LocalSongListStorage _localSongListStorage;

  SongRepositoryImpl(
    this._songDataSource,
    this._localSongListStorage,
  );

  @override
  Future<void> addSong(String groupId, Song song) async {
    try{
      return await _songDataSource.addSong(groupId, SongModel.fromEntity(song));
    } catch (e){
      throw RepositoryException("Wystapił problem. Dodanie piosenki nie powiodło się.");
    }
  }

  @override
  Future<void> editSong(String groupId, Song song) async {
    try{
      return await _songDataSource.editSong(groupId, SongModel.fromEntity(song));
    } catch (e){
      throw RepositoryException("Wystąpił problem. Edycja piosenki nie powiodła się.");
    }
  }

  @override
  Future<Song?> getSongById(String groupId, String songId) async {
    try {
      final SongModel? model = await _songDataSource.getSong(groupId, songId);

      return model?.toEntity();
    } catch (e) {
      throw Exception('Wystąpił problem. Nie udało się wczytać piosenki.');
    }
  }

  @override
  Future<void> deleteSongById(String groupId, String songId) async {
    try{
      return await _songDataSource.deleteSong(groupId, songId);
    } catch (e){
      throw RepositoryException("Wystąpił problem. Piosenka nie została usunięta.");
    }
  }

  @override
  Stream<List<Song>> getSongs(String groupId) {
    final controller = StreamController<List<Song>>();
    StreamSubscription<List<SongModel>>? remoteSub;

    () async {
      final localSongs = await _localSongListStorage.getSongList(groupId);
      if (localSongs != null && !controller.isClosed) {
        controller.add(localSongs.map((e) => e.toEntity()).toList());
      }
      final lastSync = await _localSongListStorage.getLastSync(groupId);

      remoteSub = _songDataSource
          .getSongs(groupId, lastSync: lastSync)
          .listen((remoteSongs) async {
        if (remoteSongs.isEmpty) return;

        await _localSongListStorage.updateLocalSongs(groupId, remoteSongs);

        final updatedLocal = await _localSongListStorage.getSongList(groupId);
        if (updatedLocal != null && !controller.isClosed) {
          controller.add(updatedLocal.map((e) => e.toEntity()).toList());
        }

      });
    }();

    controller.onCancel = () async {
      await remoteSub?.cancel();
      await controller.close();
    };

    return controller.stream;
  }


  @override
  Stream<Song?> getPlayingNowStream(String groupId) {
    return _songDataSource.getPlayingNowStream(groupId).map((s) => s?.toEntity());
  }

  @override
  Future<void> streamSong(String groupId, Song song) async {
    try{
      return await _songDataSource.streamSong(groupId, SongModel.fromEntity(song));
    } catch (e){
      throw RepositoryException("Wystąpił problem ze strumieniowaniem piosenki.");
    }
  }

  @override
  Future<List<Song>> getLocalSongList(String groupId) async {
    try{
      final songModelList = await _localSongListStorage.getSongList(groupId);
      return songModelList?.map((s) => s.toEntity()).toList() ?? [];
    } catch (e){
      throw RepositoryException("Wystąpił problem z załadowaniem lokalnych piosenek.");
    }
  }

  @override
  Future<DateTime?> getLastSync(String groupId) async {
    try{
      return await _localSongListStorage.getLastSync(groupId);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z pobraniem daty ostatniej synchronizacji.");
    }
  }
}
