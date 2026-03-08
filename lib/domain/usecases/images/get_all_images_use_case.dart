import '../../repositories/images_repository.dart';

class GetAllImagesUseCase {
  final ImagesRepository _imagesRepository;

  GetAllImagesUseCase(this._imagesRepository);

  Future<List<String>> call(String groupId) {
    return _imagesRepository.getAllImages(groupId);
  }
}
