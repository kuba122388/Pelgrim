import 'package:flutter/material.dart';

import '../../../core/const/app_consts.dart';

class LabeledTextField extends StatelessWidget {
  final String text;
  final TextEditingController controller;
  final bool hide;
  final TextInputAction? action;

  const LabeledTextField({
    super.key,
    required this.text,
    required this.controller,
    this.hide = false,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              constraints: BoxConstraints(
                minWidth: screenWidth * LOGIN_CONTAINER_SIZE,
              ),
              child: Text(
                text,
                style: const TextStyle(
                  fontSize: 24,
                  fontFamily: 'Asap',
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  decoration: TextDecoration.none,
                  shadows: [
                    Shadow(
                      color: LOGIN_SHADOW_TEXT,
                      blurRadius: 4,
                      offset: LOGIN_SHADOW_OFFSET,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Container(
                constraints: BoxConstraints(
                  minWidth: screenWidth * LOGIN_CONTAINER_SIZE,
                  maxWidth: screenWidth * LOGIN_CONTAINER_SIZE,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: TextField(
                    textInputAction: action,
                    obscureText: hide == true ? true : false,
                    controller: controller,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                    ),
                    decoration: const InputDecoration(
                      isDense: true,
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
