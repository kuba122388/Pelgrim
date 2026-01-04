import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/song.dart';
import 'package:pelgrim/presentation/user/settings/settings_page.dart';
import 'package:pelgrim/presentation/user/songs-page/edit-song-page.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

class SongsDetailTopbar extends StatefulWidget implements PreferredSizeWidget {
  final Song song;
  final VoidCallback edit;

  const SongsDetailTopbar({super.key, required this.song, required this.edit});

  @override
  State<SongsDetailTopbar> createState() => _SongsDetailTopbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _SongsDetailTopbarState extends State<SongsDetailTopbar> {
  @override
  Widget build(BuildContext context) {
    final Group groupInfo = context.read<UserProvider>().groupInfo!;
    final bool isAdmin = context.read<UserProvider>().user!.isAdmin;

    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;

    String title = groupInfo.groupColor;
    String subtitle = groupInfo.groupCity;
    Color firstColor = groupInfo.color;
    Color secondColor = groupInfo.secondColor;

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
                          child: Image.asset('./images/back-arrow-2.png', width: 25)),
                      Visibility(
                          visible: isAdmin,
                          child: InkWell(
                            onTap: () async {
                              bool? edited = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditSongPage(
                                    song: widget.song,
                                  ),
                                ),
                              );
                              if (edited == true) {
                                widget.edit();
                              }
                            },
                            child: Image.asset('./images/edit.png', width: 25),
                          )),
                      Container(
                        constraints: BoxConstraints(minWidth: screenWidth * 0.35),
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
                          ),
                        ),
                      ),
                      Visibility(
                          visible: isAdmin,
                          child: InkWell(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: const Text('Potwierdzenie'),
                                    content: const Text('Czy na pewno chcesz usunąć tę piosenkę?'),
                                    actions: [
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            padding: WidgetStateProperty.all(
                                                const EdgeInsets.symmetric(horizontal: 0)),
                                            elevation: WidgetStateProperty.all(2.0),
                                          ),
                                          child: const Text('Anuluj',
                                              style: TextStyle(color: FONT_BLACK_COLOR)),
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        width: 100,
                                        child: ElevatedButton(
                                          style: ButtonStyle(
                                            elevation: WidgetStateProperty.all(2.0),
                                            backgroundColor: WidgetStateProperty.all(Colors.red),
                                          ),
                                          child: const Text(
                                            'Usuń',
                                            style: TextStyle(color: Colors.white),
                                          ),
                                          onPressed: () async {
                                            await widget.song.deleteSong('$title - $subtitle');
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
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const SettingsPage(),
                            ),
                          ),
                        },
                        child: Image.asset('./images/settings.png', width: 25),
                      ),
                    ],
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    color: secondColor == const Color(0xFFFFFFFF) ? Colors.black : Colors.white,
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
    path.quadraticBezierTo(size.width / 2, size.height + 20, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
