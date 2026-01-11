import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/login/pages/login_approved.dart';
import 'package:pelgrim/presentation/welcome/pages/welcome_page.dart';
import 'package:provider/provider.dart';

import 'presentation/providers/user_provider.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = context.watch<UserProvider>();

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Lexend'),
      debugShowCheckedModeBanner: false,
      home: userProvider.isLoggedIn() ? const LoginApproved() : const WelcomePage(),
    );
  }
}
