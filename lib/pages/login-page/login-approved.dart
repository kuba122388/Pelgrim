import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/auth.dart';
import 'package:pelgrim/models/MyUser.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/pages/login-page/login-page.dart';
import 'package:pelgrim/pages/user-page/main-page.dart';

class LoginApproved extends StatefulWidget {
  final String email;

  const LoginApproved({super.key, required this.email});

  @override
  State<LoginApproved> createState() => _LoginApprovedState();
}

class _LoginApprovedState extends State<LoginApproved> {
  late Map<String, dynamic> settings;
  late MyUser? myUser;
  late Future<void> _futureLoadData;

  Future<void> loadGroupData() async {
    String group = await getUserGroup(widget.email);
    settings = await getGroupSettings(group);
    myUser = await getUserInfo(group);
  }

  Future<String> getUserGroup(String email) async {
    QuerySnapshot groupsSnapshot =
        await FirebaseFirestore.instance.collection('Pelgrim Groups').get();

    for (QueryDocumentSnapshot groupDoc in groupsSnapshot.docs) {
      DocumentReference userDocRef =
          groupDoc.reference.collection('Users').doc(email);
      DocumentSnapshot userDoc = await userDocRef.get();
      if (userDoc.exists) {
        return groupDoc.id;
      }
    }

    throw Exception("User group not found");
  }

  Future<Map<String, dynamic>> getGroupSettings(String groupID) async {
    QuerySnapshot settings = await FirebaseFirestore.instance
        .collection('Pelgrim Groups')
        .doc(groupID)
        .collection('Settings')
        .get();

    if (settings.docs.isNotEmpty) {
      DocumentSnapshot docSnap = settings.docs.first;
      return docSnap.data() as Map<String, dynamic>;
    } else {
      throw Exception('Missing Settings in $groupID group');
    }
  }

  Future<MyUser> getUserInfo(String groupID) async {
    MyUser? myUser = await MyUser.getUserData(widget.email, groupID);
    if (myUser != null) {
      return myUser;
    }
    throw Exception('Problem with getting user info');
  }

  @override
  void initState() {
    super.initState();
    _futureLoadData = loadGroupData();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;
    return Scaffold(
        resizeToAvoidBottomInset: true,
        body: SafeArea(
            child: Stack(
          children: [
            FutureBuilder(
              future: _futureLoadData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    Auth().signOut();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Center(
                          child: Text('Wystąpił nieoczekiwany błąd'),
                        )));
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                      (route) => false,
                    );
                  }
                  Future.delayed(const Duration(milliseconds: 500), () {
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(
                          settings: settings,
                          myUser: myUser!,
                        ),
                      ),
                      (route) => false,
                    );
                  });
                }
                return const SizedBox
                    .shrink(); // Zwrot pustego widgetu w trakcie ładowania
              },
            ),
            Container(
              decoration: const BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                    APPROVED_GRADIENT_TOP,
                    APPROVED_GRADIENT_BOTTOM
                  ])),
              child: Stack(
                children: [
                  imgAdjust('first-bush.png', screenHeight * 0.22, 0,
                      screenWidth * 0.5),
                  imgAdjustWithRotation('first-bush.png', screenHeight * 0.425,
                      screenWidth * 0.5, screenWidth * 0.4, 7),
                  imgAdjust('long-path.png', 0, 0, screenWidth),
                  imgAdjust('second-bush.png', -screenHeight * 0.02,
                      screenWidth * 0.45, screenWidth * 0.4),
                  imgAdjustWithRotation('third-bush.png', screenHeight * 0.36,
                      screenWidth * 0.1, screenWidth * 0.5, 5),
                  imgAdjust(
                      'cloud.png', screenHeight * 0.64, 0, screenWidth * 0.4),
                  imgAdjust('trees.png', screenHeight * 0.595,
                      screenWidth * 0.26, screenWidth * 0.45),
                  imgAdjust('bird1.png', screenHeight * 0.9, screenWidth * 0.32,
                      screenWidth * 0.15),
                  imgAdjust('bird2.png', screenHeight * 0.82,
                      screenWidth * 0.45, screenWidth * 0.2),
                  imgAdjust('bird3.png', screenHeight * 0.85,
                      screenWidth * 0.60, screenWidth * 0.3),
                  imgAdjust('bird4.png', screenHeight * 0.79,
                      screenWidth * 0.75, screenWidth * 0.2),
                  Positioned(
                      top: 0,
                      left: 0,
                      child: Container(
                          height: screenHeight * 0.4,
                          alignment: Alignment.center,
                          width: screenWidth,
                          child: Text(
                            'Zalogowano',
                            style: TextStyle(
                                fontFamily: 'Lexend',
                                color: Colors.white,
                                fontSize: screenWidth * 0.11,
                                shadows: [
                                  Shadow(
                                      color: Colors.black.withOpacity(0.25),
                                      offset: const Offset(0, 4),
                                      blurRadius: 4)
                                ]),
                          ))),
                ],
              ),
            )
          ],
        )));
  }

  imgAdjust(image, double bottom, double left, double width) {
    return Positioned(
        bottom: bottom,
        left: left,
        width: width == 1 ? null : width,
        child: Image.asset('./images/$image'));
  }

  imgAdjustWithRotation(
      image, double bottom, double left, double width, double angle) {
    return Positioned(
        bottom: bottom,
        left: left,
        width: width == 1 ? null : width,
        child: Transform.rotate(
            angle: (pi / 180) * angle, child: Image.asset('./images/$image')));
  }
}
