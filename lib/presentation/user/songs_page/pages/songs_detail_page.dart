import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/providers/song_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/songs_page/widgets/songs_detail_topbar.dart';
import 'package:provider/provider.dart';

class SongsDetailPage extends StatefulWidget {
  final String songId;

  const SongsDetailPage({
    super.key,
    required this.songId,
  });

  @override
  State<SongsDetailPage> createState() => _SongsDetailPageState();
}

class _SongsDetailPageState extends State<SongsDetailPage> {
  late final SongProvider _songProvider;
  late final UserProvider _userProvider;
  late final String _groupId;

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();
    _groupId = _userProvider.userGroupId;
  }

  @override
  Widget build(BuildContext context) {
    final groupInfo = _userProvider.groupInfo!;
    final bool isAdmin = context.watch<UserProvider>().user!.isAdmin;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    Color firstColor = groupInfo.color;
    Color secondColor = groupInfo.secondColor;

    final songProvider = context.watch<SongProvider>();

    final song = songProvider.songs.firstWhere(
      (s) => s.id == widget.songId,
      orElse: () => throw Exception('Song not found'),
    );

    final isPlayingNow = songProvider.playingNowSong?.id == song.id;

    return Scaffold(
      appBar: SongsDetailTopbar(song: song),
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
                  ],
                ),
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
                    StreamBuilder<Song>(
                      stream: songProvider,
                      builder: (context, snapshot) {
                        Color firstColorHere = Colors.white;
                        Color secondColorHere = Colors.white;
                        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                          final playingNow = snapshot.data!;
                          if (widget.songId.lyrics == playingNow.lyrics) {
                            firstColorHere = firstColor;
                            secondColorHere = secondColor;
                          }
                        }

                        if (isAdmin) {
                          InkWell(
                            onTap: () {
                              widget.songId.streamSong(_groupId);
                              _refreshPlayingNow();
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 10, top: 10),
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
                                  padding: WidgetStateProperty.all(EdgeInsets.zero),
                                  backgroundColor: WidgetStateProperty.all(Colors.transparent),
                                ),
                                onPressed: null,
                                child: Image.asset(
                                  './images/radio-waves.png',
                                  width: 30,
                                  height: 30,
                                  color: firstColorHere == Colors.white
                                      ? Colors.black.withValues(alpha: 0.6)
                                      : Colors.white,
                                  colorBlendMode: BlendMode.srcIn,
                                ),
                              ),
                            ),
                          );
                        }
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
