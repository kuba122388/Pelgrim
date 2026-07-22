import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class StreamSongUseCase {
  final SongRepository _songRepository;

  StreamSongUseCase(this._songRepository);

  Future<void> execute(String groupId, Song song) async {
    return _songRepository.streamSong(groupId, song);
  }
}
