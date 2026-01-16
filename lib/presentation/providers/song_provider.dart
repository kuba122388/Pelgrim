import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/usecases/song/delete_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/edit_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/get_local_song_list_use_case.dart';
import 'package:pelgrim/domain/usecases/song/get_song_list_use_case.dart';
import 'package:pelgrim/domain/usecases/song/stream_song_use_case.dart';
import 'package:pelgrim/domain/usecases/song/watch_playing_now_use_case.dart';

class SongProvider extends ChangeNotifier {
  final GetLocalSongListUseCase _getLocalSongListUseCase;
  final GetSongListUseCase _getSongListUseCase;
  final WatchPlayingNowUseCase _watchPlayingNowUseCase;
  final StreamSongUseCase _streamSongUseCase;
  final EditSongUseCase _editSongUseCase;
  final DeleteSongUseCase _deleteSongUseCase;

  StreamSubscription? _subSongList;
  StreamSubscription? _subPlayingNow;

  List<Song> _songs = [];
  Song? _playingNowSong;
  bool _isLoading = true;

  List<Song> get songs => _songs;

  Song? get playingNowSong => _playingNowSong;

  bool get isLoading => _isLoading;

  SongProvider(
    this._getLocalSongListUseCase,
    this._getSongListUseCase,
    this._watchPlayingNowUseCase,
    this._streamSongUseCase,
    this._editSongUseCase,
    this._deleteSongUseCase,
  );

  Future<void> deleteSong(String groupId, String songId) async {
    await _deleteSongUseCase.execute(groupId, songId);
  }

  Future<void> startSongList(String groupId) async {
    _isLoading = true;
    notifyListeners();

    final cached = await _getLocalSongListUseCase.execute(groupId);
    if (cached.isNotEmpty) {
      _songs = cached;
      _isLoading = false;
      notifyListeners();
    }
    _subSongList?.cancel();
    _subSongList = _getSongListUseCase.execute(groupId).listen((remoteChanges) async {
      _songs = remoteChanges;
      _isLoading = false;
      notifyListeners();
    });

    _subPlayingNow?.cancel();
    _subPlayingNow = _watchPlayingNowUseCase.execute(groupId).listen((song) {
      _playingNowSong = song;
      notifyListeners();
    });
  }

  Future<void> streamSong(String groupId, Song song) async {
    await _streamSongUseCase.execute(groupId, song);
  }

  Future<void> editSong(String groupId, Song song) async {
    await _editSongUseCase.execute(groupId, song);
  }

  @override
  void dispose() {
    _subSongList?.cancel();
    _subPlayingNow?.cancel();
    super.dispose();
  }
}
