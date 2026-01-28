import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/core/errors/no_internet_exception.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/main_page.dart';
import 'package:provider/provider.dart';

import '../../../../core/utils/app_snack_bars.dart';
import '../../../welcome/pages/welcome_page.dart';
import '../widgets/background_image.dart';

class LoginApproved extends StatefulWidget {
  const LoginApproved({super.key});

  @override
  State<LoginApproved> createState() => _LoginApprovedState();
}

class _LoginApprovedState extends State<LoginApproved> {
  @override
  void initState() {
    super.initState();
    _verifyAndNavigate();
  }

  Future<void> _verifyAndNavigate() async {
    final userProvider = context.read<UserProvider>();

    await Future.delayed(const Duration(milliseconds: 1200));

    try {
      var connectivityResult = await (Connectivity().checkConnectivity());
      if (connectivityResult.contains(ConnectivityResult.none)) {
        throw NoInternetException();
      }

      final uid = userProvider.authenticatedUserId;

      if (uid != null) {
        await userProvider.syncUserSessionWithRemote();
      } else {
        await userProvider.signOut();
        _goToWelcome();
        return;
      }
    } on NoInternetException catch (e) {
      if (!mounted) return;
      AppSnackBars.error(context, "Tryb offline: $e");
      _goToMain();
    } catch (e) {
      if (!mounted) return;
      AppSnackBars.error(context, "Wystąpił nieoczekiwany problem.");
      _goToMain();
    }

    if (!mounted) return;
    _goToMain();
  }

  void _goToMain() => Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => const MainPage()), (r) => false);

  void _goToWelcome() => Navigator.pushAndRemoveUntil(
      context, MaterialPageRoute(builder: (_) => const WelcomePage()), (r) => false);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: BackgroundImage());
  }
}
