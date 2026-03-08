import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class InformantStorageDataSource {
  final FirebaseStorage _storage;

  InformantStorageDataSource(this._storage);

  Future<List<String>> getUrls(String groupId) async {
    final ref = _storage.ref().child(groupId).child('informant');
    final result = await ref.listAll();
    return Future.wait(result.items.map((e) => e.getDownloadURL()));
  }

  Future<void> upload(String groupId, File file) async {
    final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
    final ref = _storage.ref().child(groupId).child('informant').child(fileName);
    await ref.putFile(file);
  }

  Future<void> deleteByUrl(String url) async {
    await _storage.refFromURL(url).delete();
  }
}
