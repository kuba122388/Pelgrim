import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/images_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_snack_bars.dart';
import 'all_images_page.dart';

class ImagePage extends StatefulWidget {
  const ImagePage({super.key});

  @override
  State<ImagePage> createState() => _ImagePageState();
}

class _ImagePageState extends State<ImagePage> {
  Future<void> _pickImages(BuildContext context) async {
    final picker = ImagePicker();
    final picked = await picker.pickMultiImage();

    if (picked.isEmpty) return;

    final files = picked.map((e) => File(e.path)).toList();
    context.read<ImagesProvider>().pickImages(files);
  }

  @override
  Widget build(BuildContext context) {
    final Group groupInfo = context.read<UserProvider>().groupInfo!;
    final User myUser = context.read<UserProvider>().user!;
    final provider = context.watch<ImagesProvider>();

    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: EdgeInsets.only(
        top: screenHeight * 0.05,
        bottom: screenHeight * 0.05,
      ),
      width: screenWidth,
      height: screenHeight * 0.9,
      child: Column(
        children: [
          if (provider.selectedImages.isEmpty) ...[
            InkWell(
              onTap: () => _pickImages(context),
              child: Container(
                width: screenWidth * 0.7,
                height: screenHeight * 0.3,
                decoration: BoxDecoration(
                  color: const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: const [BOX_SHADOW_CONTAINER],
                ),
                child: Image.asset(
                  './images/upload.png',
                  color: const Color(0x80000000),
                  colorBlendMode: BlendMode.srcIn,
                ),
              ),
            ),
            const Spacer(),
            const Text(
              'Tutaj proszę wysyłać\nzdjęcia z pielgrzymki',
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
                itemCount: provider.selectedImages.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      Image.file(
                        provider.selectedImages[index],
                        fit: BoxFit.cover,
                      ),
                      Positioned(
                        top: 0,
                        right: 0,
                        child: IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => context.read<ImagesProvider>().removeAt(index),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (provider.selectedImages.isNotEmpty)
                  InkWell(
                    onTap: () => _pickImages(context),
                    child: _iconBox('./images/upload.png'),
                  ),
                InkWell(
                  onTap: provider.isUploading
                      ? null
                      : () async {
                          try {
                            await context.read<ImagesProvider>().upload(
                                  groupId: groupInfo.id!,
                                  userEmail: myUser.email,
                                );
                          } catch (e) {
                            if (!context.mounted) return;

                            AppSnackBars.error(context, "Nie wybrano żadnych zdjęć");
                            return;
                          }

                          if (!context.mounted) return;
                          AppSnackBars.success(context, 'Zdjęcia przesłano pomyślnie!');
                        },
                  child: Container(
                    height: 50,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    decoration: _boxDecoration,
                    child: Center(
                      child: Text(
                        provider.isUploading
                            ? 'Przesłano ${provider.sent}/${provider.total}'
                            : 'Prześlij',
                        style: const TextStyle(fontFamily: 'Lexend', fontSize: 18),
                      ),
                    ),
                  ),
                ),
                if (myUser.isAdmin && provider.selectedImages.isEmpty)
                  InkWell(
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const AllImagesPage(),
                      ),
                    ),
                    child: _iconBox('./images/images.png'),
                  ),
                if (provider.selectedImages.isNotEmpty)
                  InkWell(
                    onTap: () => context.read<ImagesProvider>().clear(),
                    child: _iconBox(
                      './images/trash.png',
                      color: Colors.red,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BoxDecoration get _boxDecoration => BoxDecoration(
        color: Colors.white,
        boxShadow: const [BOX_SHADOW_CONTAINER],
        borderRadius: BorderRadius.circular(15),
      );

  Widget _iconBox(String asset, {Color? color}) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 50,
      decoration: _boxDecoration,
      child: Image.asset(
        asset,
        color: color ?? const Color(0x80000000),
        colorBlendMode: BlendMode.srcIn,
      ),
    );
  }
}
