import 'package:flutter/material.dart';

class RegisterTopBar extends StatefulWidget implements PreferredSizeWidget{
  final String title;
  final String subtitle;
  final Color firstColor;
  final Color secondColor;

  const RegisterTopBar(
      {super.key,
        required this.title,
        required this.subtitle,
        required this.firstColor,
        required this.secondColor});

  @override
  State<RegisterTopBar> createState() => _RegisterTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _RegisterTopBarState extends State<RegisterTopBar> {
  Color _getFirstColor() {
    return widget.firstColor;
  }

  Color _getSecondColor() {
    return widget.secondColor;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;

    return PreferredSize(preferredSize: const Size.fromHeight(80), child: ClipPath(
      clipper: TopBarClipper(),
      child: Container(
        width: screenWidth,
        height: screenHeight * 0.1 + statusBar,
        padding: EdgeInsets.only(top: statusBar + 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [_getFirstColor(), _getSecondColor()],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: screenWidth * 0.5,
                    child: Center(
                        child: Text(
                          widget.title == ''
                              ? 'Uzupełnij kolor pielgrzymki'
                              : widget.title,
                          style: TextStyle(
                            color: _getSecondColor() == const Color(0xFFFFFFFF)
                                ? Colors.black
                                : Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 1,
                        ))),
              ],
            ),
            Text(
              widget.subtitle == ''
                  ? 'Uzupełnij miejscowość pielgrzymki'
                  : widget.subtitle,
              style: TextStyle(
                color: _getSecondColor() == const Color(0xFFFFFFFF)
                    ? Colors.black
                    : Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    ));
  }
}

class TopBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height - 20);
    path.quadraticBezierTo(
        size.width / 2, size.height + 20, size.width, size.height - 20);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return false;
  }
}
