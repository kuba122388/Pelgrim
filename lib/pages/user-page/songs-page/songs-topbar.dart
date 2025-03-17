import 'package:flutter/material.dart';
import 'package:pelgrim/dbfeatures/User.dart';
import 'package:pelgrim/pages/user-page/settings-page/settings-page.dart';
import 'package:pelgrim/pages/user-page/songs-page/add-song-page.dart';
import 'package:pelgrim/pages/user-page/songs-page/songs-page.dart';

class SongsTopBar extends StatefulWidget implements PreferredSizeWidget {
  final Map<String, dynamic> settings;
  final GlobalKey<SongsPageState> songsPageKey;
  final MyUser myUser;

  const SongsTopBar(
      {super.key,
      required this.settings,
      required this.songsPageKey,
      required this.myUser});

  @override
  State<SongsTopBar> createState() => _SongsTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SongsTopBarState extends State<SongsTopBar> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;

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
                          onTap: () => {
                                Scaffold.of(context).openDrawer(),
                              },
                          child: Image.asset('./images/burger-bar.png',
                              width: 25)),
                      Visibility(
                          visible: widget.myUser.admin,
                          child: const SizedBox(
                            width: 25,
                          )),
                      SizedBox(
                          width: screenWidth * 0.4,
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
                      InkWell(
                        onTap: () async {
                          bool? songAdded = await Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      AddSongPage(settings: widget.settings)));
                          if (songAdded == true) {
                            await Future.delayed(
                                const Duration(milliseconds: 250), () {
                              setState(() {
                                widget.songsPageKey.currentState?.loadsongs();
                              });
                            });
                          }
                        },
                        child: Visibility(
                            visible: widget.myUser.admin,
                            child: Image.asset('./images/plus.png', width: 25)),
                      ),
                      InkWell(
                          onTap: () async => {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => SettingsPage(
                                            settings: widget.settings,
                                            myUser: widget.myUser)))
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
