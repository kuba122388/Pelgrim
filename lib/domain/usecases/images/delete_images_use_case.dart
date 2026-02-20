import '../../repositories/images_repository.dart';

class DeleteImagesUseCase {
  final ImagesRepository _repository;

  DeleteImagesUseCase(this._repository);

  Future<void> call({
    required String groupId,
    required List<String> imageUrls,
  }) {
    return _repository.deleteImages(
      groupId: groupId,
      imageUrls: imageUrls,
    );
  }
}
