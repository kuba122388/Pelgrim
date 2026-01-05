import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class WatchPlayingNowUseCase {
  final SongRepository _songRepository;

  WatchPlayingNowUseCase(this._songRepository);

  Stream<Song> execute(String groupName, String songId) {
    return _songRepository.watchPlayingNow(groupName);
  }
}
