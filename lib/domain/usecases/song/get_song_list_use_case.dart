import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class GetSongListUseCase {
  final SongRepository _songRepository;

  GetSongListUseCase(this._songRepository);

  Stream<List<Song>> execute(
    String groupId,
  ) {
    return _songRepository.getSongs(groupId);
  }
}
