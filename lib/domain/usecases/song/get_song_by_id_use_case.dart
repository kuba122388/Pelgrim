import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class GetSongByIdUseCase {
  final SongRepository _songRepository;

  GetSongByIdUseCase(this._songRepository);

  Future<Song?> execute(String groupName, String songId) {
    return _songRepository.getSongById(groupName, songId);
  }
}
