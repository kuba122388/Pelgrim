import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';

class UserInfoCard extends StatelessWidget {
  final String fullName;
  final bool isAdmin;

  const UserInfoCard({
    super.key,
    required this.fullName,
    required this.isAdmin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isAdmin ? "$fullName - Admin" : fullName,
          style: const TextStyle(
            fontSize: 16,
            fontFamily: 'Lexend',
            color: FONT_BLACK_COLOR,
          ),
        ),
      ],
    );
  }
}
