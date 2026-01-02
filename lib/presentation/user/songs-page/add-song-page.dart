import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/consts.dart';
import 'package:pelgrim/domain/entities/group_info.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/user/songs-page/add-song-topbar.dart';
import 'package:pelgrim/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddSongPage extends StatefulWidget {
  const AddSongPage({super.key});

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
    final GroupInfo groupInfo = context.read<UserProvider>().groupInfo!;

    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    Future<void> addSong(group) async {
      if (titleController.text == '' || lyricsController.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 2),
            content: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text('Pole z tytułem lub słowami jest puste', style: TextStyle(fontSize: 16)),
            ))));
        return;
      }
      Song song = Song(title: titleController.text, lyrics: lyricsController.text);
      try {
        await song.addSong(group);
        Navigator.of(context).pop(true);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Center(child: Text('Wystąpił problem podczas dodawania piosenki: $e'))));
      }
    }

    return Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AddSongTopBar(onAccept: () => addSong(groupInfo.groupName)),
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
                          controller: titleController,
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
                          controller: lyricsController,
                          expands: true,
                          decoration: const InputDecoration(
                              border: InputBorder.none, hintText: 'Tekst z akordami'),
                          style: const TextStyle(fontSize: 12, fontFamily: 'Lexend'),
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
