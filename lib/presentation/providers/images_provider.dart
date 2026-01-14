import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/usecases/images/get_all_images_use_case.dart';
import '../../domain/usecases/images/upload_images_use_case.dart';

class ImagesProvider extends ChangeNotifier {
  final GetAllImagesUseCase _getAllImages;
  final UploadImagesUseCase _uploadImages;

  ImagesProvider(
    this._getAllImages,
    this._uploadImages,
  );

  final List<File> _selectedImages = [];
  List<String> _images = [];

  bool _loading = false;
  bool _uploading = false;
  int _sent = 0;
  String? _error;

  List<File> get selectedImages => _selectedImages;

  List<String> get images => _images;

  bool get isLoading => _loading;

  bool get isUploading => _uploading;

  int get sent => _sent;

  int get total => _selectedImages.length;

  String? get error => _error;

  void pickImages(List<File> files) {
    for (final file in files) {
      if (!_selectedImages.any((f) => f.path == file.path)) {
        _selectedImages.add(file);
      }
    }
    notifyListeners();
  }

  void removeAt(int index) {
    if (index < 0 || index >= _selectedImages.length) return;
    _selectedImages.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _selectedImages.clear();
    _sent = 0;
    notifyListeners();
  }

  Future<void> loadImages(String groupId) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      _images = await _getAllImages(groupId);
    } catch (e) {
      _error = e.toString();
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> upload({
    required String groupId,
    required String userEmail,
  }) async {
    if (_selectedImages.isEmpty) throw Exception("Nie wybrano żadnych zdjęć do wysłania.");

    if (_uploading) return;

    _uploading = true;
    _sent = 0;
    notifyListeners();

    try {
      await _uploadImages(
        images: _selectedImages,
        groupId: groupId,
        userEmail: userEmail,
        onProgress: (sent, _) {
          _sent = sent;
          notifyListeners();
        },
      );

      clear();
      await loadImages(groupId);
    } catch (e) {
      _error = e.toString();
    }

    _uploading = false;
    notifyListeners();
  }
}
