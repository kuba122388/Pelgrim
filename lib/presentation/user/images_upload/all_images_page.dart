import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pelgrim/presentation/providers/images_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/images_upload/widgets/full_screen_gallery.dart';
import 'package:pelgrim/presentation/user/settings/special_topbar.dart';
import 'package:provider/provider.dart';

class AllImagesPage extends StatefulWidget {
  const AllImagesPage({super.key});

  @override
  State<AllImagesPage> createState() => _AllImagesPageState();
}

class _AllImagesPageState extends State<AllImagesPage> {
  @override
  void initState() {
    super.initState();
    final groupId = context.read<UserProvider>().groupInfo!.id!;
    WidgetsBinding.instance
        .addPostFrameCallback((_) => context.read<ImagesProvider>().loadImages(groupId));
  }

  @override
  Widget build(BuildContext context) {
    final imagesProvider = context.watch<ImagesProvider>();

    return Scaffold(
      appBar: const SpecialTopBar(),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Text("Wszystkie zdjęcia", style: TextStyle(fontSize: 16)),
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
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => FullScreenGalleryPage(
                                        imageUrls: imagesProvider.images,
                                        initialIndex: index,
                                      ),
                                    ),
                                  );
                                },
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: CachedNetworkImage(
                                    imageUrl: url,
                                    fit: BoxFit.cover,
                                    placeholder: (_, __) =>
                                        const Center(child: CircularProgressIndicator()),
                                    errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                                  ),
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
