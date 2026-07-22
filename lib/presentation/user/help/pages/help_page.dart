import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_snack_bars.dart';
import '../../../providers/help_provider.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  @override
  void dispose() {
    titleController.dispose();
    contentController.dispose();
    super.dispose();
  }

  Future<void> _send(BuildContext context) async {
    final helpProvider = context.read<HelpProvider>();

    final userProvider = context.read<UserProvider>();
    final user = userProvider.user!;

    if (titleController.text.isEmpty || contentController.text.isEmpty) {
      AppSnackBars.error(context, 'Temat lub treść nie może być pusta');
      return;
    }

    try {
      await helpProvider.send(
        title: titleController.text,
        content: contentController.text,
        groupId: user.groupId,
        userEmail: user.email,
      );

      titleController.clear();
      contentController.clear();

      if (!context.mounted) return;
      AppSnackBars.success(context, 'Wiadomość wysłano pomyślnie!');
    } catch (_) {
      if (!context.mounted) return;
      AppSnackBars.error(context, 'Wystąpił błąd podczas wysyłania');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final HelpProvider helpProvider = context.watch<HelpProvider>();

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
                const Padding(
                  padding: EdgeInsets.only(top: 20),
                  child: Text(
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
                    const Padding(
                      padding: EdgeInsets.only(left: 22, bottom: 15),
                      child: Text(
                        'Temat',
                        style: TextStyle(fontFamily: 'Lexend', fontSize: FONT_SIZE_BIG),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      margin: const EdgeInsets.only(bottom: 30),
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(25),
                          boxShadow: const [BOX_SHADOW_CONTAINER]),
                      child: TextField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: titleController,
                        decoration: const InputDecoration(
                            border: InputBorder.none, hintText: 'Temat zgłoszenia'),
                        style: const TextStyle(fontSize: FONT_SIZE_MEDIUM, fontFamily: 'Lexend'),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 22, bottom: screenHeight * 0.02),
                      child: const Text(
                        'Treść',
                        style: TextStyle(fontFamily: 'Lexend', fontSize: FONT_SIZE_BIG),
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.75,
                      height: screenHeight * 0.25,
                      margin: EdgeInsets.only(bottom: screenHeight * 0.03),
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 10),
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
                            border: InputBorder.none, hintText: 'Opisz swój problem'),
                        style: const TextStyle(fontSize: FONT_SIZE_MEDIUM, fontFamily: 'Lexend'),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    InkWell(
                      onTap: () => helpProvider.isProcessing ? null : _send(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 10),
                        decoration: BoxDecoration(
                            boxShadow: const [BOX_SHADOW_CONTAINER],
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8),
                              child: Text(
                                helpProvider.isProcessing ? 'Wysyłanie...' : 'Wyślij',
                                style: const TextStyle(
                                    fontFamily: 'Lexend', fontSize: FONT_SIZE_MEDIUM),
                              ),
                            ),
                            const SizedBox(
                              width: 8,
                            ),
                            Image.asset('./images/send.png', width: 20)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Autor aplikacji: Jakub Bak',
                      style: TextStyle(fontFamily: 'Lexend', color: LIST_TILE_INACTIVE_COLOR),
                      textAlign: TextAlign.end,
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
