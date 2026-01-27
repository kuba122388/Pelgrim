import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/presentation/auth/login/pages/login_approved.dart';
import 'package:pelgrim/presentation/auth/register/widgets/custom_text_field.dart';
import 'package:pelgrim/presentation/auth/register/widgets/register_topbar.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/widgets/welcome_background.dart';
import 'package:provider/provider.dart';

import '../../../../domain/entities/group.dart';

class RegisterUserPage extends StatefulWidget {
  const RegisterUserPage({super.key});

  @override
  State<RegisterUserPage> createState() => _RegisterUserPageState();
}

class _RegisterUserPageState extends State<RegisterUserPage> {
  late final UserProvider _userProvider;

  final TextEditingController _controllerFirstName = TextEditingController();
  final TextEditingController _controllerLastName = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerPassword = TextEditingController();
  final TextEditingController _controllerPhone = TextEditingController();
  final TextEditingController _controllerGroupColor = TextEditingController();
  final TextEditingController _controllerGroupCity = TextEditingController();

  final FocusNode _focusNodeFirstName = FocusNode();
  final FocusNode _focusNodeLastName = FocusNode();
  final FocusNode _focusNodeEmail = FocusNode();
  final FocusNode _focusNodePassword = FocusNode();
  final FocusNode _focusNodePhone = FocusNode();
  final FocusNode _focusNodeGroupColor = FocusNode();
  final FocusNode _focusNodeGroupCity = FocusNode();

  final ScrollController _scrollController = ScrollController();

  bool _isRegister = false;

  Group? _selectedPilgrimage;
  Color _pickerColor = const Color(0xffffffff);

  List<Group> _allGroups = [];

  @override
  void initState() {
    super.initState();

    _userProvider = context.read<UserProvider>();

    _controllerGroupColor.addListener(_updateUI);
    _controllerGroupCity.addListener(_updateUI);

    _loadInitialData();
  }

  @override
  void dispose() {
    _controllerGroupColor.removeListener(_updateUI);
    _controllerGroupCity.removeListener(_updateUI);

    _controllerFirstName.dispose();
    _controllerLastName.dispose();
    _controllerEmail.dispose();
    _controllerPassword.dispose();
    _controllerPhone.dispose();
    _controllerGroupColor.dispose();
    _controllerGroupCity.dispose();

    _focusNodeFirstName.dispose();
    _focusNodeLastName.dispose();
    _focusNodeEmail.dispose();
    _focusNodePassword.dispose();
    _focusNodePhone.dispose();
    _focusNodeGroupColor.dispose();
    _focusNodeGroupCity.dispose();

    _scrollController.dispose();

    super.dispose();
  }

  void _updateUI() => setState(() {});

  Future<void> _loadInitialData() async {
    try {
      final groups = await _userProvider.fetchAllGroups();
      if (mounted) {
        setState(() {
          _allGroups = groups;
        });
      }
    } catch (e) {
      debugPrint("Nie udało się załadować grup: $e");
    }
  }

  Color _getSecondColor(Color myColor) {
    Color baseColor = myColor;
    int diffR = 75;
    int diffG = 110;
    int diffB = 121;

    double newR = (baseColor.r + (diffR / 255)).clamp(0.0, 1.0);
    double newG = (baseColor.g + (diffG / 255)).clamp(0.0, 1.0);
    double newB = (baseColor.b + (diffB / 255)).clamp(0.0, 1.0);
    return Color.from(alpha: baseColor.a, red: newR, green: newG, blue: newB);
  }

  String stringToColor(Color colorString) {
    String color = colorString.toString();
    return color.split('(0x')[1].split(')')[0];
  }

