import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class GetSongUseCase {
  final SongRepository _songRepository;

  GetSongUseCase(this._songRepository);

  Future<Song?> execute(String groupName, String songId) {
    return _songRepository.getSong(groupName, songId);
  }
}
