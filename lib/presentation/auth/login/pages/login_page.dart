import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/core/const/app_sizes.dart';
import 'package:pelgrim/core/utils/app_snack_bars.dart';
import 'package:pelgrim/presentation/auth/forgot_password/pages/forgot_password_page.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/widgets/custom_navigate_button.dart';
import 'package:pelgrim/presentation/widgets/welcome_background.dart';
import 'package:provider/provider.dart';

import '../../register/pages/register_user_page.dart';
import '../widgets/labeled_text_field.dart';
import 'login_approved.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const ForgotPasswordPage(),
                                      ),
                                    );
                                  },
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
                                    FocusScope.of(context).unfocus();
                                    _signIn();
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
                                            const RegisterUserPage(),
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
                                        fontWeight: FontWeight.bold,
                                      ),
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

  Future<void> _signIn() async {
    try {
      AppSnackBars.info(context, "Logowanie...", duration: 1);

      await context.read<UserProvider>().signIn(
            email: _controllerEmail.text,
            password: _controllerPassword.text,
          );

      await Future.delayed(const Duration(milliseconds: 1400));

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginApproved(),
        ),
        (route) => false,
      );
    } catch (e) {
      AppSnackBars.error(context, "Nieprawidłowy E-mail lub hasło");
    }
  }
}
