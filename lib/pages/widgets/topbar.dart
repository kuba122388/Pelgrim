import 'package:flutter/material.dart';
import 'package:pelgrim/domain/models/group_info.dart';
import 'package:pelgrim/pages/user/settings/settings_page.dart';
import 'package:pelgrim/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CustomTopBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomTopBar({super.key});

  @override
  State<CustomTopBar> createState() => _CustomTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _CustomTopBarState extends State<CustomTopBar> {
  @override
  Widget build(BuildContext context) {
    final GroupInfo groupInfo = context.read<UserProvider>().groupInfo!;

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
                        onTap: () => {
                              Scaffold.of(context).openDrawer(),
                            },
                        child: Image.asset('./images/burger-bar.png', width: 25)),
                    SizedBox(
                      width: screenWidth * 0.5,
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
                    InkWell(
                        onTap: () => {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const SettingsPage(),
                                ),
                              ),
                            },
                        child: Image.asset('./images/settings.png', width: 25)),
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
      ),
    );
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
