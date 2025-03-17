import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/dbfeatures/User.dart';
import 'package:pelgrim/pages/user-page/settings-page/settings-page.dart';

class PlayingNowTopbar extends StatefulWidget implements PreferredSizeWidget {
  final Map<String, dynamic> settings;

  const PlayingNowTopbar({super.key, required this.settings});

  @override
  State<PlayingNowTopbar> createState() => _PlayingNowTopbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _PlayingNowTopbarState extends State<PlayingNowTopbar> {
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
                          onTap: () => {Scaffold.of(context).openDrawer()},
                          child: Image.asset('./images/burger-bar.png',
                              width: 25)),
                      const SizedBox(width: 30),
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
                      const SizedBox(width: 30),
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
                                                    'Problem z uwierzytelnieniem użytkownika'))))
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
