import 'package:pelgrim/domain/repositories/song_repository.dart';

class DeleteSongUseCase {
  final SongRepository _songRepository;

  DeleteSongUseCase(this._songRepository);

  Future<void> execute(String groupName, String songId) async {
    return await _songRepository.deleteSong(groupName, songId);
  }
}
