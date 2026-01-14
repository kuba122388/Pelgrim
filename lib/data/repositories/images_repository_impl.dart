import 'dart:io';

import '../../domain/repositories/images_repository.dart';
import '../datasources/remote/images_storage_data_source.dart';

class ImagesRepositoryImpl implements ImagesRepository {
  final ImagesStorageDataSource _imagesStorageDataSource;

  ImagesRepositoryImpl(this._imagesStorageDataSource);

  @override
  Future<void> uploadImages({
    required List<File> images,
    required String groupId,
    required String userEmail,
    required void Function(int sent, int total) onProgress,
  }) {
    return _imagesStorageDataSource.uploadImages(
      images: images,
      groupId: groupId,
      userEmail: userEmail,
      onProgress: onProgress,
    );
  }

  @override
  Future<List<String>> getAllImages(String groupId) {
    return _imagesStorageDataSource.getAllImages(groupId);
  }
}
