import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/consts.dart';
import 'package:pelgrim/pages/login/login_approved.dart';
import 'package:pelgrim/pages/login/widgets/labeled_text_field.dart';
import 'package:pelgrim/pages/register/register_user.dart';
import 'package:pelgrim/pages/widgets/custom_navigate_button.dart';
import 'package:pelgrim/pages/widgets/welcome_background.dart';

import '../../core/const/app_sizes.dart';
import '../../services/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenStatusBarHeight = MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: SizedBox(
              width: screenWidth,
              height: screenHeight - screenStatusBarHeight,
              child: Stack(
                children: [
                  const WelcomeBackground(
                    elevated: true,
                    heroTag: "Welcome",
                  ),
                  Positioned.fill(
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * AppSizes.loginPositionFactor),
                        SizedBox(
                          width: screenWidth * LOGIN_CONTAINER_SIZE,
                          child: Column(
                            children: [
                              LabeledTextField(
                                text: "E-mail",
                                controller: _controllerEmail,
                                action: TextInputAction.next,
                              ),
                              LabeledTextField(
                                text: "Hasło",
                                controller: _controllerPassword,
                                hide: true,
                                action: TextInputAction.done,
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: InkWell(
                                  onTap: () {}, // TODO
                                  child: const Text(
                                    'Zapomniałem hasła',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      color: LOGIN_ALTERNATE_OPTION,
                                      decoration: TextDecoration.underline,
                                      decorationColor: LOGIN_ALTERNATE_OPTION,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Hero(
                                tag: "Navigate_button",
                                child: CustomNavigateButton(
                                  text: "Zaloguj",
                                  onPressed: () {
                                    signInWithEmailAndPassword();
                                    FocusScope.of(context).unfocus();
                                  },
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    "Nie posiadasz konta? ",
                                  ),
                                  InkWell(
                                    onTap: () => Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                        pageBuilder: (context, animation, secondaryAnimation) =>
                                            const RegisterUser(),
                                        transitionsBuilder:
                                            (context, animation, secondaryAnimation, child) {
                                          return FadeTransition(opacity: animation, child: child);
                                        },
                                      ),
                                    ),
                                    child: const Text(
                                      'Kliknij tutaj!',
                                      style: TextStyle(
                                          color: LOGIN_ALTERNATE_OPTION,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Logowanie...", textAlign: TextAlign.center),
        duration: Duration(milliseconds: 1500),
      ),
    );

    try {
      await _authService.signIn(_controllerEmail.text, _controllerPassword.text);

      await Future.delayed(const Duration(milliseconds: 1400));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginApproved(
              email: _controllerEmail.text,
            ),
          ),
          (route) => false);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'network-request-failed') {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => LoginApproved(
                email: _controllerEmail.text,
              ),
            ),
            (route) => false);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          behavior: SnackBarBehavior.floating,
          content: Text("Nieprawidłowy E-mail lub hasło", textAlign: TextAlign.center),
          duration: Duration(milliseconds: 2000),
        ),
      );
    }
  }
}
