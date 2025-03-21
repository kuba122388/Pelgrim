import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/dbfeatures/User.dart';
import 'package:pelgrim/pages/user-page/announcements-page/announcements-page.dart';
import 'package:pelgrim/pages/user-page/contact-page/contact-page.dart';
import 'package:pelgrim/pages/user-page/help-page/help-page.dart';
import 'package:pelgrim/pages/user-page/images-upload-page/images-page.dart';
import 'package:pelgrim/pages/user-page/informant-page/informant-page.dart';
import 'package:pelgrim/pages/user-page/playing-now-page/playing-now-page.dart';
import 'package:pelgrim/pages/user-page/playing-now-page/playing-now-topbar.dart';
import 'package:pelgrim/pages/user-page/songs-page/songs-page.dart';
import 'package:pelgrim/pages/user-page/songs-page/songs-topbar.dart';
import 'package:pelgrim/pages/widgets/burger.dart';
import 'package:pelgrim/pages/widgets/topbar.dart';

class MainPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final MyUser myUser;

  const MainPage({super.key, required this.settings, required this.myUser});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  User? user = FirebaseAuth.instance.currentUser;
  bool important = false;
  int _selectedIndex = 0;
  late List<Widget> _pages;
  late List<Widget> _topbars;
  final GlobalKey<SongsPageState> _songsPageKey = GlobalKey<SongsPageState>();

  @override
  void initState() {
    super.initState();
    print(widget.myUser.firstName);
    _pages = [
      AnnouncementsPage(settings: widget.settings, myUser: widget.myUser),
      PlayingNowPage(settings: widget.settings),
      SongsPage(
          group:
              '${widget.settings['groupColor']} - ${widget.settings['groupCity']}',
          settings: widget.settings,
          admin: widget.myUser.admin,
          key: _songsPageKey),
      InformantPage(settings: widget.settings),
      ContactPage(settings: widget.settings),
      ImagePage(settings: widget.settings),
      HelpPage(settings: widget.settings)
    ];
    _topbars = [
      CustomTopBar(settings: widget.settings, myUser: widget.myUser),
      PlayingNowTopbar(settings: widget.settings),
      SongsTopBar(
        settings: widget.settings,
        songsPageKey: _songsPageKey,
        myUser: widget.myUser,
      ),
      CustomTopBar(settings: widget.settings, myUser: widget.myUser),
      CustomTopBar(settings: widget.settings, myUser: widget.myUser),
      CustomTopBar(settings: widget.settings, myUser: widget.myUser),
      CustomTopBar(settings: widget.settings, myUser: widget.myUser),
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
    return Scaffold(
      appBar: _topbars.isNotEmpty
          ? _topbars[_selectedIndex] as PreferredSizeWidget
          : _loading(),
      drawer: BurgerMenu(
          onItemTapped: _onItemTapped, selectedIndex: _selectedIndex),
      body: _pages.isNotEmpty
          ? _pages[_selectedIndex]
          : const CircularProgressIndicator(),
    );
  }

  PreferredSizeWidget _loading() {
    return const PreferredSize(
        preferredSize: Size.fromHeight(80), child: CircularProgressIndicator());
  }
}
