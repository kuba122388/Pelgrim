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
  late final Future<void> _loadFuture;
  late final UserProvider _userProvider;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _loadFuture = _userProvider.loadSession();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: 'Lexend'),
      debugShowCheckedModeBanner: false,
      home: FutureBuilder(
        future: _loadFuture,
        builder: (_, __) {
          if (_userProvider.isLoading) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }

          if (_userProvider.isLoggedIn()) {
            return const LoginApproved();
          }

          return const WelcomePage();
        },
      ),
    );
  }
}
