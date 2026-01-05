import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class RequestSongUseCase {
  final SongRepository _songRepository;

  RequestSongUseCase(this._songRepository);

  Future<void> execute(String groupName, Song song) async {
    return await _songRepository.requestSong(groupName, song);
  }
}
