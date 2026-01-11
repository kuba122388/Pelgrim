import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pelgrim/app.dart';
import 'package:pelgrim/core/config/firebase_options.dart';
import 'package:pelgrim/core/storage/hive_setup.dart';
import 'package:pelgrim/presentation/providers/contact_provider.dart';
import 'package:pelgrim/presentation/providers/duty_provider.dart';
import 'package:pelgrim/presentation/providers/song_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'core/di/service_locator.dart';

Future<void> main() async {
  Future<void> migrateToNewStructure() async {
    final firestore = FirebaseFirestore.instance;

    final oldGroups = await firestore.collection('Pelgrim Groups').get();

    for (var groupDoc in oldGroups.docs) {
      String groupId = groupDoc.id;
      if (!(groupDoc.id == "Niebieska - Brzeźniowsko - Złoczewska")) continue;

      groupId = "niebieska_brzezniowsko_zloczewska";

      final oldSongs = await groupDoc.reference.collection('Announcements').get();
      for (var songDoc in oldSongs.docs) {
        final songData = songDoc.data();
        await firestore
            .collection('pelgrim_groups')
            .doc(groupId)
            .collection('announcements')
            .doc(songDoc.id)
            .set({
          'id': songDoc.id,
          'title': songData['Title'],
          'lyrics': songData['Lyrics'],
        });
      }
    }
  }

  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseAppCheck.instance.activate(
    androidProvider: kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
    webProvider: ReCaptchaV3Provider('6Lc3WJorAAAAANDI1jyxM-gm95pJpVDYwfwxmZB4'),
  );

  // await migrateToNewStructure();

  await HiveSetup.init();

  setupLocator();

  final userProvider = sl<UserProvider>();

  await userProvider.loadSession();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>.value(
          value: userProvider,
        ),
        ChangeNotifierProvider<ContactProvider>(
          create: (_) => sl<ContactProvider>(),
        ),
        ChangeNotifierProvider<DutyProvider>(
          create: (_) => sl<DutyProvider>(),
        ),
        ChangeNotifierProvider<SongProvider>(
          create: (_) => sl<SongProvider>(),
        )
      ],
      child: const MyApp(),
    ),
  );
}
