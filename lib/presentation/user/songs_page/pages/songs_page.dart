import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/providers/song_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/songs_page/pages/songs_detail_page.dart';
import 'package:provider/provider.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => SongsPageState();
}

class SongsPageState extends State<SongsPage> {
  late final TextEditingController _searchEngineController;

  late String _groupId;
  Timer? _debounce;

  String get query => _searchEngineController.text;

  void _onSearchChanged() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 200), () {
      setState(() {});
    });
  }

  @override
  void initState() {
    super.initState();

    _searchEngineController = TextEditingController()..addListener(_onSearchChanged);

    _groupId = context.read<UserProvider>().groupInfo!.id!;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<SongProvider>().startSongList(_groupId);
    });
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchEngineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<Song> filteredSongs(List<Song> listSong) {
      final q = query.toLowerCase();

      return listSong
          .where((e) => e.title.toLowerCase().contains(q) || e.lyrics.toLowerCase().contains(q))
          .toList();
    }

    final provider = context.watch<SongProvider>();

    final songIndexMap = {for (var i = 0; i < provider.songs.length; i++) provider.songs[i].id!: i};
    final songs = filteredSongs(provider.songs);

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return SafeArea(
      child: SizedBox(
        height: screenHeight,
        width: screenWidth,
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: const [BOX_SHADOW_CONTAINER],
              ),
              width: screenWidth * 0.72,
              margin: const EdgeInsets.symmetric(vertical: 20),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                autofocus: false,
                controller: _searchEngineController,
                decoration: InputDecoration(
                  suffixIcon: Image.asset('./images/search.png', scale: 2),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white,
                  label: Text(
                    'Tutaj wyszukaj piosenki',
                    style: TextStyle(
                      color: Colors.black.withValues(alpha: 0.4),
                      fontSize: 14,
                    ),
                  ),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: provider.isLoading
                  ? const Center(
                      child: Text(
                        'Ładowanie...',
                        style: TextStyle(
                          fontFamily: 'Lexend',
                          color: FONT_BLACK_COLOR,
                        ),
                      ),
                    )
                  : songs.isEmpty
                      ? const Center(
                          child: Text(
                            'Brak piosenek',
                            style: TextStyle(
                              fontFamily: 'Lexend',
                              color: FONT_BLACK_COLOR,
                            ),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          itemCount: songs.length,
                          itemBuilder: (_, i) {
                            final song = songs[i];
                            final originalIndex = songIndexMap[song.id!] ?? i;
                            final displayTitle = "${originalIndex + 1}. ${song.title}";

                            return GestureDetector(
                              onTap: () async {
                                await Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => SongsDetailPage(
                                      songId: song.id!,
                                    ),
                                  ),
                                );
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.25),
                                      blurRadius: 4,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 0),
                                    ),
                                  ],
                                ),
                                width: screenWidth * 0.8,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                  child: Text(
                                    displayTitle,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontFamily: 'Lexend',
                                      color: FONT_BLACK_COLOR,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
