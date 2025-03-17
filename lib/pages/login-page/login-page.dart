import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/auth.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/pages/login-page/login-approved.dart';
import 'package:pelgrim/pages/register-page/register-user.dart';
import 'package:pelgrim/pages/widgets/background.dart';

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
    final screenHeight = MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top;

    return Scaffold(
      resizeToAvoidBottomInset: true,
        body: SafeArea(child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(child: SizedBox(
              width: screenWidth,
              height: screenHeight,
              child: Stack(
              children: [
                Background(),
                Positioned(
                  width: screenWidth,
                  top: screenHeight * 0.87,
                  child: Center(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          fixedSize: WidgetStateProperty.all(
                              Size(screenWidth * LOGIN_CONTAINER_SIZE, 50)),
                          elevation: const WidgetStatePropertyAll(5.0),
                          backgroundColor:
                              const WidgetStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          signInWithEmailAndPassword();
                        FocusScope.of(context).unfocus();
                        },
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
                                'Zaloguj',
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
                Positioned(
                    width: screenWidth,
                    top: screenHeight * 0.56,
                    child: Column(children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: screenWidth * LOGIN_CONTAINER_SIZE),
                              child: const Text(
                                'E-mail',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Asap',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    shadows: [
                                      Shadow(
                                          color: LOGIN_SHADOW_TEXT,
                                          blurRadius: 4,
                                          offset: LOGIN_SHADOW_OFFSET)
                                    ]),
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                  constraints: BoxConstraints(
                                      minWidth:
                                          screenWidth * LOGIN_CONTAINER_SIZE,
                                      maxWidth:
                                          screenWidth * LOGIN_CONTAINER_SIZE),
                                  child: _entryField(_controllerEmail, false, TextInputAction.next)),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              constraints: BoxConstraints(
                                  minWidth: screenWidth * LOGIN_CONTAINER_SIZE),
                              child: const Text(
                                'Hasło',
                                style: TextStyle(
                                    fontSize: 28,
                                    fontFamily: 'Asap',
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    decoration: TextDecoration.none,
                                    shadows: [
                                      Shadow(
                                          color: LOGIN_SHADOW_TEXT,
                                          blurRadius: 4,
                                          offset: LOGIN_SHADOW_OFFSET)
                                    ]),
                              ),
                            ),
                          ]),
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Center(
                              child: Container(
                                  constraints: BoxConstraints(
                                      minWidth:
                                          screenWidth * LOGIN_CONTAINER_SIZE,
                                      maxWidth:
                                          screenWidth * LOGIN_CONTAINER_SIZE),
                                  child: _entryField(_controllerPassword, true, TextInputAction.done)),
                            ),
                          ]),
                      Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                        Container(
                        constraints: BoxConstraints(
                            minWidth: screenWidth * LOGIN_CONTAINER_SIZE),
                        alignment: Alignment.centerRight,
                        padding: const EdgeInsets.only(top: 10),
                        child: InkWell(
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const RegisterUser())
                          ),
                            child: const Text('Nie masz konta?', style: TextStyle(
                          fontSize: 18,
                          color: LOGIN_ALTERNATE_OPTION,
                          decoration: TextDecoration.underline,
                          decorationColor: LOGIN_ALTERNATE_OPTION,
                        ),))
                        )],)
                    ]))
              ],
            ))))));
  }

  Future<void> signInWithEmailAndPassword() async {
    try{

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Logowanie...", textAlign: TextAlign.center),
        duration: Duration(milliseconds: 1500),
      ));

      await Auth().signInWithEmailAndPassword(
          email: _controllerEmail.text,
          password: _controllerPassword.text
      );

      await Future.delayed(const Duration(milliseconds: 1400));
      
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => LoginApproved(email: _controllerEmail.text,)),
          (route) => false
      );
    } on FirebaseAuthException catch (e) {
      if(e.code=='network-request-failed'){
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => LoginApproved(email: _controllerEmail.text,)),
                (route) => false
        );
      }

      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
        content: Text("Nieprawidłowy E-mail lub hasło", textAlign: TextAlign.center),
        duration: Duration(milliseconds: 2000),
      ));
    }
  }

  Widget _entryField(TextEditingController controller, hide, action) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        textInputAction: action,
        obscureText: hide == true ? true : false,
        controller: controller,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        decoration: const InputDecoration(
          isDense: true,
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          border:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
        ),
      ),
    );
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
      ..moveTo(0, size.height * (BACKGROUND_WAVES_IMAGE+0.05))
      ..quadraticBezierTo(size.width * 0.25, size.height * (BACKGROUND_WAVES_IMAGE+0.05),
          size.width * 0.5, size.height * BACKGROUND_WAVES_IMAGE)
      ..quadraticBezierTo(
          size.width * 0.75, size.height * (BACKGROUND_WAVES_IMAGE-0.05), size.width, size.height * (BACKGROUND_WAVES_IMAGE-0.05))
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
