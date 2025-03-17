import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/dbfeatures/Announcement.dart';
import 'package:pelgrim/dbfeatures/User.dart';
import 'package:pelgrim/consts.dart';

class AnnouncementsPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final MyUser myUser;

  const AnnouncementsPage(
      {super.key, required this.settings, required this.myUser});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool important = false;

  void refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final group =
        '${widget.settings['groupColor']} - ${widget.settings['groupCity']}';
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return SafeArea(
        child: SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Column(
          children: [
            Padding(
                padding: EdgeInsets.only(
                    top: screenHeight * 0.02, bottom: screenHeight * 0.01),
                child: const Text('Dodaj Ogłoszenie',
                    style: TextStyle(
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.bold,
                        color: FONT_BLACK_COLOR,
                        fontSize: 18,
                        shadows: [APP_TEXT_SHADOW]))),
            Expanded(
              child: SizedBox(
                width: screenWidth * 0.85,
                child: Column(
                  children: [
                    InkWell(
                        onTap: () =>
                            {_showAddAnnouncementWidget(group, refresh)},
                        child: _addAnnouncement(screenWidth, screenHeight)),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      height: screenHeight * 0.73,
                      padding:
                          const EdgeInsets.only(top: 15, left: 15, right: 15),
                      decoration: BoxDecoration(
                          color: BACKGROUND_CONTAINERS_COLOR,
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Tablica ogłoszeń',
                                  style: TextStyle(
                                      fontFamily: 'Lexend',
                                      fontWeight: FontWeight.bold,
                                      color: FONT_BLACK_COLOR,
                                      fontSize: FONT_SIZE_BIG)),
                              Row(
                                children: [
                                  SizedBox(
                                      width: 36,
                                      height: 24,
                                      child: Checkbox(
                                        value: important,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            important = value!;
                                          });
                                        },
                                        activeColor: Colors.grey,
                                      )),
                                  const Text('Ważne',
                                      style: TextStyle(
                                          fontFamily: 'Lexend',
                                          fontWeight: FontWeight.bold,
                                          fontSize: FONT_SIZE_SMALL,
                                          color: FONT_BLACK_COLOR))
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Expanded(child: _displayAnnouncements(group)),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ));
  }

  StreamBuilder<List<Announcement>> _displayAnnouncements(String group) {
    return StreamBuilder<List<Announcement>>(
        stream: Announcement.loadAnnouncementsAsStream(group),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Błąd: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Brak ogłoszeń',
                style: TextStyle(
                    fontFamily: 'Lexend',
                    color: FONT_BLACK_COLOR
                ),
              ),
            );
          } else {
            List<Announcement> announcements = snapshot.data!;
            return SingleChildScrollView(
                child: Column(
                  children: announcements.map((announcement) {
                    return Visibility(
                        visible: important == true ? announcement.important : true,
                        child: Container(
                            padding: const EdgeInsets.all(15),
                            margin: const EdgeInsets.only(bottom: 10),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    Padding(
                                        padding: const EdgeInsets.only(right: 5),
                                        child: Text(
                                          announcement.anonymous == false
                                              ? announcement.author
                                              : 'Autor Anonimowy',
                                          style: const TextStyle(fontFamily: 'Lexend'),
                                        )
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(right: 10),
                                        child: Text(
                                          '${announcement.date.day}.${announcement.date.month}.${announcement.date.year} ${announcement.date.hour}:${announcement.date.minute}:${announcement.date.second}',
                                          style: const TextStyle(
                                              fontSize: 8,
                                              fontFamily: 'Lexend'
                                          ),
                                        )
                                    ),
                                    Visibility(
                                        visible: announcement.important,
                                        child: const Text(
                                          'WAŻNE!',
                                          style: TextStyle(
                                              fontSize: 10,
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold
                                          ),
                                        )
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Flexible(
                                        child: Padding(
                                            padding: const EdgeInsets.only(top: 5, bottom: 10),
                                            child: Text(
                                              announcement.content,
                                              style: const TextStyle(fontSize: FONT_SIZE_SMALL),
                                              softWrap: true,
                                            )
                                        )
                                    )
                                  ],
                                ),
                                Visibility(
                                    visible: announcement.author ==
                                        '${widget.myUser.firstName} ${widget.myUser.lastName}'
                                        ? true
                                        : false,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        InkWell(
                                            onTap: () => _deleteAnnouncement(announcement, group),
                                            child: Image.asset('./images/trash.png', width: 15)
                                        )
                                      ],
                                    )
                                )
                              ],
                            )
                        )
                    );
                  }).toList(),
                )
            );
          }
        }
    );
  }

  Row _addAnnouncement(screenWidth, screenHeight) {
    return Row(
      children: [
        Expanded(
            child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
                decoration: BoxDecoration(
                    color: BACKGROUND_CONTAINERS_COLOR,
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(10)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      margin: const EdgeInsets.only(right: 10, left: 3),
                      decoration: BoxDecoration(
                          color: const Color(0xC0FFFFFF),
                          borderRadius: BorderRadius.circular(5)),
                    )),
                    Image.asset('./images/plus.png', height: 24)
                  ],
                )))
      ],
    );
  }

  Future<void> _showAddAnnouncementWidget(String group, Function notifyParent) {
    final screenWidth = MediaQuery.of(context).size.width;
    bool important = false;
    bool anonymous = false;
    bool processing = false;

    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (BuildContext context) {
        TextEditingController announcementController = TextEditingController();

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Dodaj ogłoszenie'),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                    },
                    child: Image.asset(
                      './images/close.png',
                      width: 28,
                      color: Colors.white.withOpacity(0.2),
                      colorBlendMode: BlendMode.lighten,
                    ),
                  ),
                ],
              ),
              titleTextStyle: const TextStyle(
                fontSize: FONT_SIZE_BIG,
                color: FONT_BLACK_COLOR,
                fontFamily: 'Lexend',
                fontWeight: FontWeight.bold,
                shadows: [APP_TEXT_SHADOW],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Treść',
                      style: TextStyle(
                        fontSize: FONT_SIZE_BIG,
                        color: FONT_BLACK_COLOR,
                        fontFamily: 'Lexend',
                        fontWeight: FontWeight.bold,
                        shadows: [APP_TEXT_SHADOW],
                      ),
                    ),
                    Container(
                      width: screenWidth * 0.7,
                      margin: const EdgeInsets.only(top: 10, bottom: 20),
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: BACKGROUND_CONTAINERS_COLOR,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: TextField(
                        controller: announcementController,
                        decoration:
                            const InputDecoration(border: InputBorder.none),
                        textCapitalization: TextCapitalization.sentences,
                        style: const TextStyle(fontSize: FONT_SIZE_SMALL),
                        maxLines: 8,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 24,
                              child: Checkbox(
                                activeColor: Colors.grey,
                                value: important,
                                onChanged: (bool? value) {
                                  setState(() {
                                    important = value!;
                                  });
                                },
                              ),
                            ),
                            const Text(
                              'Oznacz jako ważne',
                              style:
                                  TextStyle(fontSize: 10, fontFamily: 'Lexend'),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 30,
                              height: 24,
                              child: Checkbox(
                                value: anonymous,
                                activeColor: Colors.grey,
                                onChanged: (bool? value) {
                                  setState(() {
                                    anonymous = value!;
                                  });
                                },
                              ),
                            ),
                            const Text(
                              'Post anonimowy',
                              style:
                                  TextStyle(fontSize: 10, fontFamily: 'Lexend'),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 20),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (processing == false) {
                                setState(() {
                                  processing = true;
                                });
                                if (announcementController.text != '') {
                                  await Announcement(
                                    anonymous: anonymous,
                                    important: important,
                                    author:
                                        '${widget.myUser.firstName} ${widget.myUser.lastName}',
                                    content: announcementController.text,
                                    date: DateTime.now(),
                                  ).save(group);
                                  await Future.delayed(
                                      const Duration(milliseconds: 500));
                                  notifyParent();
                                }
                                Navigator.of(context).pop();
                              }
                            },
                            child: const Text('Opublikuj',
                                style: TextStyle(color: Colors.black)),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _deleteAnnouncement(Announcement announcement, String group) {
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    ElevatedButton buttonOption(text) {
      bool processing = false;
      return ElevatedButton(
          onPressed: () async => {
                if (processing == false)
                  {
                    setState(() {
                      processing = true;
                    }),
                    if (text == 'Usuń')
                      {
                        await announcement.delete(group),
                        setState(() {
                          _displayAnnouncements(group);
                        })
                      },
                    Navigator.of(context).pop()
                  }
              },
          style: ButtonStyle(
              foregroundColor: text == 'Usuń'
                  ? WidgetStateProperty.all<Color>(Colors.white)
                  : WidgetStateProperty.all<Color>(FONT_BLACK_COLOR),
              backgroundColor: text == 'Usuń'
                  ? const WidgetStatePropertyAll<Color>(Colors.red)
                  : const WidgetStatePropertyAll<Color>(Colors.white),
              padding: WidgetStateProperty.all<EdgeInsets>(
                  const EdgeInsets.symmetric(horizontal: 20)),
              textStyle: WidgetStateProperty.all<TextStyle>(
                  const TextStyle(fontFamily: 'Lexend'))),
          child: SizedBox(width: 60, child: Center(child: Text(text))));
    }

    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Czy na pewno chcesz usunąć ten wpis?',
            textAlign: TextAlign.center,
          ),
          titleTextStyle: const TextStyle(
            fontSize: 18,
            color: Colors.black,
            fontFamily: 'Lexend',
          ),
          content: Container(
              constraints: BoxConstraints(minHeight: screenHeight * 0.15),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: Text(
                        '"${announcement.content}"',
                        style: const TextStyle(
                          fontFamily: 'Lexend',
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          buttonOption('Anuluj'),
                          buttonOption('Usuń')
                        ],
                      ),
                    ),
                  ],
                ),
              )),
        );
      },
    );
  }
}
