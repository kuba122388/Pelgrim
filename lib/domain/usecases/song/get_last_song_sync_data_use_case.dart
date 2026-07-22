import '../../repositories/song_repository.dart';

class GetLastSongSyncDateUseCase {
  final SongRepository _repository;

  GetLastSongSyncDateUseCase(this._repository);

  Future<DateTime?> execute(String groupId) => _repository.getLastSync(groupId);
}
