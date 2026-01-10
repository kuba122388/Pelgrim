import 'package:flutter/material.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../register/widgets/register_topbar.dart';

class BaseSongsTopBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leading;
  final List<Widget> actions;

  const BaseSongsTopBar({
    super.key,
    required this.leading,
    this.actions = const [],
  });

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final userProvider = context.read<UserProvider>();
    final groupInfo = userProvider.groupInfo!;

    final statusBar = MediaQuery.of(context).padding.top;
    final screenWidth = MediaQuery.of(context).size.width;

    final Color firstColor = groupInfo.color;
    final Color secondColor = groupInfo.secondColor;
    final bool isLight = secondColor == const Color(0xFFFFFFFF);

    return ClipPath(
      clipper: TopBarClipper(),
      child: Container(
        width: screenWidth,
        padding: EdgeInsets.only(top: statusBar + 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [firstColor, secondColor],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          children: [
            SizedBox(
              width: screenWidth * 0.9,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  leading,
                  Expanded(
                    child: Center(
                      child: Text(
                        groupInfo.groupColor,
                        style: TextStyle(
                          color: isLight ? Colors.black : Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                        maxLines: 1,
                      ),
                    ),
                  ),
                  Row(mainAxisSize: MainAxisSize.min, children: actions),
                ],
              ),
            ),
            Text(
              groupInfo.groupCity,
              style: TextStyle(
                color: isLight ? Colors.black : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
