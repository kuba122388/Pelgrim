import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class EditSongUseCase {
  final SongRepository _songRepository;

  EditSongUseCase(this._songRepository);

  Future<void> execute(String groupName, Song song) async {
    return await _songRepository.editSong(groupName, song);
  }
}
