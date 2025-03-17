import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/pages/login-page/login-approved.dart';
import 'package:pelgrim/pages/login-page/login-page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Firebase.initializeApp();

  await FirebaseAppCheck.instance.activate(
    androidProvider: AndroidProvider.debug,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String? email = user?.email ?? '';

    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Lexend',
        ),
        debugShowCheckedModeBanner: false,
        home: user != null
            ? LoginApproved(email: email) : const CustomBackground()
            );
  }
}

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
        body: SafeArea(
            child: Stack(
      children: [
        Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF31768A), Color(0xFF88CBDF)],
              stops: [0.0, 0.8],
            ),
          ),
        ),
        Positioned.fill(
          child: CustomPaint(
            painter: WavePainter(),
          ),
        ),
        const Picture(img: 'mountains.png', top: 0.18, left: 0, width: 0),
        const Picture(
            img: 'second-bush.png', top: 0.44, left: 0.66, width: 0.3),
        const Picture(img: 'first-bush.png', top: 0.43, left: 0, width: 0.6),
        Picture(img: 'path.png', top: screenHeight < 800 ? 0.42 : 0.4, left: 0, width: 0),
        const Picture(img: 'wanderer.png', top: 0.36, left: 0.1, width: 0.25),
        Positioned(
          width: screenWidth,
          top: screenHeight * (0.12 - LOGIN_PAGE_MOVE + 0.04),
          child: const Center(
            child: Text(
              'Witaj pielgrzymie!',
              style: TextStyle(
                  fontFamily: 'Asap',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 36,
                  shadows: [
                    Shadow(
                        color: LOGIN_SHADOW_TEXT,
                        offset: LOGIN_SHADOW_OFFSET,
                        blurRadius: 10)
                  ]),
            ),
          ),
        ),
        Positioned(
          width: screenWidth,
          top: screenHeight * 0.87,
          child: Center(
            child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize:
                      WidgetStateProperty.all(Size(screenWidth * 0.75, 50)),
                  elevation: const WidgetStatePropertyAll(5.0),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: () => Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const LoginPage())),
                child: Stack(
                  children: [
                    Container(
                      alignment: Alignment.centerRight,
                      child: Image.asset(
                        'images/arrow-right.png',
                        height: 20,
                      ),
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Zaczynajmy',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Lexend',
                        ),
                      ),
                    ),
                  ],
                )),
          ),
        ),
      ],
    )));
  }
}

class Picture extends StatelessWidget {
  final String img;
  final double top;
  final double left;
  final double width;

  const Picture({
    super.key,
    required this.img,
    required this.top,
    required this.left,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Positioned(
      top: screenHeight * top,
      left: screenWidth * left,
      child: Image.asset(
        'images/$img',
        width: width == 0 ? null : screenWidth * width,
      ),
    );
  }
}

class WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..shader = const LinearGradient(
        colors: [LOGIN_BG_PRIMARY_COLOR, LOGIN_BG_SECONDARY_COLOR],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, size.height * (BACKGROUND_WAVES_IMAGE + 0.05))
      ..quadraticBezierTo(
          size.width * 0.25,
          size.height * (BACKGROUND_WAVES_IMAGE + 0.05),
          size.width * 0.5,
          size.height * BACKGROUND_WAVES_IMAGE)
      ..quadraticBezierTo(
          size.width * 0.75,
          size.height * (BACKGROUND_WAVES_IMAGE - 0.05),
          size.width,
          size.height * (BACKGROUND_WAVES_IMAGE - 0.05))
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
