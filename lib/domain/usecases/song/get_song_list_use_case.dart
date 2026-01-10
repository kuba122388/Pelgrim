import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class WatchSongListUseCase {
  final SongRepository _songRepository;

  WatchSongListUseCase(this._songRepository);

  Stream<List<Song>> execute(String groupId) {
    return _songRepository.watchSongList(groupId);
  }
}
