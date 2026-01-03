import 'package:flutter/material.dart';

import '../../../core/const/app_consts.dart';

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
      ..quadraticBezierTo(size.width * 0.25, size.height * (BACKGROUND_WAVES_IMAGE + 0.05),
          size.width * 0.5, size.height * BACKGROUND_WAVES_IMAGE)
      ..quadraticBezierTo(size.width * 0.75, size.height * (BACKGROUND_WAVES_IMAGE - 0.05),
          size.width, size.height * (BACKGROUND_WAVES_IMAGE - 0.05))
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
