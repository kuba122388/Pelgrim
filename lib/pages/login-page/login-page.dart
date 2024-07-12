import 'dart:ui';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/pages/consts.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          fontFamily: 'Asap',
        ),
        debugShowCheckedModeBanner: false,
        home: const CustomBackground());
  }
}

class CustomBackground extends StatelessWidget {
  const CustomBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Stack(
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
        const Picture(img: 'mountains.png', top: 0.18-LOGIN_PAGE_MOVE, left: 0, width: 0),
        const Picture(img: 'second-bush.png', top: 0.43-LOGIN_PAGE_MOVE, left: 0.66, width: 0.3),
        const Picture(img: 'first-bush.png', top: 0.42-LOGIN_PAGE_MOVE, left: 0, width: 0.6),
        const Picture(img: 'path.png', top: 0.4-LOGIN_PAGE_MOVE, left: 0, width: 0),
        const Picture(img: 'wanderer.png', top: 0.35-LOGIN_PAGE_MOVE, left: 0.1, width: 0.25),
        Positioned(
          width: screenWidth,
          top: screenHeight * (0.15-LOGIN_PAGE_MOVE+0.05),
          child: Center(
            child: Text(
              'Witaj pielgrzymie !',
              style: TextStyle(
                  fontFamily: 'Asap',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  fontSize: 36,
                  shadows: [
                    Shadow(
                        color: Colors.black.withOpacity(0.5),
                        offset: const Offset(2.0, 4.0),
                        blurRadius: 10)
                  ]),
            ),
          ),
        ),
        Positioned(
          width: screenWidth,
          top: screenHeight * 0.85,
          child: Center(
            child: ElevatedButton(
                style: ButtonStyle(
                  fixedSize: WidgetStateProperty.all(const Size(300, 50)),
                  elevation: const WidgetStatePropertyAll(5.0),
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                ),
                onPressed: null,
                child: Stack(
                  children: [
                    Container(
                      width: 300,
                      alignment: Alignment.centerRight,
                      child: Image.asset('images/arrow-right.png', height: 20,),
                    ),
                    Container(
                      alignment: Alignment.center,
                      width: 300,
                      child: const Text(
                        'Zaczynajmy',
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 24,
                          fontFamily: 'Lexend',
                        ),
                      ),),
                  ],
                )),
          ),
        ),
      ],
    );
  }
}

class Picture extends StatelessWidget {
  final String img;
  final double top;
  final double left;
  final double width;

  const Picture({
    Key? key,
    required this.img,
    required this.top,
    required this.left,
    required this.width,
  }) : super(key: key);

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
      ..color = const Color(0xFFBEBEBE)
      ..style = PaintingStyle.fill;

    Path path = Path()
      ..moveTo(0, size.height * (0.8-LOGIN_PAGE_MOVE-0.05))
      ..quadraticBezierTo(size.width * 0.25, size.height * (0.8-LOGIN_PAGE_MOVE-0.05),
          size.width * 0.5, size.height * (0.75-LOGIN_PAGE_MOVE-0.05))
      ..quadraticBezierTo(
          size.width * 0.8, size.height * (0.7-LOGIN_PAGE_MOVE-0.05), size.width, size.height * (0.7-LOGIN_PAGE_MOVE-0.05))
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
