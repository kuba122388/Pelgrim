import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';

class HelpPage extends StatefulWidget {
  final Map<String, dynamic> settings;

  const HelpPage({super.key, required this.settings});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  User? user = FirebaseAuth.instance.currentUser;
  bool processing = false;

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    contentController.dispose();
  }

  Future<void> sendMsg() async {
    if (processing == true) return;
    setState(() {
      processing = true;
    });

    if (titleController.text == '' || contentController.text == '') {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(seconds: 2),
          content: Center(
              child: Padding(
        padding: EdgeInsets.symmetric(vertical: 4.0),
        child: Text('Temat lub opis zgłoszenia jest pusty',
            style: TextStyle(fontSize: 16)),
      ))));
      setState(() {
        processing = false;
      });
      return;
    }

    if (user == null) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 2),
          padding: EdgeInsets.symmetric(vertical: 4.0),
          content: Center(
              child: Text('Problem z wysyłaniem - nieznany użytkownik',
                  style: TextStyle(fontSize: 16)))));
      setState(() {
        processing = false;
      });
      return;
    }

    try {
      await FirebaseFirestore.instance
          .collection('Problems')
          .doc(
              '${widget.settings['groupColor']} - ${widget.settings['groupCity']}')
          .collection('Uid: ${user!.uid}')
          .add(<String, dynamic>{
        'Title': titleController.text,
        'Content': contentController.text,
        'Solved': false
      });
      titleController.clear();
      contentController.clear();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          duration: Duration(seconds: 2),
          padding: EdgeInsets.symmetric(vertical: 4.0),
          content: Center(
              child: Text('Wiadomość wysłano pomyślnie!',
                  style: TextStyle(fontSize: 16)))));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(seconds: 2),
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          content: Center(
              child: Text('Problem z wysyłaniem - $e',
                  style: const TextStyle(fontSize: 16)))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Center(
            child: SingleChildScrollView(
          child: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            decoration: BoxDecoration(
                boxShadow: const [BOX_SHADOW_CONTAINER],
                borderRadius: BorderRadius.circular(20),
                color: Colors.white),
            height: screenHeight * 0.8,
            width: screenWidth * 0.9,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.only(top: screenHeight * 0.03),
                  child: const Text(
                    'Natknąłeś/aś się na problem z aplikacją?\nMoże masz pomysł czego jej brakuje?\n\nTutaj możesz to wszystko opisać',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Lexend',
                      fontSize: 15,
                    ),
                  ),
                ),
                const Spacer(),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 22, bottom: screenHeight * 0.02),
                      child: const Text(
                        'Temat',
                        style: TextStyle(
                            fontFamily: 'Lexend', fontSize: FONT_SIZE_BIG),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BOX_SHADOW_CONTAINER]),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: titleController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Wpisz temat zgłoszenia'),
                        style: const TextStyle(
                            fontSize: FONT_SIZE_MEDIUM, fontFamily: 'Lexend'),
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          left: 22, bottom: screenHeight * 0.02),
                      child: const Text(
                        'Treść',
                        style: TextStyle(
                            fontFamily: 'Lexend', fontSize: FONT_SIZE_BIG),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.25,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 22, vertical: 10),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BOX_SHADOW_CONTAINER]),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        minLines: null,
                        maxLines: null,
                        expands: true,
                        controller: contentController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: 'Opisz swój problem'),
                        style: const TextStyle(
                            fontSize: FONT_SIZE_MEDIUM, fontFamily: 'Lexend'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                        onTap: () => sendMsg(),
                        child: Container(
                            width: screenWidth * 0.3,
                            padding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 10),
                            decoration: BoxDecoration(
                                boxShadow: const [BOX_SHADOW_CONTAINER],
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                const Padding(
                                  padding: EdgeInsets.only(left: 8),
                                  child: Text(
                                    'Wyślij',
                                    style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontSize: FONT_SIZE_MEDIUM),
                                  ),
                                ),
                                Image.asset('./images/send.png', width: 20)
                              ],
                            )))
                  ],
                ),
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Autor aplikacji: Jakub Bak\nTel: 516-378-064',
                      style: TextStyle(
                          fontFamily: 'Lexend',
                          color: LIST_TILE_INACTIVE_COLOR),
                      textAlign: TextAlign.end,
                    ),
                  ],
                )
              ],
            ),
          ),
        )));
  }
}
