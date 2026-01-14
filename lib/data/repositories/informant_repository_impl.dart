import 'dart:io';

import '../../domain/repositories/informant_repository.dart';
import '../datasources/remote/informant_data_source.dart';

class InformantRepositoryImpl implements InformantRepository {
  final InformantStorageDataSource _informantStorageDataSource;

  InformantRepositoryImpl(this._informantStorageDataSource);

  @override
  Future<List<String>> getImages(String groupId) async {
    return await _informantStorageDataSource.getUrls(groupId);
  }

  @override
  Future<void> uploadImages(String groupId, List<File> files) async {
    for (final file in files) {
      await _informantStorageDataSource.upload(groupId, file);
    }
  }

  @override
  Future<void> deleteImage(String imageUrl) {
    return _informantStorageDataSource.deleteByUrl(imageUrl);
  }
}
