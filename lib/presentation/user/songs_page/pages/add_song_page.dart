import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/songs_page/widgets/add_song_topbar.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_snack_bars.dart';
import '../../../providers/song_provider.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _lyricsController = TextEditingController();
  late final String _groupId;

  @override
  void initState() {
    super.initState();
    _groupId = context.read<UserProvider>().userGroupId;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _lyricsController.dispose();
    super.dispose();
  }

  Future<void> _addSong() async {
    final title = _titleController.text.trim();
    final lyrics = _lyricsController.text.trim();

    if (title.isEmpty || lyrics.isEmpty) {
      AppSnackBars.error(context, 'Pole z tytułem lub słowami jest puste.');
      return;
    }

    final songProvider = context.read<SongProvider>();
    final song = Song(title: title, lyrics: lyrics);

    try {
      await songProvider.addSong(_groupId, song);
      if (!mounted) return;

      AppSnackBars.success(context, "Piosenka utworzona pomyślnie.");
      Navigator.of(context).pop(true);
    } catch (e) {
      AppSnackBars.error(context, 'Wystąpił problem podczas dodawania piosenki: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final isAdding = context.watch<SongProvider>().isAdding;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AddSongTopBar(
        onAccept: isAdding ? null : _addSong,
      ),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Container(
              height: screenHeight * 0.85,
              width: screenWidth,
              margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03, horizontal: 15),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.85,
                        margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [BOX_SHADOW_CONTAINER]),
                        child: TextField(
                          controller: _titleController,
                          decoration:
                              const InputDecoration(border: InputBorder.none, hintText: 'Tytuł'),
                          style: const TextStyle(fontSize: FONT_SIZE_BIG, fontFamily: 'Lexend'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.85,
                        height: keyboardHeight == 0 ? screenHeight * 0.7 : screenHeight * 0.4,
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [BOX_SHADOW_CONTAINER]),
                        child: TextField(
                          textInputAction: TextInputAction.newline,
                          controller: _lyricsController,
                          expands: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Tekst z akordami'),
                          style: const TextStyle(fontSize: 12, fontFamily: 'Lexend'),
                          maxLines: null,
                          minLines: null,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
