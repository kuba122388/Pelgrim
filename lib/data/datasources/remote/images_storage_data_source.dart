import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';

class ImagesStorageDataSource {
  final FirebaseStorage _storage;

  ImagesStorageDataSource(this._storage);

  String _generateFileName(String email) {
    final userId = email.replaceAll(RegExp(r'[@.]'), '_');
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final random = Random().nextInt(1000);
    return '${userId}_${timestamp}_$random.jpg';
  }

  Future<void> uploadImages({
    required List<File> images,
    required String groupId,
    required String userEmail,
    required void Function(int sent, int total) onProgress,
  }) async {
    final ref = _storage.ref().child(groupId).child('images');

    int sent = 0;

    for (final image in images) {
      final imageRef = ref.child(_generateFileName(userEmail));
      await imageRef.putFile(image);
      sent++;
      onProgress(sent, images.length);
    }
  }

  Future<List<String>> getAllImages(String groupId) async {
    final ref = _storage.ref().child(groupId).child('images');
    final result = await ref.listAll();

    return Future.wait(
      result.items.map((e) => e.getDownloadURL()),
    );
  }
}
