import 'dart:io';
import 'dart:math';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/images_upload/all_images/all_images_page.dart';
import 'package:provider/provider.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  final List<XFile> _selectedImages = [];

  bool processing = false;
  int sending = 0;

  String generateFileName(String email) {
    String userId = email.replaceAll(RegExp(r'[@.]'), '_');
    String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
    String random = Random().nextInt(1000).toString();

    return "${userId}_${timestamp}_$random.jpg";
  }

  Future<void> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedImages = await picker.pickMultiImage();

    for (var image in pickedImages) {
      if (!_selectedImages.any((selectedImage) => selectedImage.name == image.name)) {
        try {
          final file = File(image.path);
          final bytes = await file.readAsBytes();

          await decodeImageFromList(bytes);
          _selectedImages.add(image);
        } catch (e) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Center(
                child: Text('Wystąpił problem'),
              ),
            ),
          );
        }
      }
    }
    setState(() {});
  }

  Future<void> _uploadImages({required String groupName, required String userEmail}) async {
    if (processing == true) return;
    setState(() {
      processing = true;
    });
    if (_selectedImages.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 2),
          content: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text('Brak zdjęć do przesłania', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      );
      setState(() {
        processing = false;
      });
      return;
    }

    int currentImage = 1;

    final storageRef = FirebaseStorage.instance.ref().child(groupName).child('Images');

    try {
      for (var image in _selectedImages) {
        setState(() {
          sending = sending + 1;
        });
        final file = File(image.path);
        final imageRef = storageRef.child(generateFileName(userEmail));
        await imageRef.putFile(file);
        currentImage = currentImage + 1;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          duration: Duration(seconds: 1),
          content: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text('Zdjęcia przesłano pomyślnie!', style: TextStyle(fontSize: 16)),
            ),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: const Duration(seconds: 2),
          content: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text('Wystąpił problem $e', style: const TextStyle(fontSize: 16)),
            ),
          ),
        ),
      );
    }
    setState(() {
      processing = false;
      sending = 0;
      _selectedImages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final Group groupInfo = context.read<UserProvider>().groupInfo!;
    final User myUser = context.read<UserProvider>().user!;

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(top: screenHeight * 0.05, bottom: screenHeight * 0.05),
      width: screenWidth,
      height: screenHeight * 0.9,
      child: Column(
        children: [
          if (_selectedImages.isEmpty) ...[
            InkWell(
              onTap: _pickImages,
              child: Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                    color: const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BOX_SHADOW_CONTAINER]),
                child: Image.asset('./images/upload.png',
                    color: const Color(0x80000000), colorBlendMode: BlendMode.srcIn),
              ),
            ),
            const Spacer(),
            const Text(
              'Tutaj wrzucać zdjęcia\nz pielgrzymki',
              style: TextStyle(fontFamily: 'Lexend', fontSize: 20),
              textAlign: TextAlign.center,
            ),
            const Spacer(),
          ] else
            Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 3,
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                itemCount: _selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.file(
                        File(_selectedImages[index].path),
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () {
                            setState(() {
                              _selectedImages.removeAt(index);
                            });
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Visibility(
                  visible: _selectedImages.isNotEmpty,
                  child: InkWell(
                    onTap: _pickImages,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      width: 50,
                      decoration: BoxDecoration(
                          boxShadow: const [BOX_SHADOW_CONTAINER],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Image.asset('./images/upload.png',
                          color: const Color(0x80000000), colorBlendMode: BlendMode.srcIn),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () async =>
                      await _uploadImages(groupName: groupInfo.id!, userEmail: myUser.email),
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BOX_SHADOW_CONTAINER],
                        borderRadius: BorderRadius.circular(15)),
                    child: Center(
                      child: Text(
                        processing == false
                            ? 'Opublikuj'
                            : 'Przesłano $sending/${_selectedImages.length}',
                        style: const TextStyle(fontFamily: 'Lexend', fontSize: 18),
                      ),
                    ),
                  ),
                ),
                if (myUser.isAdmin)
                  InkWell(
                    onTap: () async => {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => const AllImagesPage()))
                    },
                    child: Container(
                      height: 50,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: const [BOX_SHADOW_CONTAINER],
                          borderRadius: BorderRadius.circular(15)),
                      child: Image.asset(
                        "./images/images.png",
                        width: 30,
                        height: 30,
                      ),
                    ),
                  ),
                Visibility(
                  visible: _selectedImages.isNotEmpty,
                  child: InkWell(
                    onTap: () => setState(() {
                      _selectedImages.clear();
                    }),
                    child: Container(
                      padding: const EdgeInsets.all(15),
                      width: 50,
                      decoration: BoxDecoration(
                          boxShadow: const [BOX_SHADOW_CONTAINER],
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(15)),
                      child: Image.asset('./images/trash.png',
                          color: Colors.red, colorBlendMode: BlendMode.srcIn),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
