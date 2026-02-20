import '../../repositories/images_repository.dart';

class DownloadImagesUseCase {
  final ImagesRepository repository;

  DownloadImagesUseCase(this.repository);

  Future<void> call(List<String> urls) async {
    return await repository.downloadAndSaveImages(urls);
  }
}
