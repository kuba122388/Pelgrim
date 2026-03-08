import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/settings/pages/settings_page.dart';
import 'package:provider/provider.dart';

import '../../../widgets/topbar_clipper.dart';

class PlayingNowTopbar extends StatefulWidget implements PreferredSizeWidget {
  const PlayingNowTopbar({super.key});

  @override
  State<PlayingNowTopbar> createState() => _PlayingNowTopbarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _PlayingNowTopbarState extends State<PlayingNowTopbar> {
  late User? myUser;

  @override
  Widget build(BuildContext context) {
    final Group groupInfo = context.read<UserProvider>().groupInfo!;

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
                      onTap: () => {Scaffold.of(context).openDrawer()},
                      child: Image.asset('./images/burger-bar.png', width: 25),
                    ),
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
                        ),
                      ),
                    ),
                    const SizedBox(width: 30),
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
      ),
    );
  }
}
