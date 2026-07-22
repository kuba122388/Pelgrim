import 'dart:io';

abstract class ImagesRepository {
  Future<void> uploadImages({
    required List<File> images,
    required String groupId,
    required String userEmail,
    required void Function(int sent, int total) onProgress,
  });

  Future<List<String>> getAllImages(String groupId);

  Future<void> deleteImages({
    required String groupId,
    required List<String> imageUrls,
  });

  Future<void> downloadAndSaveImages(List<String> urls);
}
