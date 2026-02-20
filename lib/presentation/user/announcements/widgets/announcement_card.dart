import 'package:flutter/material.dart';
import 'package:flutter_linkify/flutter_linkify.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/announcement.dart';
import 'package:url_launcher/url_launcher.dart';

class AnnouncementCard extends StatelessWidget {
  final Announcement announcement;
  final String currentUserId;
  final bool isAdmin;
  final Future<void> Function()? onDelete;

  const AnnouncementCard({
    super.key,
    required this.announcement,
    required this.onDelete,
    required this.currentUserId,
    required this.isAdmin,
  });

  String _formatDate(DateTime date) {
    return '${announcement.createdAt.day.toString().padLeft(2, '0')}.'
        '${announcement.createdAt.month.toString().padLeft(2, '0')}.'
        '${announcement.createdAt.year} '
        '${announcement.createdAt.hour.toString().padLeft(2, '0')}:'
        '${announcement.createdAt.minute.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 5),
                  child: Text(
                    announcement.anonymous == false ? announcement.authorName : 'Autor Anonimowy',
                    style: const TextStyle(fontFamily: 'Lexend'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Text(
                    _formatDate(announcement.createdAt),
                    style: const TextStyle(fontSize: 8, fontFamily: 'Lexend'),
                  ),
                ),

                // Note: Wyświetl tekst 'WAŻNE!' jeśli jest tak oznaczone
                if (announcement.important)
                  const Text(
                    'WAŻNE!',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
            Row(
              children: [
                Flexible(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 5, bottom: 10),
                    child: SelectionArea(
                      child: Linkify(
                        text: announcement.content,
                        style: const TextStyle(fontSize: FONT_SIZE_SMALL),
                        linkStyle: const TextStyle(color: Colors.blue),
                        onOpen: (link) async {
                          final Uri url = Uri.parse(link.url);
                          if (await canLaunchUrl(url)) {
                            await launchUrl(url, mode: LaunchMode.externalApplication);
                          } else {
                            throw 'Nie można otworzyć $url';
                          }
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Note: Wyświetl jeśli jest to autor lub admin
            if (announcement.authorId == currentUserId || isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  InkWell(
                    onTap: onDelete,
                    child: Image.asset('./images/trash.png', width: 15),
                  )
                ],
              ),
          ],
        ),
      ),
    );
  }
}
