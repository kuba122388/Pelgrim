import 'package:flutter/material.dart';
import 'package:pelgrim/domain/models/my_user.dart';
import 'package:pelgrim/pages/user/all_users/all_users_page.dart';
import 'package:pelgrim/pages/user/announcements/announcements_page.dart';
import 'package:pelgrim/pages/user/contact/contact_page.dart';
import 'package:pelgrim/pages/user/group_duties/group_duties_page.dart';
import 'package:pelgrim/pages/user/help/help_page.dart';
import 'package:pelgrim/pages/user/images_upload/images_upload_page.dart';
import 'package:pelgrim/pages/user/informant/informant_page.dart';
import 'package:pelgrim/pages/user/playing_now/playing_now_page.dart';
import 'package:pelgrim/pages/user/playing_now/playing_now_topbar.dart';
import 'package:pelgrim/pages/user/songs-page/songs-page.dart';
import 'package:pelgrim/pages/user/songs-page/songs-topbar.dart';
import 'package:pelgrim/pages/widgets/burger.dart';
import 'package:pelgrim/pages/widgets/topbar.dart';
import 'package:provider/provider.dart';

import '../../providers/user_provider.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<Widget> _topBars;
  final GlobalKey<SongsPageState> _songsPageKey = GlobalKey<SongsPageState>();

  @override
  void initState() {
    super.initState();

    final isAdmin = context.read<UserProvider>().user!.admin;

    _pages = [
      const AnnouncementsPage(),
      const PlayingNowPage(),
      SongsPage(key: _songsPageKey),
      const GroupDutiesPage(),
      const InformantPage(),
      const ContactPage(),
      const ImagePage(),
      if (isAdmin) const AllUsersPage(),
      const HelpPage()
    ];
    _topBars = [
      const CustomTopBar(),
      const PlayingNowTopbar(),
      SongsTopBar(
        songsPageKey: _songsPageKey,
      ),
      const CustomTopBar(),
      const CustomTopBar(),
      const CustomTopBar(),
      const CustomTopBar(),
      if (isAdmin) const CustomTopBar(),
      const CustomTopBar()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final MyUser? myUser = context.watch<UserProvider>().user;

    return Scaffold(
      appBar: _topBars.isNotEmpty ? _topBars[_selectedIndex] as PreferredSizeWidget : _loading(),
      drawer: BurgerMenu(
          onItemTapped: _onItemTapped, selectedIndex: _selectedIndex, currentUser: myUser!),
      body: _pages.isNotEmpty ? _pages[_selectedIndex] : const CircularProgressIndicator(),
    );
  }

  PreferredSizeWidget _loading() {
    return const PreferredSize(
        preferredSize: Size.fromHeight(80), child: CircularProgressIndicator());
  }
}
