import 'dart:io';

import '../../repositories/images_repository.dart';

class UploadImagesUseCase {
  final ImagesRepository _imagesRepository;

  UploadImagesUseCase(this._imagesRepository);

  Future<void> call({
    required List<File> images,
    required String groupId,
    required String userEmail,
    required void Function(int sent, int total) onProgress,
  }) {
    return _imagesRepository.uploadImages(
      images: images,
      groupId: groupId,
      userEmail: userEmail,
      onProgress: onProgress,
    );
  }
}
