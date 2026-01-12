import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/all_users/all_users_page.dart';
import 'package:pelgrim/presentation/user/announcements/announcements_page.dart';
import 'package:pelgrim/presentation/user/contact/contact_page.dart';
import 'package:pelgrim/presentation/user/help/help_page.dart';
import 'package:pelgrim/presentation/user/images_upload/images_upload_page.dart';
import 'package:pelgrim/presentation/user/informant/informant_page.dart';
import 'package:pelgrim/presentation/user/playing_now/playing_now_page.dart';
import 'package:pelgrim/presentation/user/playing_now/playing_now_topbar.dart';
import 'package:pelgrim/presentation/user/songs_page/pages/songs_page.dart';
import 'package:pelgrim/presentation/user/songs_page/widgets/songs_topbar.dart';
import 'package:pelgrim/presentation/widgets/burger.dart';
import 'package:pelgrim/presentation/widgets/custom_topbar.dart';
import 'package:provider/provider.dart';

import 'duties/duties_page.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final isAdmin = user?.isAdmin ?? false;

    final pages = [
      const AnnouncementsPage(),
      const PlayingNowPage(),
      const SongsPage(),
      const GroupDutiesPage(),
      const InformantPage(),
      const ContactPage(),
      const ImagePage(),
      if (isAdmin) const AllUsersPage(),
      const HelpPage(),
    ];

    final topBars = [
      const CustomTopBar(),
      const PlayingNowTopbar(),
      const SongsTopBar(),
      const CustomTopBar(),
      const CustomTopBar(),
      const CustomTopBar(),
      const CustomTopBar(),
      if (isAdmin) const CustomTopBar(),
      const CustomTopBar(),
    ];

    if (_selectedIndex >= pages.length) {
      _selectedIndex = 0;
    }

    return Scaffold(
      appBar: topBars[_selectedIndex] as PreferredSizeWidget,
      drawer: BurgerMenu(
        onItemTapped: _onItemTapped,
        selectedIndex: _selectedIndex,
        currentUser: user!,
      ),
      body: pages[_selectedIndex],
    );
  }
}
