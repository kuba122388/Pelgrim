import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_colors.dart';
import 'package:pelgrim/core/const/app_sizes.dart';
import 'package:pelgrim/core/const/app_styles.dart';
import 'package:pelgrim/presentation/widgets/background_gradient.dart';
import 'package:pelgrim/presentation/widgets/positioned_picture.dart';
import 'package:pelgrim/presentation/widgets/wave_painter.dart';

class WelcomeBackground extends StatelessWidget {
  final bool elevated;
  final String heroTag;
  final double textElevation;
  final double imageElevation;

  const WelcomeBackground({
    super.key,
    this.elevated = false,
    this.heroTag = "Default Welcome",
    this.textElevation = 0.0,
    this.imageElevation = 0.0,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenHeight = size.height - MediaQuery.of(context).padding.top;
    final double elevationOffset = elevated ? screenHeight * AppSizes.elevationIndicator : 0;

    return Stack(
      children: [
        const BackgroundGradient(),
        Positioned.fill(
          child: CustomPaint(painter: WavePainter()),
        ),
        Positioned(
          width: size.width,
          top: screenHeight * (AppSizes.welcomeTitleTop - AppSizes.loginContentOffset) +
              textElevation,
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
                    color: AppColors.loginShadow,
                    offset: AppStyles.loginShadowOffset,
                    blurRadius: 10,
                  )
                ],
              ),
            ),
          ),
        ),
        Transform.translate(
          offset: Offset(0, -elevationOffset + imageElevation),
          child: Hero(
            tag: heroTag,
            child: Stack(
              children: [
                const PositionedPicture(
                    img: 'mountains.png', top: AppSizes.mountainsTop, left: 0, width: 0),
                const PositionedPicture(
                    img: 'second-bush.png', top: AppSizes.secondBushTop, left: 0.66, width: 0.3),
                const PositionedPicture(
                    img: 'first-bush.png', top: AppSizes.firstBushTop, left: 0, width: 0.6),
                PositionedPicture(
                  img: 'path.png',
                  top: screenHeight < 800 ? AppSizes.pathTopSmall : AppSizes.pathTopBig,
                  left: 0,
                  width: 0,
                ),
                const PositionedPicture(
                  img: 'wanderer.png',
                  top: AppSizes.wandererTop,
                  left: 0.1,
                  width: AppSizes.wandererWidth,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
