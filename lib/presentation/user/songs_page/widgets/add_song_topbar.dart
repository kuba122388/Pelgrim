import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:provider/provider.dart';

import '../../../widgets/topbar_clipper.dart';

class AddSongTopBar extends StatefulWidget implements PreferredSizeWidget {
  final Future<void> Function()? onAccept;

  const AddSongTopBar({super.key, required this.onAccept});

  @override
  State<AddSongTopBar> createState() => _AddSongTopBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80);
}

class _AddSongTopBarState extends State<AddSongTopBar> {
  late User? myUser;
  bool processing = false;

  @override
  Widget build(BuildContext context) {
    final Group groupInfo = context.read<UserProvider>().groupInfo!;

    final screenWidth = MediaQuery.of(context).size.width;
    final statusBar = MediaQuery.of(context).padding.top;
    final screenHeight = MediaQuery.of(context).size.height - statusBar;

    String title = groupInfo.groupColor;
    String subtitle = groupInfo.groupCity;
    Color firstColor = groupInfo.color;
    Color secondColor = groupInfo.secondColor;

    return PreferredSize(
        preferredSize: const Size.fromHeight(80),
        child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: ClipPath(
              clipper: TopBarClipper(),
              child: Container(
                width: screenWidth,
                height: screenHeight * 0.1 + statusBar,
                padding: EdgeInsets.only(top: statusBar + 8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [firstColor, secondColor],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: screenWidth * 0.9,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const SizedBox(width: 10),
                          InkWell(
                            onTap: () => {
                              setState(() {
                                processing = true;
                              }),
                              Navigator.pop(context),
                            },
                            child: Image.asset('./images/delete.png', width: 35),
                          ),
                          SizedBox(
                              width: screenWidth * 0.4,
                              child: Center(
                                  child: Text(
                                title,
                                style: TextStyle(
                                  color: secondColor == const Color(0xFFFFFFFF)
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                              ))),
                          InkWell(
                            onTap: () async {
                              if (processing == false) {
                                setState(() {
                                  processing = true;
                                });

                                if (widget.onAccept != null) await widget.onAccept!();

                                setState(() {
                                  processing = false;
                                });
                              }
                            },
                            child: Image.asset('./images/accept.png', width: 35),
                          ),
                          const SizedBox(width: 10)
                        ],
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: secondColor == const Color(0xFFFFFFFF) ? Colors.black : Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            )));
  }
}
