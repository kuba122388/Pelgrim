import 'package:flutter/material.dart';
import 'package:pelgrim/auth.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/models/MyUser.dart';
import 'package:pelgrim/main.dart';
import 'package:pelgrim/pages/user-page/settings-page/special-topbar.dart';

class SettingsPage extends StatefulWidget {
  final Map<String, dynamic> settings;
  final MyUser? myUser;

  const SettingsPage({super.key, required this.settings, required this.myUser});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        appBar: SpecialTopBar(myUser: widget.myUser, settings: widget.settings),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(top: 30, bottom: 30),
                  padding: const EdgeInsets.all(25),
                  width: screenWidth * 0.8,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.25),
                        blurRadius: 4,
                        offset: const Offset(0, 0),
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _dataField('Imie', widget.myUser?.firstName, context),
                      _dataField('Nazwisko', widget.myUser?.lastName, context),
                      _dataField('E-mail', widget.myUser?.email, context),
                      _dataField('Nr tel', widget.myUser?.phone, context),
                      _dataField(
                        'Status',
                        widget.myUser?.admin == false
                            ? 'Pielgrzym'
                            : 'Pielgrzym moderator',
                        context,
                      ),
                      _dataFieldLast('Pielgrzymka',
                          widget.settings['groupColor'], context),
                      Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(bottom: 15),
                            child: Text(widget.settings['groupCity'],
                                style: const TextStyle(
                                  color: LIST_TILE_INACTIVE_COLOR,
                                  fontSize: 18,
                                )),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () => _signOut(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 40),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.25),
                          offset: const Offset(0, 0),
                          blurRadius: 4,
                          spreadRadius: 0,
                        ),
                      ],
                    ),
                    child: const Text(
                      'Wyloguj',
                      style: TextStyle(
                        color: Colors.black,
                        fontFamily: 'Lexend',
                        fontSize: 18,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget _dataField(title, text, context) {
    return Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 15),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Lexend'),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              color: LIST_TILE_INACTIVE_COLOR,
              fontSize: 18,
            ),
          ),
        ]));
  }

  Widget _dataFieldLast(title, text, context) {
    return Container(
        width: double.infinity,
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: Colors.black))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              title,
              style: const TextStyle(fontSize: 18, fontFamily: 'Lexend'),
            ),
          ),
          Text(
            text,
            style: const TextStyle(
              color: LIST_TILE_INACTIVE_COLOR,
              fontSize: 18,
            ),
          )
        ]));
  }

  Future<void> _signOut(BuildContext context) async {
    await Auth().signOut();
    Future.delayed(const Duration(milliseconds: 1500));
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const CustomBackground()),
      (Route<dynamic> route) => false,
    );
  }
}
