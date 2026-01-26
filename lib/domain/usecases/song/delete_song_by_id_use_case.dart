import 'package:pelgrim/domain/repositories/song_repository.dart';

class DeleteSongByIdUseCase {
  final SongRepository _songRepository;

  DeleteSongByIdUseCase(this._songRepository);

  Future<void> execute(String groupId, String songId) async {
    return _songRepository.deleteSongById(groupId, songId);
  }
}
