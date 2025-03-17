import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/dbfeatures/Song.dart';
import 'package:pelgrim/pages/user-page/songs-page/songs-detail-topbar.dart';

class SongsDetailPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final bool admin;
  final Song song;

  const SongsDetailPage(
      {super.key,
      required this.song,
      required this.settings,
      required this.admin});

  @override
  State<SongsDetailPage> createState() => _SongsDetailPageState();
}

class _SongsDetailPageState extends State<SongsDetailPage> {
  late Future<Song> _playingNow;
  late String _group;

  @override
  void initState() {
    super.initState();
    _group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';
    _playingNow = Song.playingNow(_group);
  }

  void _refreshPlayingNow() {
    setState(() {
      _playingNow = Song.playingNow(_group);
    });
  }

  @override
  Widget build(BuildContext context) {
    Song song = widget.song;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    Color firstColor = Color(int.parse(widget.settings['color'], radix: 16));
    Color secondColor =
        Color(int.parse(widget.settings['secondColor'], radix: 16));

    Future<void> changedSong() async{
      await song.refreshSong(_group);
      setState(() {});
    }

    return Scaffold(
      appBar: SongsDetailTopbar(
          song: widget.song,
          settings: widget.settings,
          edit: changedSong,
          admin: widget.admin),
      body: SafeArea(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: const [BOX_SHADOW_CONTAINER],
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            width: screenWidth * 0.91,
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Text(
                    song.title,
                    textAlign: TextAlign.center,
                    softWrap: true,
                    style: const TextStyle(fontFamily: 'Lexend', fontSize: 22),
                  ),
                ),
                const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50,
                        child: Divider(
                          color: Colors.black,
                        ),
                      ),
                    ]),
                Expanded(
                  child: Scrollbar(
                    thumbVisibility: true,
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: Text(
                          song.lyrics,
                          style: const TextStyle(
                            letterSpacing: 0.1,
                            fontFamily: 'Lexend',
                            fontSize: FONT_SIZE_SMALL,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FutureBuilder<Song>(
                      future: _playingNow,
                      builder: (context, snapshot) {
                        Color firstColorHere = Colors.white;
                        Color secondColorHere = Colors.white;
                        if (snapshot.connectionState == ConnectionState.done &&
                            snapshot.hasData) {
                          final playingNow = snapshot.data!;
                          if (widget.song.lyrics == playingNow.lyrics) {
                            firstColorHere = firstColor;
                            secondColorHere = secondColor;
                          }
                        }

                        return Visibility(
                            visible: widget.admin,
                            child: InkWell(
                                onTap: () {
                                  widget.song.requestSong(_group);
                                  _refreshPlayingNow();
                                },
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      bottom: 10, top: 10),
                                  width: 50,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    gradient: RadialGradient(
                                      center: Alignment.center,
                                      radius: 1.0,
                                      colors: [secondColorHere, firstColorHere],
                                      stops: const [0.2, 0.8],
                                    ),
                                    borderRadius: BorderRadius.circular(30),
                                    boxShadow: const [BOX_SHADOW_CONTAINER],
                                  ),
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                      padding: WidgetStateProperty.all(
                                          EdgeInsets.zero),
                                      backgroundColor: WidgetStateProperty.all(
                                          Colors.transparent),
                                    ),
                                    onPressed: null,
                                    child: Image.asset(
                                      './images/radio-waves.png',
                                      width: 30,
                                      height: 30,
                                      color: firstColorHere == Colors.white
                                          ? Colors.black.withOpacity(0.6)
                                          : Colors.white,
                                      colorBlendMode: BlendMode.srcIn,
                                    ),
                                  ),
                                )));
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
