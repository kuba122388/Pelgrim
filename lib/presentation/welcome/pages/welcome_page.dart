import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/login/pages/login_page.dart';
import 'package:pelgrim/presentation/widgets/custom_navigate_button.dart';
import 'package:pelgrim/presentation/widgets/welcome_background.dart';

import '../../../core/const/app_sizes.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            const WelcomeBackground(
              elevated: false,
              heroTag: "Welcome",
            ),
            Positioned(
              width: screenWidth,
              top: screenHeight * AppSizes.buttonBottomFactor,
              child: Center(
                child: Hero(
                  tag: "Navigate_button",
                  child: CustomNavigateButton(
                    text: "Zaczynajmy",
                    onPressed: () => Navigator.push(
                      context,
                      PageRouteBuilder(
                        transitionDuration: const Duration(milliseconds: 400),
                        reverseTransitionDuration: const Duration(milliseconds: 400),
                        pageBuilder: (context, animation, secondaryAnimation) => const LoginPage(),
                        transitionsBuilder: (context, animation, secondaryAnimation, child) {
                          return FadeTransition(opacity: animation, child: child);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
