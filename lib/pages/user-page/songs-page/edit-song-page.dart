import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/models/Song.dart';
import 'package:pelgrim/pages/user-page/songs-page/edit-song-topbar.dart';

class EditSongPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final Song song;

  const EditSongPage({super.key, required this.song, required this.settings});

  @override
  State<EditSongPage> createState() => _EditSongPageState();
}

class _EditSongPageState extends State<EditSongPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController lyricsController = TextEditingController();

  @override
  void initState() {
    super.initState();
      titleController.text = widget.song.title;
      lyricsController.text = widget.song.lyrics;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';

    Future<void> editSong(group) async {
      Song song = Song(
          title: titleController.text,
          lyrics: lyricsController.text,
          docId: widget.song.docId);
      try {
        await song.editSong(group);
        Navigator.pop(context, true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
                child:
                Text('Wystąpił problem podczas edytowania piosenki: $e'))));
      }
    }

    return Scaffold(
        appBar: EditSongTopbar(
            settings: widget.settings, onAccept: () => editSong(group)),
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
                  height: keyboardHeight == 0 ? screenHeight * 0.85 : screenHeight*0.85 - keyboardHeight,
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
                          controller: titleController,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Tytuł'),
                          style: const TextStyle(
                              fontSize: FONT_SIZE_BIG, fontFamily: 'Lexend'),
                        ),
                      ),
                      Expanded(
                          child: Container(
                        height: keyboardHeight == 0
                            ? screenHeight * 0.7
                            : screenHeight * 0.4,
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 15, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: const [BOX_SHADOW_CONTAINER]),
                        child: TextField(
                          textInputAction: TextInputAction.newline,
                          controller: lyricsController,
                          expands: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tekst z akordami'),
                          style: const TextStyle(
                              fontSize: FONT_SIZE_SMALL, fontFamily: 'Lexend', letterSpacing: 0.1),
                          maxLines: null,
                          minLines: null,
                        ),
                      ))
                    ],
                  )),
            ),
          )),
        ));
  }
}
