import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/topbar_clipper.dart';
import '../../settings/pages/settings_page.dart';
import '../pages/add_song_page.dart';

class SongsTopBar extends StatelessWidget implements PreferredSizeWidget {
  const SongsTopBar({
    super.key,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final groupInfo = userProvider.groupInfo!;

    final statusBar = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    final Color firstColor = groupInfo.color;
    final Color secondColor = groupInfo.secondColor;
    final bool isLight = secondColor == const Color(0xFFFFFFFF);

    final isAdmin = context.read<UserProvider>().user!.isAdmin;

    return ClipPath(
      clipper: TopBarClipper(),
      child: Container(
        width: screenWidth,
        height: statusBar + 72,
        padding: EdgeInsets.only(top: statusBar + 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [firstColor, secondColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => Scaffold.of(context).openDrawer(),
                    child: Image.asset('./images/burger-bar.png', width: 25),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  SizedBox(
                    width: screenWidth * 0.45,
                    child: Center(
                      child: Text(
                        groupInfo.groupColor,
                        style: TextStyle(
                          color: isLight ? Colors.black : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  if (isAdmin)
                    InkWell(
                      child: Image.asset('./images/plus.png', width: 25),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddSongPage(),
                        ),
                      ),
                    ),
                  InkWell(
                    child: Image.asset('./images/settings.png', width: 25),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const SettingsPage(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Text(
              groupInfo.groupCity,
              style: TextStyle(
                color: isLight ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
