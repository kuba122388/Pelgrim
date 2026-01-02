import 'package:flutter/material.dart';

import '../../core/const/app_sizes.dart';

class CustomNavigateButton extends StatelessWidget {
  final String text;
  final Function onPressed;

  const CustomNavigateButton({super.key, required this.text, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        fixedSize: Size(screenWidth * AppSizes.loginContainerScale, 50),
        elevation: 5,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      onPressed: () => onPressed(),
      child: Stack(
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: Image.asset('images/arrow-right.png', height: 20),
          ),
          Align(
            alignment: Alignment.center,
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
