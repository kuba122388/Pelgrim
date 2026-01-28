import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/core/utils/app_snack_bars.dart';
import 'package:pelgrim/presentation/providers/informant_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/informant/widgets/image_gallery.dart';
import 'package:provider/provider.dart';

class InformantPage extends StatefulWidget {
  const InformantPage({super.key});

  @override
  State<InformantPage> createState() => _InformantPageState();
}

class _InformantPageState extends State<InformantPage> {
  late String _groupId;

  @override
  void initState() {
    super.initState();
    _groupId = context.read<UserProvider>().userGroupId;
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<InformantProvider>().load(_groupId),
    );
  }

  Future<void> _pickAndSendImages() async {
    final picker = ImagePicker();
    final pickedImages = await picker.pickMultiImage();

    if (pickedImages.isEmpty) return;

    final files = pickedImages.map((e) => File(e.path)).toList();

    if (!mounted) return;

    AppSnackBars.success(context, 'Przesyłanie zdjęć...');

    await context.read<InformantProvider>().upload(_groupId, files);
  }

  Future<void> _deleteConfirmation(String imageUrl) async {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Potwierdzenie'),
        content: const Text('Czy na pewno chcesz usunąć to zdjęcie?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Anuluj'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              await context.read<InformantProvider>().delete(imageUrl, _groupId);

              if (!mounted) return;

              AppSnackBars.success(context, 'Zdjęcie zostało usunięte');
            },
            child: const Text(
              'Usuń',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final myUser = context.read<UserProvider>().user!;
    final provider = context.watch<InformantProvider>();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.all(20),
      width: screenWidth,
      height: screenHeight,
      child: Column(
        children: [
          Expanded(
            child: provider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : provider.imagesUrls.isEmpty
                    ? const Center(child: Text('Brak informatorów'))
                    : ListView.builder(
                        itemCount: provider.imagesUrls.length,
                        itemBuilder: (context, index) {
                          final image = provider.imagesUrls[index];

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Stack(
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => ImageGallery(
                                          imageUrls: provider.imagesUrls,
                                          initialIndex: index,
                                        ),
                                      ),
                                    );
                                  },
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(12),
                                    child: Image.network(
                                      image,
                                      fit: BoxFit.fitWidth,
                                      width: double.infinity,
                                      height: 200,
                                    ),
                                  ),
                                ),
                                if (myUser.isAdmin)
                                  Positioned(
                                    top: 20,
                                    right: 20,
                                    child: GestureDetector(
                                      onTap: () => _deleteConfirmation(image),
                                      child: Image.asset(
                                        './images/trash.png',
                                        width: 20,
                                        height: 20,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          );
                        },
                      ),
          ),
          if (myUser.isAdmin)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: InkWell(
                onTap: provider.isLoading ? null : _pickAndSendImages,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: const [BOX_SHADOW_CONTAINER],
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Text(
                    'Dodaj informatory',
                    style: TextStyle(fontFamily: 'Lexend', fontSize: 18),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
