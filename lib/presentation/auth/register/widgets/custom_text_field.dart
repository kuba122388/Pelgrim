import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String hintText;
  final bool isPassword;
  final TextInputType keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hintText = '',
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.sentences,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 20, fontFamily: 'Lexend'),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12, right: 10),
          child: TextField(
            controller: controller,
            obscureText: isPassword,
            keyboardType: keyboardType,
            textInputAction: textInputAction,
            textCapitalization: textCapitalization,
            style: const TextStyle(
              color: REGISTER_LOGIN_TEXT,
              fontSize: 20,
            ),
            decoration: InputDecoration(
              hintText: hintText.isEmpty ? label : hintText,
              isDense: true,
              focusedBorder:
                  const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              enabledBorder:
                  const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
              border: const UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            ),
            // NOTE: Uncomment if somethings wrong: scrollPadding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          ),
        ),
      ],
    );
  }
}
