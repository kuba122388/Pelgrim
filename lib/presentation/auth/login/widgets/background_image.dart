import 'dart:math';

import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';

class BackgroundImage extends StatelessWidget {
  const BackgroundImage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [APPROVED_GRADIENT_TOP, APPROVED_GRADIENT_BOTTOM],
        ),
      ),
      child: Stack(
        children: [
          _positionedImg(
            'first-bush.png',
            bottom: screenHeight * 0.21,
            left: 0,
            width: screenWidth * 0.5,
          ),
          _positionedImg(
            'first-bush.png',
            bottom: screenHeight * 0.42,
            left: screenWidth * 0.485,
            width: screenWidth * 0.4,
            angle: 7.5,
          ),
          _positionedImg(
            'long-path.png',
            bottom: 0,
            left: 0,
            width: screenWidth,
          ),
          _positionedImg(
            'second-bush.png',
            bottom: -screenHeight * 0.02,
            left: screenWidth * 0.45,
            width: screenWidth * 0.4,
          ),
          _positionedImg(
            'third-bush.png',
            bottom: screenHeight * 0.36,
            left: screenWidth * 0.1,
            width: screenWidth * 0.5,
            angle: 5,
          ),
          _positionedImg(
            'cloud.png',
            bottom: screenHeight * 0.64,
            left: 0,
            width: screenWidth * 0.4,
          ),
          _positionedImg(
            'trees.png',
            bottom: screenHeight * 0.575,
            left: screenWidth * 0.26,
            width: screenWidth * 0.45,
          ),
          _positionedImg(
            'bird1.png',
            bottom: screenHeight * 0.9,
            left: screenWidth * 0.32,
            width: screenWidth * 0.15,
          ),
          _positionedImg(
            'bird2.png',
            bottom: screenHeight * 0.82,
            left: screenWidth * 0.45,
            width: screenWidth * 0.2,
          ),
          _positionedImg(
            'bird3.png',
            bottom: screenHeight * 0.85,
            left: screenWidth * 0.60,
            width: screenWidth * 0.3,
          ),
          _positionedImg(
            'bird4.png',
            bottom: screenHeight * 0.79,
            left: screenWidth * 0.75,
            width: screenWidth * 0.2,
          ),
        ],
      ),
    );
  }

  Widget _positionedImg(
    String name, {
    required double bottom,
    required double left,
    double? width,
    double angle = 0,
  }) {
    return Positioned(
      bottom: bottom,
      left: left,
      width: width,
      child: Transform.rotate(
        angle: angle * (pi / 180),
        child: Image.asset('images/$name'),
      ),
    );
  }
}
