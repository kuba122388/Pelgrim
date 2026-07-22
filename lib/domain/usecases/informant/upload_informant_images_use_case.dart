import 'dart:io';

import '../../repositories/informant_repository.dart';

class UploadInformantImagesUseCase {
  final InformantRepository _informantRepository;

  UploadInformantImagesUseCase(this._informantRepository);

  Future<void> execute(String groupId, List<File> files) {
    return _informantRepository.uploadImages(groupId, files);
  }
}
