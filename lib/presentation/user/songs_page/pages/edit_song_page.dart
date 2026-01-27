import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/providers/song_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/songs_page/widgets/edit_song_topbar.dart';
import 'package:provider/provider.dart';

class EditSongPage extends StatefulWidget {
  final Song song;

  const EditSongPage({super.key, required this.song});

  @override
  State<EditSongPage> createState() => _EditSongPageState();
}

class _EditSongPageState extends State<EditSongPage> {
  late final TextEditingController _titleController = TextEditingController();
  late final TextEditingController _lyricsController = TextEditingController();
  late final String _groupId;

  @override
  void initState() {
    super.initState();
    _titleController.text = widget.song.title;
    _lyricsController.text = widget.song.lyrics;
    _groupId = context.read<UserProvider>().userGroupId;
  }

  Future<void> _editSong() async {
    try {
      final editedSong = Song(
        id: widget.song.id,
        title: _titleController.text,
        lyrics: _lyricsController.text,
      );

      await context.read<SongProvider>().editSong(_groupId, editedSong);

      Navigator.pop(context);
    } catch (_) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nie udało się zapisać zmian')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: EditSongTopbar(onAccept: _editSong),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Center(
              child: Container(
                height: keyboardHeight == 0
                    ? screenHeight * 0.85
                    : screenHeight * 0.85 - keyboardHeight,
                width: screenWidth * 0.91,
                margin: EdgeInsets.symmetric(vertical: screenHeight * 0.03),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth * 0.80,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BOX_SHADOW_CONTAINER]),
                      child: TextField(
                        controller: _titleController,
                        textCapitalization: TextCapitalization.sentences,
                        decoration:
                            const InputDecoration(border: InputBorder.none, hintText: 'Tytuł'),
                        style: const TextStyle(fontSize: FONT_SIZE_BIG, fontFamily: 'Lexend'),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: keyboardHeight == 0 ? screenHeight * 0.7 : screenHeight * 0.4,
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: const [BOX_SHADOW_CONTAINER],
                        ),
                        child: TextField(
                          textInputAction: TextInputAction.newline,
                          controller: _lyricsController,
                          expands: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Tekst z akordami'),
                          style: const TextStyle(
                              fontSize: FONT_SIZE_SMALL, fontFamily: 'Lexend', letterSpacing: 0.1),
                          maxLines: null,
                          minLines: null,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
