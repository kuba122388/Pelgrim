import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/dbfeatures/Song.dart';
import 'package:pelgrim/pages/user-page/songs-page/songs-detail-page.dart';

class SongsPage extends StatefulWidget {
  final String group;
  final Map<String, dynamic> settings;
  final bool admin;

  const SongsPage(
      {super.key,
      required this.group,
      required this.settings,
      required this.admin});

  @override
  State<SongsPage> createState() => SongsPageState();
}

class SongsPageState extends State<SongsPage> {
  TextEditingController searchEngineController = TextEditingController();
  List<Song> allSongs = [];
  List<Song> filteredSongs = [];
  bool isLoading = true;

  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  void loadsongs() {
    if (!mounted) return;
    setState(() {
      isLoading = true;
    });

    Song.loadSongs(widget.group).then((songs) {
      setState(() {
        allSongs = songs;
        for (int i = 0; i < allSongs.length; i++) {
          allSongs[i].title = '${i + 1}. ${capitalize(allSongs[i].title)}';
        }
        filterSongs();
        if (!mounted) return;
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
    List<String> input;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
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
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                  floatingLabelBehavior: FloatingLabelBehavior.never,
                  fillColor: Colors.white,
                  label: Text('Tutaj wyszukaj piosenki',
                      style: TextStyle(
                          color: Colors.black.withOpacity(0.4), fontSize: 14)),
                  border: const OutlineInputBorder(borderSide: BorderSide.none),
                ),
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child: Text('Ładowanie...',
                          style: TextStyle(
                              fontFamily: 'Lexend', color: FONT_BLACK_COLOR)))
                  : filteredSongs.isEmpty
                      ? const Center(
                          child: Text('Brak piosenek',
                              style: TextStyle(
                                  fontFamily: 'Lexend',
                                  color: FONT_BLACK_COLOR)))
                      : SingleChildScrollView(
                          child: Column(
                            children: filteredSongs.map((song) {
                              return GestureDetector(
                                  onTap: () async {
                                    input = song.title.split(' ');
                                    await Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) => SongsDetailPage(
                                              song: Song(
                                                  title: input
                                                      .sublist(1)
                                                      .join(' '),
                                                  lyrics: song.lyrics,
                                                  docId: song.docId),
                                              settings: widget.settings,
                                              admin: widget.admin)),
                                    );
                                    await Future.delayed(
                                        const Duration(milliseconds: 250), () {
                                      setState(() {
                                        loadsongs();
                                      });
                                    });
                                  },
                                  child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          vertical: 8, horizontal: 10),
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          boxShadow: [
                                            BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.25),
                                                blurRadius: 4,
                                                spreadRadius: 2,
                                                offset: const Offset(0, 0))
                                          ]),
                                      width: screenWidth * 0.8,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            vertical: 10, horizontal: 20),
                                        child: Text(
                                          song.title,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontFamily: 'Lexend',
                                            color: FONT_BLACK_COLOR,
                                          ),
                                        ),
                                      )));
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