  Future<void> _handleRegistration() async {
    if (_controllerFirstName.text.isEmpty ||
        _controllerLastName.text.isEmpty ||
        _controllerEmail.text.isEmpty ||
        _controllerPassword.text.isEmpty) {
      _showSnackBar('Proszę wypełnić wszystkie pola');
      return;
    }

    if (!_isRegister && _selectedPilgrimage == null) {
      _showSnackBar('Wybierz pielgrzymkę z listy');
      return;
    }

    try {
      if (_isRegister) {
        await _userProvider.registerAdminCreateGroup(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text,
          firstName: _controllerFirstName.text.trim(),
          lastName: _controllerLastName.text.trim(),
          phone: _controllerPhone.text.trim(),
          groupColor: _controllerGroupColor.text.trim(),
          groupCity: _controllerGroupCity.text.trim(),
          color: _pickerColor,
          secondColor: _getSecondColor(_pickerColor),
        );
      } else {
        await _userProvider.registerUserJoinGroup(
          email: _controllerEmail.text.trim(),
          password: _controllerPassword.text,
          firstName: _controllerFirstName.text.trim(),
          lastName: _controllerLastName.text.trim(),
          phone: _controllerPhone.text.trim(),
          groupId: _selectedPilgrimage!.id!,
        );
      }

      if (!mounted) return;
      _showSnackBar('Rejestracja przebiegła pomyślnie!');

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const LoginApproved(),
        ),
        (route) => false,
      );
    } catch (e) {
      _showSnackBar(e.toString());
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message, textAlign: TextAlign.center)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoading;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Stack(
            children: [
              const WelcomeBackground(
                elevated: true,
              ),
              SingleChildScrollView(
                physics: const NeverScrollableScrollPhysics(),
                child: Container(
                  width: screenWidth,
                  height: screenHeight,
                  color: Colors.black.withValues(alpha: 0.5),
                  child: Column(
                    children: [
                      Container(
                        width: screenWidth,
                        height: screenHeight,
                        color: Colors.black.withValues(alpha: 0.5),
                        child: Column(
                          children: [
                            Container(
                              width: screenWidth * 0.8,
                              height: screenHeight * 0.65,
                              margin: EdgeInsets.only(
                                  top: screenHeight * 0.15, bottom: screenHeight * 0.03),
                              padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.all(Radius.circular(25)),
                                color: Colors.white,
                              ),
                              child: _registrationContent(screenHeight),
                            ),
                            ElevatedButton(
                              style: ButtonStyle(
                                fixedSize: WidgetStateProperty.all(
                                    Size(screenWidth * LOGIN_CONTAINER_SIZE, 50)),
                                elevation: const WidgetStatePropertyAll(5.0),
                                backgroundColor: const WidgetStatePropertyAll(Colors.white),
                              ),
                              onPressed: isLoading ? null : _handleRegistration,
                              child: isLoading
                                  ? const CupertinoActivityIndicator()
                                  : Stack(
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
                                            'Zarejestruj',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 24,
                                              fontFamily: 'Lexend',
                                            ),
                                          ),
                                        )
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
              Visibility(
                visible: _isRegister,
                child: RegisterTopBar(
                  title: _controllerGroupColor.text,
                  subtitle: _controllerGroupCity.text,
                  firstColor: _pickerColor,
                  secondColor: _getSecondColor(_pickerColor),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _registrationContent(screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Rejestracja',
                style: TextStyle(fontSize: 24, fontFamily: 'Lexend', fontWeight: FontWeight.bold)),
            GestureDetector(
              onTap: () => {FocusScope.of(context).unfocus(), Navigator.pop(context)},
              child: Image.asset(
                './images/close.png',
                width: 25,
              ),
            ),
          ],
        ),
        const Padding(padding: EdgeInsets.only(bottom: 10)),
        Container(
          padding: const EdgeInsets.only(bottom: 10),
          height: screenHeight * 0.50,
          child: CupertinoScrollbar(
            thumbVisibility: true,
            controller: _scrollController,
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Visibility(
                      visible: !_isRegister,
                      child: DropdownButtonFormField(
                        padding: const EdgeInsets.only(right: 10),
                        isExpanded: true,
                        isDense: _selectedPilgrimage == null ? true : false,
                        menuMaxHeight: screenHeight * 0.3,
                        style: const TextStyle(
                            fontFamily: 'Lexend', fontSize: 18, color: Colors.black),
                        hint:
                            Text(_allGroups.isEmpty ? 'Ładowanie grup...' : 'Wybierz pielgrzymkę'),
                        initialValue: _selectedPilgrimage,
                        items: _allGroups.map((Group pilgrimage) {
                          return DropdownMenuItem(
                            value: pilgrimage,
                            child: Text(
                              pilgrimage.name,
                              softWrap: true,
                            ),
                          );
                        }).toList(),
                        onChanged: (Group? newValue) {
                          setState(() {
                            _selectedPilgrimage = newValue;
                          });
                        },
                      ),
                    ),
                  ),
                  CustomTextField(
                    label: "Imie",
                    controller: _controllerFirstName,
                  ),
                  CustomTextField(
                    label: "Nazwisko",
                    controller: _controllerLastName,
                  ),
                  CustomTextField(
                    label: "E-mail",
                    controller: _controllerEmail,
                    keyboardType: TextInputType.emailAddress,
                    textCapitalization: TextCapitalization.none,
                  ),
                  CustomTextField(
                    label: "Hasło",
                    controller: _controllerPassword,
                    isPassword: true,
                    textCapitalization: TextCapitalization.none,
                  ),
                  CustomTextField(
                    label: "Nr tel",
                    controller: _controllerPhone,
                    keyboardType: TextInputType.phone,
                    textInputAction: _isRegister ? TextInputAction.next : TextInputAction.done,
                  ),
                  Visibility(
                    visible: _isRegister,
                    child: Column(
                      children: [
                        CustomTextField(
                          label: "Kolor pielgrzymki",
                          controller: _controllerGroupColor,
                        ),
                        CustomTextField(
                          label: "Miejscowość grupy",
                          controller: _controllerGroupCity,
                          textInputAction: TextInputAction.done,
                        ),
                        Container(
                          padding: const EdgeInsets.only(top: 5, bottom: 5, right: 10),
                          child: GestureDetector(
                            onTap: () {
                              FocusScope.of(context).unfocus();
                              _colorPicker();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Wybierz kolor grupy',
                                  style: TextStyle(fontFamily: 'Lexend', fontSize: 20),
                                ),
                                Container(
                                  width: 30,
                                  height: 30,
                                  decoration: BoxDecoration(
                                      color: _pickerColor,
                                      border: _pickerColor == const Color(0xffffffff)
                                          ? Border.all(color: Colors.black)
                                          : null),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Visibility(
                          visible: _isRegister ? true : false,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom / 4,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Visibility(
                    visible: _isRegister ? false : true,
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom / 5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        GestureDetector(
            onTap: () => setState(() {
                  FocusScope.of(context).unfocus();
                  _isRegister = !_isRegister;
                }),
            child: Text(
              _isRegister
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
                pickerColor: _pickerColor,
                onColorChanged: (Color color) {
                  setState(() {
                    _pickerColor = color;
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
}
