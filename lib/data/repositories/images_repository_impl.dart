import 'dart:io';

import 'package:gal/gal.dart';
import 'package:pelgrim/core/errors/repository_exception.dart';

import '../../domain/repositories/images_repository.dart';
import '../datasources/remote/images_storage_data_source.dart';

class ImagesRepositoryImpl implements ImagesRepository {
  final ImagesStorageDataSource _imagesStorageDataSource;

  ImagesRepositoryImpl(this._imagesStorageDataSource);

  @override
  Future<void> deleteImages({
    required String groupId,
    required List<String> imageUrls,
  }) {
    return _imagesStorageDataSource.deleteImages(
      groupId: groupId,
      imageUrls: imageUrls,
    );
  }

  @override
  Future<void> uploadImages({
    required List<File> images,
    required String groupId,
    required String userEmail,
    required void Function(int sent, int total) onProgress,
  }) async {
    try {
      return await _imagesStorageDataSource.uploadImages(
        images: images,
        groupId: groupId,
        userEmail: userEmail,
        onProgress: onProgress,
      );
    } catch (e) {
      throw RepositoryException("Wystąpił problem z przesyłaniem zdjęć.");
    }
  }

  @override
  Future<List<String>> getAllImages(String groupId) {
    try {
      return _imagesStorageDataSource.getAllImages(groupId);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z pobieraniem zdjęć.");
    }
  }

  @override
  Future<void> downloadAndSaveImages(List<String> urls) async {
    try {
      for (final url in urls) {
        final bytes = await _imagesStorageDataSource.downloadImageBytes(url);
        await Gal.putImageBytes(bytes);
      }
    } catch (e) {
      throw RepositoryException("Błąd podczas zapisywania zdjęć: $e");
    }
  }
}
