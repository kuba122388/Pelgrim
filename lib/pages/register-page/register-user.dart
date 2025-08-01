import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pelgrim/auth.dart';
import 'package:pelgrim/consts.dart';
import 'package:pelgrim/models/MyUser.dart';
import 'package:pelgrim/pages/register-page/register-topbar.dart';
import 'package:pelgrim/pages/widgets/background.dart';

class RegisterUser extends StatefulWidget {
  const RegisterUser({super.key});

  @override
  State<RegisterUser> createState() => _RegisterUserState();
}

class _RegisterUserState extends State<RegisterUser> {
  bool isRegister = false;
  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerGroupColor = TextEditingController();
  final TextEditingController _controllerGroupCity = TextEditingController();

  final ScrollController _scrollController = ScrollController();

  String? _selectedPilgrimage;
  List<String> _pilgrimageList = [];

  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodeGroupColor = FocusNode();
  final FocusNode _focusNodeGroupCity = FocusNode();

  Color pickerColor = const Color(0xffffffff);

  @override
  void dispose() {
    _focusNodeFirstName.dispose();
    _focusNodeLastName.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodePhone.dispose();
    _focusNodeGroupColor.dispose();
    _focusNodeGroupCity.dispose();
    super.dispose();
  }

  Color _getSecondColor(Color myColor) {
    Color baseColor = myColor;
    int diffR = 75;
    int diffG = 110;
    int diffB = 121;

    int newR = (baseColor.red + diffR).clamp(0, 255);
    int newG = (baseColor.green + diffG).clamp(0, 255);
    int newB = (baseColor.blue + diffB).clamp(0, 255);
    return Color.fromARGB(baseColor.alpha, newR, newG, newB);
  }

  String stringToColor(Color colorString) {
    String color = colorString.toString();
    return color.split('(0x')[1].split(')')[0];
  }

