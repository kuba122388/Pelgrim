import '../../repositories/informant_repository.dart';

class GetInformantImagesUseCase {
  final InformantRepository _informantRepository;

  GetInformantImagesUseCase(this._informantRepository);

  Future<List<String>> execute(String groupId) {
    return _informantRepository.getImages(groupId);
  }
}
