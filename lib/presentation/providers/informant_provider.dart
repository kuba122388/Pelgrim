import 'dart:io';

import 'package:flutter/material.dart';

import '../../domain/usecases/informant/delete_informant_image_use_case.dart';
import '../../domain/usecases/informant/get_informant_images_use_case.dart';
import '../../domain/usecases/informant/upload_informant_images_use_case.dart';

class InformantProvider extends ChangeNotifier {
  final GetInformantImagesUseCase _getImages;
  final UploadInformantImagesUseCase _upload;
  final DeleteInformantImageUseCase _delete;

  InformantProvider(
    this._getImages,
    this._upload,
    this._delete,
  );

  bool _isLoading = false;
  List<String> _images = [];

  bool get isLoading => _isLoading;

  List<String> get imagesUrls => _images;

  Future<void> load(String groupId) async {
    _isLoading = true;
    notifyListeners();

    _images = await _getImages.execute(groupId);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> upload(String groupId, List<File> files) async {
    await _upload.execute(groupId, files);
    await load(groupId);
  }

  Future<void> delete(String imageUrl, String groupId) async {
    await _delete.execute(imageUrl);
    await load(groupId);
  }
}
