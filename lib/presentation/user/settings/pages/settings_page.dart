import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../welcome/pages/welcome_page.dart';
import '../../../widgets/special_topbar.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final User myUser = context.read<UserProvider>().user!;
    final Group groupInfo = context.read<UserProvider>().groupInfo!;

    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: const SpecialTopBar(),
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
                      color: Colors.black.withValues(alpha: 0.25),
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
                    _dataField('Imie', myUser.firstName, context),
                    _dataField('Nazwisko', myUser.lastName, context),
                    _dataField('E-mail', myUser.email, context),
                    _dataField('Nr tel', myUser.phone, context),
                    _dataField(
                      'Status',
                      myUser.isAdmin == false ? 'Pielgrzym' : 'Pielgrzym moderator',
                      context,
                    ),
                    _dataFieldLast('Pielgrzymka', groupInfo.groupColor, context),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 15),
                          child: Text(
                            groupInfo.groupCity,
                            style: const TextStyle(
                              color: LIST_TILE_INACTIVE_COLOR,
                              fontSize: 18,
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
              GestureDetector(
                onTap: () async => await _signOut(context),
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 40),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(25),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.25),
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
      ),
    );
  }

  Widget _dataField(title, text, context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 15),
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  Widget _dataFieldLast(title, text, context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Colors.black))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
        ],
      ),
    );
  }

  Future<void> _signOut(BuildContext context) async {
    final UserProvider userProvider = context.read<UserProvider>();

    await userProvider.signOut();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const WelcomePage()),
      (Route<dynamic> route) => false,
    );
  }
}
