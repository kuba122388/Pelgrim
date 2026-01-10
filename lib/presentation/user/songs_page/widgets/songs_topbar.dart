import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/songs_page/widgets/base_songs_topbar.dart';
import 'package:provider/provider.dart';

import '../../settings/settings_page.dart';
import '../pages/add_song_page.dart';

class SongsTopBar extends StatelessWidget implements PreferredSizeWidget {
  const SongsTopBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final isAdmin = context.read<UserProvider>().user!.isAdmin;

    return BaseSongsTopBar(
      leading: InkWell(
        onTap: () => Scaffold.of(context).openDrawer(),
        child: Image.asset('./images/burger-bar.png', width: 25),
      ),
      actions: [
        if (isAdmin)
          IconButton(
            icon: Image.asset('./images/plus.png', width: 25),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => const AddSongPage(),
              ),
            ),
          ),
        IconButton(
          icon: Image.asset('./images/settings.png', width: 25),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SettingsPage(),
            ),
          ),
        ),
      ],
    );
  }
}
