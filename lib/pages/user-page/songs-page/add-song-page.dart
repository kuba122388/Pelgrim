import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/dbfeatures/Song.dart';
import 'package:pelgrim/pages/user-page/songs-page/add-song-topbar.dart';

class AddSongPage extends StatefulWidget {
  final Map<String, dynamic> settings;

  const AddSongPage({super.key, required this.settings});

  @override
  State<AddSongPage> createState() => _AddSongPageState();
}

class _AddSongPageState extends State<AddSongPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController lyricsController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    lyricsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    final group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';

    Future<void> addSong(group) async {
      if (titleController.text == '' || lyricsController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text('Pole z tytułem lub słowami jest puste',
                  style: TextStyle(fontSize: 16)),
            ))));
        return;
      }
      Song song =
          Song(title: titleController.text, lyrics: lyricsController.text);
      try {
        await song.addSong(group);
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(
                child:
                    Text('Wystąpił problem podczas dodawania piosenki: $e'))));
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AddSongTopBar(
            settings: widget.settings, onAccept: () => addSong(group)),
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
              margin: EdgeInsets.symmetric(
                  vertical: screenHeight * 0.03, horizontal: 15),
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
                          controller: titleController,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Tytuł'),
                          style: const TextStyle(
                              fontSize: FONT_SIZE_BIG, fontFamily: 'Lexend'),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        width: screenWidth * 0.85,
                        height: keyboardHeight == 0
                            ? screenHeight * 0.7
                            : screenHeight * 0.4,
                        margin: EdgeInsets.only(bottom: screenHeight * 0.01),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 22, vertical: 10),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(25),
                            boxShadow: const [BOX_SHADOW_CONTAINER]),
                        child: TextField(
                          textInputAction: TextInputAction.newline,
                          controller: lyricsController,
                          expands: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              hintText: 'Tekst z akordami'),
                          style: const TextStyle(
                              fontSize: 12, fontFamily: 'Lexend'),
                          maxLines: null,
                          minLines: null,
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )),
        ));
  }
}
