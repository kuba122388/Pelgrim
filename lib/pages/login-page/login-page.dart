import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/auth.dart';
import 'package:pelgrim/core/const/consts.dart';
import 'package:pelgrim/pages/login-page/login-approved.dart';
import 'package:pelgrim/pages/login-page/widgets/labeled_text_field.dart';
import 'package:pelgrim/pages/register-page/register-user.dart';
import 'package:pelgrim/pages/widgets/welcome_background.dart';

import '../../core/const/app_sizes.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

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
                  const WelcomeBackground(elevated: true),
                  Positioned.fill(
                    child: SafeArea(
                      child: SingleChildScrollView(
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
                                        'Nie masz konta?',
                                        style: TextStyle(
                                          fontSize: 15.0,
                                          color: LOGIN_ALTERNATE_OPTION,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 40),
                                  ElevatedButton(
                                    style: ButtonStyle(
                                      fixedSize: WidgetStateProperty.all(
                                          Size(screenWidth * LOGIN_CONTAINER_SIZE, 50)),
                                      backgroundColor: const WidgetStatePropertyAll(Colors.white),
                                      elevation: const WidgetStatePropertyAll(5.0),
                                    ),
                                    onPressed: () {
                                      signInWithEmailAndPassword();
                                      FocusScope.of(context).unfocus();
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                        ),
                                        const Expanded(
                                          child: Center(
                                            child: Text(
                                              'Zaloguj',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontFamily: 'Lexend',
                                              ),
                                            ),
                                          ),
                                        ),
                                        Image.asset(
                                          'images/arrow-right.png',
                                          width: 25,
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> signInWithEmailAndPassword() async {
    try {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Logowanie...", textAlign: TextAlign.center),
        duration: Duration(milliseconds: 1500),
      ));

      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text, password: _controllerPassword.text);

      await Future.delayed(const Duration(milliseconds: 1400));

      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => LoginApproved(
                    email: _controllerEmail.text,
                  )),
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
