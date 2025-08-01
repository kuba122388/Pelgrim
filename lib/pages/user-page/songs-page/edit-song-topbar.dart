import 'package:flutter/material.dart';
import 'package:pelgrim/models/MyUser.dart';

class EditSongTopbar extends StatefulWidget implements PreferredSizeWidget {
  final Map<String, dynamic> settings;
  final VoidCallback onAccept;

  const EditSongTopbar({super.key, required this.settings, required this.onAccept});

  @override
  State<EditSongTopbar> createState() => _EditSongTopbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _EditSongTopbarState extends State<EditSongTopbar> {
  late MyUser? myUser;

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
                      const SizedBox(width: 10),
                      InkWell(
                        onTap: () => {Navigator.of(context).pop()},
                        child: Image.asset('./images/delete.png', width: 35),
                      ),
                      SizedBox(
                          width: screenWidth * 0.42,
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
                          onTap: () => {
                            widget.onAccept()
                          },
                          child: Image.asset('./images/accept.png',
                              width: 35)),
                      const SizedBox(
                          width: 10
                      ),
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
