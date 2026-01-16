import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../widgets/custom_navigate_button.dart';
import '../../widgets/welcome_background.dart';

class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final userProvider = context.read<UserProvider>();

    try {
      await userProvider.resetPassword(_emailController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Link do resetu hasła został wysłany na Twój e-mail.'),
          backgroundColor: Colors.green,
        ),
      );
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = context.watch<UserProvider>().isLoading;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SafeArea(
          child: Stack(
            children: [
              const WelcomeBackground(
                heroTag: "Welcome",
                textElevation: 20.0,
                imageElevation: 240.0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 20.0),
                child: GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.arrow_back_sharp,
                      size: 32.0,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(
                        height: 140.0,
                      ),
                      const Text(
                        "Wpisz swój e-mail, a wyślemy Ci link do zmiany hasła.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      const SizedBox(height: 30),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: Colors.white,
                        style: const TextStyle(color: Colors.white),
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            labelText: "E-mail",
                            disabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                color: Colors.white,
                                width: 1.0,
                              ),
                            ),
                            labelStyle: TextStyle(color: Colors.white),
                            prefixIconColor: Colors.white,
                            prefixIcon: Icon(Icons.email),
                            fillColor: Colors.white),
                        validator: (value) {
                          if (value == null || !value.contains('@')) {
                            return 'Podaj poprawny adres e-mail';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 40),
                      Hero(
                        tag: "Navigate_button",
                        child: CustomNavigateButton(
                          text: isLoading ? "Wysyłanie...: " : "Wyślij link",
                          onPressed: () {
                            FocusScope.of(context).unfocus();
                            if (!isLoading) _submit();
                          },
                          trailingIcon: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
