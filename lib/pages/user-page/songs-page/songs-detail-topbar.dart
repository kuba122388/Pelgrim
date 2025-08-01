import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/models/Song.dart';
import 'package:pelgrim/models/MyUser.dart';
import 'package:pelgrim/pages/user-page/settings-page/settings-page.dart';
import 'package:pelgrim/pages/user-page/songs-page/edit-song-page.dart';

class SongsDetailTopbar extends StatefulWidget implements PreferredSizeWidget {
  final Map<String, dynamic> settings;
  final Song song;
  final bool admin;
  final VoidCallback edit;

  const SongsDetailTopbar(
      {super.key,
      required this.settings,
      required this.song,
      required this.edit,
      required this.admin});

  @override
  State<SongsDetailTopbar> createState() => _SongsDetailTopbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SongsDetailTopbarState extends State<SongsDetailTopbar> {
  late MyUser? myUser;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;

    String? email;
    String title = widget.settings['groupColor'];
    String subtitle = widget.settings['groupCity'];
    Color firstColor = Color(int.parse(widget.settings['color'], radix: 16));
    Color secondColor =
        Color(int.parse(widget.settings['secondColor'], radix: 16));

    return PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: ClipPath(
          clipper: TopBarClipper(),
          child: Container(
            width: screenWidth,
            height: screenHeight * 0.1 + statusBar,
            padding: EdgeInsets.only(top: statusBar + 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [firstColor, secondColor],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                SizedBox(
                  width: screenWidth * 0.9,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      InkWell(
                          onTap: () => {Navigator.of(context).pop(true)},
                          child: Image.asset('./images/back-arrow-2.png',
                              width: 25)),
                      Visibility(
                          visible: widget.admin,
                          child: InkWell(
                            onTap: () async {
                              bool? edited = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditSongPage(
                                        song: widget.song,
                                        settings: widget.settings)),
                              );
                              if (edited == true) {
                                widget.edit();
                              }
                            },
                            child: Image.asset('./images/edit.png', width: 25),
                          )),
                      Container(
                          constraints:
                              BoxConstraints(minWidth: screenWidth * 0.35),
                          child: Center(
                              child: Text(
                            title,
                            style: TextStyle(
                              color: secondColor == const Color(0xFFFFFFFF)
                                  ? Colors.black
                                  : Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ))),
                      Visibility(
                          visible: widget.admin,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Potwierdzenie'),
                                    content: const Text(
                                        'Czy na pewno chcesz usunąć tę piosenkę?'),
                                    actions: [
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(
                                                    horizontal: 0)),
                                            elevation:
                                                WidgetStateProperty.all(2.0),
                                          ),
                                          child: const Text('Anuluj',
                                              style: TextStyle(
                                                  color: FONT_BLACK_COLOR)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            elevation:
                                                WidgetStateProperty.all(2.0),
                                            backgroundColor:
                                                WidgetStateProperty.all(
                                                    Colors.red),
                                          ),
                                          child: const Text(
                                            'Usuń',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            await widget.song.deleteSong(
                                                '$title - $subtitle');
                                            Navigator.of(context).pop();
                                            Navigator.of(context).pop(true);
                                          },
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: Image.asset(
                              './images/trash.png',
                              width: 20,
                              color: Colors.white,
                              colorBlendMode: BlendMode.srcIn,
                            ),
                          )),
                      InkWell(
                          onTap: () async => {
                                email =
                                    FirebaseAuth.instance.currentUser?.email,
                                if (email != null)
                                  {
                                    myUser = await MyUser.getUserData(
                                        email!, '$title - $subtitle'),
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => SettingsPage(
                                                settings: widget.settings,
                                                myUser: myUser)))
                                  }
                                else
                                  {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                            content: Center(
                                                child: Text(
                                                    'Problem z uwierzytelnianiem użytkownika'))))
                                  }
                              },
                          child:
                              Image.asset('./images/settings.png', width: 25)),
                    ],
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondColor == const Color(0xFFFFFFFF)
                        ? Colors.black
                        : Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

class TopBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height + 20, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
