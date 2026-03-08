import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pelgrim/core/utils/app_snack_bars.dart';
import 'package:pelgrim/presentation/providers/images_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/images_upload/widgets/full_screen_gallery.dart';
import 'package:provider/provider.dart';

import '../../../widgets/special_topbar.dart';

class AllImagesPage extends StatefulWidget {
  const AllImagesPage({super.key});

  @override
  State<AllImagesPage> createState() => _AllImagesPageState();
}

class _AllImagesPageState extends State<AllImagesPage> {
  bool isSelectionMode = false;
  final Set<String> selectedImages = {};

  @override
  void initState() {
    super.initState();
    final groupId = context.read<UserProvider>().groupInfo!.id!;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<ImagesProvider>().loadImages(groupId));
  }

  Future<void> _confirmDelete() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Usunąć zdjęcia?'),
          content: Text(
            'Czy na pewno chcesz usunąć ${selectedImages.length} '
            '${selectedImages.length == 1 ? "zdjęcie" : "zdjęcia"}?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Anuluj'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text(
                'Usuń',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (shouldDelete == true) {
      await context.read<ImagesProvider>().deleteSelected(
            groupId: context.read<UserProvider>().groupInfo!.id!,
            selectedUrls: selectedImages.toList(),
          );

      setState(() {
        isSelectionMode = false;
        selectedImages.clear();
      });
    }
  }

  void toggleSelection(String url) {
    setState(() {
      if (selectedImages.contains(url)) {
        selectedImages.remove(url);
        if (selectedImages.isEmpty) {
          isSelectionMode = false;
        }
      } else {
        selectedImages.add(url);
      }
    });
  }

  void startSelection(String index) {
    setState(() {
      isSelectionMode = true;
      selectedImages.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final imagesProvider = context.watch<ImagesProvider>();

    return Scaffold(
      appBar: SpecialTopBar(
        onBack: () {
          if (isSelectionMode) {
            setState(() {
              isSelectionMode = false;
              selectedImages.clear();
            });
          } else {
            Navigator.of(context).pop();
          }
        },
        actions: isSelectionMode
            ? [
                IconButton(
                  icon: imagesProvider.isDownloading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : const Icon(Icons.download, color: Colors.white),
                  onPressed: imagesProvider.isDownloading
                      ? null
                      : () async {
                          await context.read<ImagesProvider>().downloadSelected(
                                selectedImages.toList(),
                              );

                          if (imagesProvider.error == null) {
                            if (!context.mounted) return;
                            AppSnackBars.success(context, 'Zdjęcia zostały zapisane w galerii!',
                                duration: 2);

                            setState(() {
                              isSelectionMode = false;
                              selectedImages.clear();
                            });
                          } else {
                            if (!context.mounted) return;
                            AppSnackBars.error(context, imagesProvider.error!, duration: 2);
                          }
                        },
                  padding: EdgeInsetsGeometry.zero,
                ),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  padding: EdgeInsetsGeometry.zero,
                  onPressed: _confirmDelete,
                ),
              ]
            : null,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Text(
                isSelectionMode == false
                    ? "Wszystkie zdjęcia"
                    : "Zaznaczono: ${selectedImages.length}",
                style: const TextStyle(fontSize: 16)),
          ),
          Expanded(
            child: imagesProvider.isLoading
                ? const Center(child: CircularProgressIndicator())
                : imagesProvider.error != null
                    ? Center(child: Text(imagesProvider.error!))
                    : imagesProvider.images.isEmpty
                        ? const Center(child: Text('Brak zdjęć.'))
                        : MasonryGridView.count(
                            crossAxisCount: 2,
                            mainAxisSpacing: 8,
                            crossAxisSpacing: 8,
                            padding: const EdgeInsets.all(8),
                            itemCount: imagesProvider.images.length,
                            itemBuilder: (_, index) {
                              final url = imagesProvider.images[index];
                              return GestureDetector(
                                onLongPress: () => startSelection(url),
                                onTap: () {
                                  if (isSelectionMode) {
                                    toggleSelection(url);
                                  } else {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => FullScreenGalleryPage(
                                          imageUrls: imagesProvider.images,
                                          initialIndex: index,
                                        ),
                                      ),
                                    );
                                  }
                                },
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: CachedNetworkImage(
                                        imageUrl: url,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    if (selectedImages.contains(url))
                                      Positioned.fill(
                                        child: Container(
                                          decoration: BoxDecoration(
                                            color: Colors.black.withAlpha(100),
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: const Icon(
                                            Icons.check_circle,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
