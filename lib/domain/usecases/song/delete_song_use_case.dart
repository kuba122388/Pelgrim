import 'package:pelgrim/domain/repositories/song_repository.dart';

class DeleteSongUseCase {
  final SongRepository _songRepository;

  DeleteSongUseCase(this._songRepository);

  Future<void> execute(String groupId, String songId) async {
    return _songRepository.deleteSong(groupId, songId);
  }
}
