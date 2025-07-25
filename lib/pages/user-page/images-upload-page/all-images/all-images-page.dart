import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:pelgrim/pages/user-page/settings-page/special-topbar.dart';

class AllImagesPage extends StatefulWidget {
  final Map<String, dynamic> settings;

  const AllImagesPage({super.key, required this.settings});

  @override
  State<AllImagesPage> createState() => _AllImagesPageState();
}

class _AllImagesPageState extends State<AllImagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SpecialTopBar(settings: widget.settings, myUser: null),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10 ),
            child: Center(
              child: Text("Wszystkie zdjęcia", style: TextStyle(fontSize: 16)),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<String>>(
              future: _loadAllImageUrls(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Błąd: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Brak zdjęć.'));
                }

                final imageUrls = snapshot.data!;

                return MasonryGridView.count(
                  crossAxisCount: 2,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  padding: const EdgeInsets.all(8),
                  cacheExtent: 1500,
                  itemCount: imageUrls.length,
                  itemBuilder: (context, index) {
                    final imageUrl = imageUrls[index];

                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => FullScreenGalleryPage(
                              imageUrls: imageUrls,
                              initialIndex: index,
                            ),
                          ),
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                          imageUrl: imageUrl,
                          fit: BoxFit.cover,
                          placeholder: (_, __) => const AspectRatio(
                            aspectRatio: 1,
                            child: Center(child: CircularProgressIndicator(strokeWidth: 2)),
                          ),
                          errorWidget: (_, __, ___) =>
                          const Icon(Icons.broken_image),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<List<String>> _loadAllImageUrls() async {
    final group = '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';
    final storageRef = FirebaseStorage.instance.ref().child(group).child('Images');
    final ListResult result = await storageRef.listAll();

    List<String> urls = [];
    for (Reference ref in result.items) {
      final url = await ref.getDownloadURL();
      urls.add(url);
    }
    return urls;
  }
}

class FullScreenGalleryPage extends StatelessWidget {
  final List<String> imageUrls;
  final int initialIndex;

  const FullScreenGalleryPage({
    super.key,
    required this.imageUrls,
    required this.initialIndex,
  });

  @override
  Widget build(BuildContext context) {
    final controller = PageController(initialPage: initialIndex);

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          PageView.builder(
            controller: controller,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              return InteractiveViewer(
                child: Center(
                  child: CachedNetworkImage(
                    imageUrl: imageUrls[index],
                    fit: BoxFit.contain,
                    placeholder: (_, __) => const CircularProgressIndicator(),
                    errorWidget: (_, __, ___) => const Icon(Icons.broken_image),
                  ),
                ),
              );
            },
          ),
          Positioned(
            top: 40,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.white, size: 30),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ],
      ),
    );
  }
}
