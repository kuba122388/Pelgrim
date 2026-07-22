import 'dart:io';

abstract class InformantRepository {
  Future<List<String>> getImages(String groupId);

  Future<void> uploadImages(String groupId, List<File> files);

  Future<void> deleteImage(String imageUrl);
}
