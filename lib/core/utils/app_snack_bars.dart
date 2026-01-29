import 'package:flutter/material.dart';

class AppSnackBars {
  static void show(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    bool isError = false,
    required int duration,
  }) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    final finalColor = backgroundColor ?? (isError ? Colors.red.shade700 : Colors.green.shade700);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontFamily: 'Lexend',
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: finalColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        margin: const EdgeInsets.all(20),
        duration: Duration(seconds: duration),
      ),
    );
  }

  static void success(BuildContext context, String message, {int duration = 4}) =>
      show(context, message: message, isError: false, duration: duration);

  static void error(BuildContext context, String message, {int duration = 4}) =>
      show(context, message: message, isError: true, duration: duration);

  static void info(BuildContext context, String message, {int duration = 4}) =>
      show(context, message: message, backgroundColor: Colors.grey.shade800, duration: duration);
}
