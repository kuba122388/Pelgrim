import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../providers/song_provider.dart';

class PlayingNowPage extends StatefulWidget {
  const PlayingNowPage({super.key});

  @override
  State<PlayingNowPage> createState() => _PlayingNowPageState();
}

class _PlayingNowPageState extends State<PlayingNowPage> {
  @override
  void initState() {
    super.initState();

    final userProvider = context.read<UserProvider>();

    WidgetsBinding.instance.addPostFrameCallback(
        (_) => context.read<SongProvider>().startSongList(userProvider.userGroupId));
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final songProvider = context.watch<SongProvider>();
    final currentSong = songProvider.playingNowSong;

    return SafeArea(
      child: Center(
        child: _buildContent(currentSong, songProvider.isLoading, screenWidth, screenHeight),
      ),
    );
  }

  Widget _buildContent(Song? currentSong, bool isLoading, double width, double height) {
    if (isLoading && currentSong == null) {
      return const CircularProgressIndicator();
    }

    if (currentSong == null) {
      return const Text('Brak granej piosenki', style: TextStyle(fontFamily: 'Lexend'));
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: const [BOX_SHADOW_CONTAINER],
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        margin: EdgeInsets.symmetric(vertical: height * 0.02),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
        child: Column(
          children: [
            Text(
              currentSong.title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontFamily: 'Lexend', fontSize: 22),
            ),
            const SizedBox(
              width: 50,
              child: Divider(color: Colors.black),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Scrollbar(
                thumbVisibility: true,
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Text(
                      currentSong.lyrics,
                      style: const TextStyle(fontFamily: 'Lexend', fontSize: 14),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
