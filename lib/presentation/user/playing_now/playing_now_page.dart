import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/core/di/service_locator.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/domain/usecases/song/watch_playing_now_use_case.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class PlayingNowPage extends StatefulWidget {
  const PlayingNowPage({super.key});

  @override
  State<PlayingNowPage> createState() => _PlayingNowPageState();
}

class _PlayingNowPageState extends State<PlayingNowPage> {
  final WatchPlayingNowUseCase _getPlayingNowStreamUseCase = sl<WatchPlayingNowUseCase>();

  late String _groupId;

  @override
  void initState() {
    super.initState();

    final Group groupInfo = context.read<UserProvider>().groupInfo!;
    _groupId = groupInfo.id!;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return SafeArea(
      child: Center(
        child: StreamBuilder<Song?>(
          stream: _getPlayingNowStreamUseCase.execute(_groupId),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Błąd: ${snapshot.error}');
            } else if (!snapshot.hasData || snapshot.data == null) {
              return const Text('Brak granej piosenki');
            }
            final currentSong = snapshot.data!;
            return Container(
              decoration: BoxDecoration(
                boxShadow: const [BOX_SHADOW_CONTAINER],
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
              ),
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              width: screenWidth * 0.91,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    currentSong.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontFamily: 'Lexend', fontSize: 22),
                  ),
                  const Row(mainAxisAlignment: MainAxisAlignment.center, children: [
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
                        child: SizedBox(
                          width: screenWidth * 0.9,
                          child: Text(
                            currentSong.lyrics,
                            style: const TextStyle(
                              fontFamily: 'Lexend',
                              fontSize: 14,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
