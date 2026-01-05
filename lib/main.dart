import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pelgrim/app.dart';
import 'package:pelgrim/core/config/firebase_options.dart';
import 'package:pelgrim/presentation/providers/announcement_provider.dart';
import 'package:pelgrim/presentation/providers/contact_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import 'core/di/service_locator.dart';

Future<void> main() async {
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

  setupLocator();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<UserProvider>(
          create: (_) => sl<UserProvider>(),
        ),
        ChangeNotifierProvider<ContactProvider>(
          create: (_) => sl<ContactProvider>(),
        ),
        ChangeNotifierProvider<AnnouncementProvider>(
          create: (_) => sl<AnnouncementProvider>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}
