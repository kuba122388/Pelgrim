import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class GetLocalSongListUseCase {
  final SongRepository _songRepository;

  GetLocalSongListUseCase(this._songRepository);

  Future<List<Song>> execute(String groupId) {
    return _songRepository.getLocalSongList(groupId);
  }
}
