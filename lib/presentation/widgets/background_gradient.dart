import 'package:flutter/material.dart';

import 'package:pelgrim/core/const/app_colors.dart';

class BackgroundGradient extends StatelessWidget {
  const BackgroundGradient({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.approvedGradientBottom, AppColors.approvedGradientTop],
          stops: [0.0, 0.8],
        ),
      ),
    );
  }
}
