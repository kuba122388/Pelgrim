import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/repositories/song_repository.dart';

class AddSongUseCase {
  final SongRepository _songRepository;

  AddSongUseCase(this._songRepository);

  Future<void> execute(String groupName, Song song) async {
    return await _songRepository.addSong(groupName, song);
  }
}
