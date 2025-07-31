import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/dbfeatures/MyUser.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class InformantPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final MyUser myUser;

  const InformantPage(
      {super.key, required this.settings, required this.myUser});

  @override
  State<InformantPage> createState() => _InformantPageState();
}

class _InformantPageState extends State<InformantPage> {
  final List<XFile> _selectedImages = [];
  late String group =
      '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';

  Future<List<String>> getAllImageUrls() async {
    try {
      Reference folderRef =
          FirebaseStorage.instance.ref().child(group).child('Informant');
      ListResult result = await folderRef.listAll();
      List<String> imageUrls = [];
      for (var item in result.items) {
        String url = await item.getDownloadURL();
        imageUrls.add(url);
      }

      return imageUrls;
    } catch (e) {
      return [];
    }
  }

  Future<void> _pickAndSendImages() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile>? pickedImages = await picker.pickMultiImage();

    if (pickedImages != null) {
      int i = 0;
      for (var image in pickedImages) {
        i += 1;
        if (!_selectedImages
            .any((selectedImage) => selectedImage.name == image.name)) {
          try {
            final file = File(image.path);
            final bytes = await file.readAsBytes();

            await decodeImageFromList(bytes);
            final fileName =
                '${DateTime.now().millisecondsSinceEpoch}_${image.name}';
            final ref = FirebaseStorage.instance
                .ref()
                .child(group)
                .child('Informant')
                .child(fileName);

            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(milliseconds: 1500),
                content: Center(
                    child: Text(
                        'Przesyłanie zdjęcia $i/${pickedImages.length}'))));
            await ref.putFile(file);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Center(child: Text('Wystąpił problem'))));
          }
        }
      }
      if (pickedImages.length > 0) setState(() {});
    }
  }

  Future<void> _deleteConfirmation(String imageUrl) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Potwierdzenie'),
          content: const Text('Czy na pewno chcesz usunąć to zdjęcie?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () async {
                try {
                  final ref = FirebaseStorage.instance.refFromURL(imageUrl);
                  await ref.delete();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Zdjęcie zostało usunięte')),
                  );
                  setState(() {});
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Błąd podczas usuwania')),
                  );
                }
                Navigator.of(context).pop();
              },
              child: const Text('Usuń', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(20),
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<String>>(
              future: getAllImageUrls(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Błąd: ${snapshot.error}'));
                } else if (snapshot.hasData && snapshot.data != null) {
                  final imageUrls = snapshot.data!;
                  if (imageUrls.isEmpty) {
                    return const Center(child: Text("Brak informatorów"));
                  }
                  return ListView.builder(
                    itemCount: imageUrls.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Stack(
                          children: [
                            GestureDetector(
                              onTap: () {},
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: Image.network(
                                  imageUrls[index],
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: 200,
                                ),
                              ),
                            ),
                            if (widget.myUser.admin)
                              Positioned(
                                top: 10,
                                right: 10,
                                child: GestureDetector(
                                  onTap: () =>
                                      _deleteConfirmation(imageUrls[index]),
                                  child: Image.asset("./images/trash.png",
                                      width: 20, height: 20),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text('Brak zdjęć do wyświetlenia'));
                }
              },
            ),
          ),
          if (widget.myUser.admin)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child:
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                InkWell(
                  onTap: () => _pickAndSendImages(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [BOX_SHADOW_CONTAINER],
                        borderRadius: BorderRadius.circular(15)),
                    child: const Center(
                      child: Text(
                        'Dodaj informatory',
                        style: TextStyle(fontFamily: 'Lexend', fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ]),
            )
        ],
      ),
    );
  }
}

class ImageGalleryPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const ImageGalleryPage(
      {super.key, required this.imageUrls, required this.initialIndex});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PhotoViewGallery.builder(
            itemCount: imageUrls.length,
            builder: (context, index) {
              return PhotoViewGalleryPageOptions(
                imageProvider: NetworkImage(imageUrls[index]),
                minScale: PhotoViewComputedScale.contained * 0.8,
                maxScale: PhotoViewComputedScale.covered * 2,
                heroAttributes: PhotoViewHeroAttributes(tag: imageUrls[index]),
              );
            },
            pageController: PageController(initialPage: initialIndex),
            scrollPhysics: const BouncingScrollPhysics(),
            backgroundDecoration: const BoxDecoration(
              color: Colors.black,
            ),
          ),
          Positioned(
            top: 40.0,
            right: 20.0,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
