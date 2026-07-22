import 'dart:io';

import 'package:pelgrim/core/errors/repository_exception.dart';

import '../../domain/repositories/informant_repository.dart';
import '../datasources/remote/informant_data_source.dart';

class InformantRepositoryImpl implements InformantRepository {
  final InformantStorageDataSource _informantStorageDataSource;

  InformantRepositoryImpl(this._informantStorageDataSource);

  @override
  Future<List<String>> getImages(String groupId) async {
    try {
      return await _informantStorageDataSource.getUrls(groupId);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z pobraniem informatorów.");
    }
  }

  @override
  Future<void> uploadImages(String groupId, List<File> files) async {
    for (final file in files) {
      try {
        await _informantStorageDataSource.upload(groupId, file);
      } catch (e) {
        throw RepositoryException("Wystąpił problem z przesłaniem zdjęcia.");
      }
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) async {
    try {
      return await _informantStorageDataSource.deleteByUrl(imageUrl);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z usuwaniem zdjęcia.");
    }
  }
}
