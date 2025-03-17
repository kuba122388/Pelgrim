import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/main.dart';
import 'package:pelgrim/consts.dart';

class Background extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height-MediaQuery.of(context).padding.top;

    return Stack(children: [
      Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFF31768A), Color(0xFF88CBDF)],
            stops: [0.0, 0.8],
          ),
        ),
      ), //Background-top
      Positioned.fill(
        child: CustomPaint(
          painter: WavePainter(),
        ),
      ), //Background-bottom
      const Picture(
          img: 'mountains.png',
          top: 0.2 - LOGIN_PAGE_MOVE,
          left: 0,
          width: 0), //Mountains
      const Picture(
          img: 'second-bush.png',
          top: 0.44 - LOGIN_PAGE_MOVE,
          left: 0.66,
          width: 0.3), //Second-bush
      const Picture(
          img: 'first-bush.png',
          top: 0.43 - LOGIN_PAGE_MOVE,
          left: 0,
          width: 0.6), //First-bush
      const Picture(
          img: 'path.png',
          top: 0.4 - LOGIN_PAGE_MOVE,
          left: 0,
          width: 0), //Path
      const Picture(
          img: 'wanderer.png',
          top: 0.36 - LOGIN_PAGE_MOVE,
          left: 0.1,
          width: 0.25), //Wanderer
      Positioned(
        width: screenWidth,
        top: screenHeight * (0.12 - LOGIN_PAGE_MOVE + 0.04),
        child: const Center(
          child: Text(
            'Witaj pielgrzymie!',
            style: TextStyle(
                fontFamily: 'Asap',
                fontWeight: FontWeight.bold,
                color: Colors.white,
                decoration: TextDecoration.none,
                fontSize: 36,
                shadows: [
                  Shadow(
                      color: LOGIN_SHADOW_TEXT,
                      offset: LOGIN_SHADOW_OFFSET,
                      blurRadius: 10)
                ]),
          ),
        ),
      ),
    ],);
  }

}