  Future<void> createUserWithEmailAndPassword() async {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        duration: Duration(milliseconds: 500),
        content: Center(
            child: Padding(
          padding: EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            'Przygotowywanie',
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ))));
    try {
      if (_controllerFirstName.text == '' ||
          _controllerLastName.text == '' ||
          _controllerPhone.text == '' ||
          _controllerEmail.text == '') {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 500),
            content: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Jedno z pól jest puste',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ))));
        return;
      }

      if (isRegister &&
          _controllerGroupColor.text != '' &&
          _controllerGroupCity.text != '' &&
          pickerColor != const Color(0xffffffff)) {
        MyUser user = MyUser(
            admin: isRegister,
            email: _controllerEmail.text.toLowerCase().trimRight(),
            firstName: _controllerFirstName.text.trimRight(),
            lastName: _controllerLastName.text.trimRight(),
            phone: _controllerPhone.text.trimRight(),
            color: stringToColor(pickerColor).toString(),
            secondColor: stringToColor(_getSecondColor(pickerColor)),
            groupCity: _controllerGroupCity.text,
            groupColor: _controllerGroupColor.text);

        await Auth().createUserWithEmailAndPassword(
            email: _controllerEmail.text, password: _controllerPassword.text);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 3),
            content: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Poszło dalej',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ))));
        await user.createUserAndGroup();
        await Future.delayed(const Duration(milliseconds: 1500));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            content: Center(child: Text('Operacja przebiegła pomyślnie!'))));
        Navigator.pop(context);
        return;
      }

      if (_selectedPilgrimage != null) {
        MyUser user = MyUser(
            admin: isRegister,
            email: _controllerEmail.text.toLowerCase(),
            firstName: _controllerFirstName.text,
            lastName: _controllerLastName.text,
            phone: _controllerPhone.text,
            group: _selectedPilgrimage);
        await Auth().createUserWithEmailAndPassword(
            email: _controllerEmail.text, password: _controllerPassword.text);
        await user.createUser();
        await Future.delayed(const Duration(milliseconds: 1500));
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(milliseconds: 500),
            content: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Rejestracja przebiegła pomyślnie!',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ))));
        Navigator.pop(context);
        return;
      }

      if (isRegister == false) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
            duration: Duration(seconds: 3),
            content: Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                'Błąd: Nie wybrałeś pielgrzymki',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.center,
              ),
            ))));
        return;
      }
    } on FirebaseAuthException catch (e) {
      String message;
      print('CODE: ${e.code}');

      switch (e.code) {
        case 'weak-password':
          message = 'Hasło jest za słabe (min. 6 znaków)';
          break;
        case 'invalid-email':
          message = 'Niepoprawny adres e-mail';
          break;
        case 'email-already-in-use':
          message = 'Ten e-mail jest już używany';
          break;
        default:
          message = 'Błąd: ${e.message}';
      }

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(seconds: 3),
        content: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text(
              message,
              style: const TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ),
      ));
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchPilgrimages();
  }

  Future<void> _fetchPilgrimages() async {
    try {
      QuerySnapshot snapshot =
          await FirebaseFirestore.instance.collection("Pelgrim Groups").get();
      List<String> fetchedPilgrimages =
          snapshot.docs.map((doc) => doc.id).toList();

      setState(() {
        _pilgrimageList = fetchedPilgrimages;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Center(
              child: Text('Wystąpił problem z załadowaniem pielgrzymek'))));
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight =
        MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
        body: SafeArea(
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: Stack(
                  children: [
                    const Background(),
                    SingleChildScrollView(
                        physics: const NeverScrollableScrollPhysics(),
                        child: Container(
                            width: screenWidth,
                            height: screenHeight,
                            color: Colors.black.withOpacity(0.5),
                            child: Column(children: [
                              Container(
                                  width: screenWidth,
                                  height: screenHeight,
                                  color: Colors.black.withOpacity(0.5),
                                  child: Column(
                                    children: [
                                      Container(
                                        width: screenWidth * 0.8,
                                        height: screenHeight * 0.65,
                                        margin: EdgeInsets.only(
                                            top: screenHeight * 0.15,
                                            bottom: screenHeight * 0.03),
                                        padding: const EdgeInsets.only(
                                            top: 15, left: 20, right: 20),
                                        decoration: const BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(25)),
                                          color: Colors.white,
                                        ),
                                        child:
                                            _registrationContent(screenHeight),
                                      ),
                                      ElevatedButton(
                                          style: ButtonStyle(
                                            fixedSize: WidgetStateProperty.all(
                                                Size(
                                                    screenWidth *
                                                        LOGIN_CONTAINER_SIZE,
                                                    50)),
                                            elevation:
                                                const WidgetStatePropertyAll(
                                                    5.0),
                                            backgroundColor:
                                                const WidgetStatePropertyAll(
                                                    Colors.white),
                                          ),
                                          onPressed: () {
                                            createUserWithEmailAndPassword();
                                          },
                                          child: Stack(
                                            children: [
                                              Container(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Image.asset(
                                                  'images/arrow-right.png',
                                                  height: 20,
                                                ),
                                              ),
                                              Container(
                                                alignment: Alignment.center,
                                                child: const Text(
                                                  'Zarejestruj',
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 24,
                                                    fontFamily: 'Lexend',
                                                  ),
                                                ),
                                              )
                                            ],
                                          )),
                                    ],
                                  )),
                            ]))),
                    Visibility(
                        visible: isRegister,
                        child: RegisterTopBar(
                            title: _controllerGroupColor.text,
                            subtitle: _controllerGroupCity.text,
                            firstColor: pickerColor,
                            secondColor: _getSecondColor(pickerColor)))
                  ],
                ))));
  }

  Widget _registrationContent(screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rejestracja',
                style: TextStyle(
                    fontSize: 24,
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold)),
            GestureDetector(
                onTap: () =>
                    {FocusScope.of(context).unfocus(), Navigator.pop(context)},
                child: Image.asset(
                  './images/close.png',
                  width: 25,
                )),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        Container(
            padding: const EdgeInsets.only(bottom: 20),
            height: screenHeight * 0.50,
            child: CupertinoScrollbar(
                thumbVisibility: true,
                controller: _scrollController,
                child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Visibility(
                              visible: !isRegister,
                              child: DropdownButtonFormField(
                                padding: const EdgeInsets.only(
                                    right: 10, bottom: 10),
                                isExpanded: true,
                                isDense:
                                    _selectedPilgrimage == null ? true : false,
                                menuMaxHeight: screenHeight * 0.3,
                                style: const TextStyle(
                                    fontFamily: 'Lexend',
                                    fontSize: 18,
                                    color: Colors.black),
                                hint: const Text('Wybierz pielgrzymke'),
                                value: _selectedPilgrimage,
                                items: _pilgrimageList.map((String pilgrimage) {
                                  return DropdownMenuItem(
                                    value: pilgrimage,
                                    child: Text(
                                      pilgrimage,
                                      softWrap: true,
                                    ),
                                  );
                                }).toList(),
                                onChanged: (String? newValue) {
                                  setState(() {
                                    _selectedPilgrimage = newValue;
                                  });
                                },
                              )),
                          _entryField(_controllerFirstName, false, "Imie",
                              TextInputAction.next, context),
                          _entryField(_controllerLastName, false, "Nazwisko",
                              TextInputAction.next, context),
                          _entryField(_controllerEmail, false, "E-mail",
                              TextInputAction.next, context),
                          _entryField(_controllerPassword, true, "Hasło",
                              TextInputAction.next, context),
                          _entryField(
                              _controllerPhone,
                              false,
                              "Nr tel",
                              isRegister
                                  ? TextInputAction.next
                                  : TextInputAction.done,
                              context),
                          Visibility(
                              visible: isRegister,
                              child: Column(
                                children: [
                                  _entryField(
                                      _controllerGroupColor,
                                      false,
                                      "Kolor pielgrzymki",
                                      TextInputAction.next,
                                      context),
                                  _entryField(
                                      _controllerGroupCity,
                                      false,
                                      "Miejscowość grupy",
                                      TextInputAction.done,
                                      context),
                                  Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5, right: 10),
                                    child: GestureDetector(
                                        onTap: () {
                                          FocusScope.of(context).unfocus();
                                          _colorPicker();
                                        },
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              const Text(
                                                'Wybierz kolor grupy',
                                                style: TextStyle(
                                                    fontFamily: 'Lexend',
                                                    fontSize: 20),
                                              ),
                                              Container(
                                                width: 30,
                                                height: 30,
                                                decoration: BoxDecoration(
                                                    color: pickerColor,
                                                    border: pickerColor ==
                                                            const Color(
                                                                0xffffffff)
                                                        ? Border.all(
                                                            color: Colors.black)
                                                        : null),
                                              ),
                                            ])),
                                  ),
                                  Visibility(
                                      visible: isRegister ? true : false,
                                      child: Padding(
                                          padding: EdgeInsets.only(
                                              bottom: MediaQuery.of(context)
                                                      .viewInsets
                                                      .bottom /
                                                  4)))
                                ],
                              )),
                          Visibility(
                              visible: isRegister ? false : true,
                              child: Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .viewInsets
                                              .bottom /
                                          5)))
                        ])))),
        GestureDetector(
            onTap: () => setState(() {
                  FocusScope.of(context).unfocus();
                  isRegister = !isRegister;
                }),
            child: Text(
              isRegister
                  ? "Nasza pielgrzymka \nznajduje się na liście"
                  : "Naszej pielgrzymki \nnie ma na liście",
              textAlign: TextAlign.right,
              style: const TextStyle(
                  color: LOGIN_ALTERNATE_OPTION,
                  decoration: TextDecoration.underline,
                  decorationColor: LOGIN_ALTERNATE_OPTION),
            )),
      ],
    );
  }

  Future _colorPicker() {
    return showDialog(
        barrierColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Wybierz kolor grupy'),
            content: SingleChildScrollView(
              child: ColorPicker(
                hexInputBar: true,
                enableAlpha: false,
                pickerColor: pickerColor,
                onColorChanged: (Color color) {
                  setState(() {
                    pickerColor = color;
                  });
                },
              ),
            ),
            actions: <Widget>[
              ElevatedButton(
                child: const Text('DONE'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  Widget _entryField(
      TextEditingController controller, hide, text, action, context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(
        text,
        style: const TextStyle(fontSize: 20, fontFamily: 'Lexend'),
      ),
      Padding(
        padding: const EdgeInsets.only(bottom: 12, right: 10),
        child: TextField(
          keyboardType:
              text == 'Nr tel' ? TextInputType.phone : TextInputType.text,
          textCapitalization: text == 'Hasło' || text == 'E-mail'
              ? TextCapitalization.none
              : TextCapitalization.sentences,
          textInputAction: action,
          scrollPadding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          obscureText: hide == true ? true : false,
          controller: controller,
          style: const TextStyle(
            color: REGISTER_LOGIN_TEXT,
            fontSize: 20,
          ),
          decoration: InputDecoration(
            hintText: text,
            isDense: true,
            focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            border: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
            enabledBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.black)),
          ),
        ),
      ),
    ]);
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
