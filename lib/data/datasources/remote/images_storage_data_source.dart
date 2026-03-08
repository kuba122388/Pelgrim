import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:http/http.dart' as http;

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

  Future<void> deleteImages({
    required String groupId,
    required List<String> imageUrls,
  }) async {
    for (final url in imageUrls) {
      final ref = _storage.refFromURL(url);
      await ref.delete();
    }
  }

  Future<Uint8List> downloadImageBytes(String url) async {
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      return response.bodyBytes;
    } else {
      throw Exception("Błąd pobierania obrazu");
    }
  }
}
