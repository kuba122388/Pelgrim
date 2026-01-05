import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class LoadSongUseCase {
  final SongRepository _songRepository;

  LoadSongUseCase(this._songRepository);

  Future<List<Song>> execute(String groupName) async {
    return await _songRepository.getSongList(groupName);
  }
}
