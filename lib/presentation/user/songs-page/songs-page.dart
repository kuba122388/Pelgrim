import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/consts.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/user/songs-page/songs-detail-page.dart';
import 'package:pelgrim/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SongsPage extends StatefulWidget {
  const SongsPage({super.key});

  @override
  State<SongsPage> createState() => SongsPageState();
}

class SongsPageState extends State<SongsPage> {
  TextEditingController searchEngineController = TextEditingController();
  List<Song> allSongs = [];
  List<Song> filteredSongs = [];
  bool isLoading = true;

  late String _groupName;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void loadsongs() {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    Song.loadSongs(_groupName).then((songs) {
      setState(() {
        allSongs = songs;
        filterSongs();
        isLoading = false;
      });
    }).catchError((error) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _groupName = context.read<UserProvider>().groupInfo!.groupName;

    loadsongs();

    searchEngineController.addListener(() {
      filterSongs();
    });
  }

  @override
  void dispose() {
    searchEngineController.dispose();
    super.dispose();
  }

  void filterSongs() {
    String query = searchEngineController.text.toLowerCase();
    if (!mounted) return;
    setState(() {
      filteredSongs = allSongs.where((song) {
        return song.title.toLowerCase().contains(query) ||
            song.lyrics.toLowerCase().contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  boxShadow: const [BOX_SHADOW_CONTAINER]),
              width: screenWidth * 0.72,
              margin: const EdgeInsets.symmetric(vertical: 30),
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: TextField(
                onTapOutside: (event) {
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                autofocus: false,
                controller: searchEngineController,
                decoration: InputDecoration(
                  suffixIcon: Image.asset('./images/search.png', scale: 2),
                  isDense: true,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white,
                  label: Text(
                    'Tutaj wyszukaj piosenki',
                    style: TextStyle(color: Colors.black.withOpacity(0.4), fontSize: 14),
                  ),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: Text('Ładowanie...',
                          style: TextStyle(fontFamily: 'Lexend', color: FONT_BLACK_COLOR)))
                  : filteredSongs.isEmpty
                      ? const Center(
                          child: Text('Brak piosenek',
                              style: TextStyle(fontFamily: 'Lexend', color: FONT_BLACK_COLOR)))
                      : SingleChildScrollView(
                          child: Column(
                            children: filteredSongs.map((song) {
                              int originalIndex = allSongs.indexOf(song) + 1;
                              String displayTitle = "$originalIndex. ${capitalize(song.title)}";

                              return GestureDetector(
                                onTap: () async {
                                  await Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (context) => SongsDetailPage(
                                        song: song,
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
                                          color: Colors.black.withOpacity(0.25),
                                          blurRadius: 4,
                                          spreadRadius: 2,
                                          offset: const Offset(0, 0))
                                    ],
                                  ),
                                  width: screenWidth * 0.8,
                                  child: Padding(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
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
                            }).toList(),
                          ),
                        ),
            ),
          ],
        ),
      ),
    );
  }
}
