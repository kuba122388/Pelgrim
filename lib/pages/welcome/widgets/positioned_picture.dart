import 'package:flutter/material.dart';

class PositionedPicture extends StatelessWidget {
  final String img;
  final double top;
  final double left;
  final double width;

  const PositionedPicture({
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
