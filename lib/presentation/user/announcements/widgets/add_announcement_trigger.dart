import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';

class AddAnnouncementRow extends StatelessWidget {
  const AddAnnouncementRow({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
            decoration: BoxDecoration(
                color: BACKGROUND_CONTAINERS_COLOR,
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(10)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    margin: const EdgeInsets.only(right: 10, left: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xC0FFFFFF),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                ),
                Image.asset('./images/plus.png', height: 24)
              ],
            ),
          ),
        ),
      ],
    );
  }
}
