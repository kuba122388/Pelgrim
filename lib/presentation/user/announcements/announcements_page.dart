import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelgrim/core/const/app_consts.dart';
import 'package:pelgrim/domain/entities/announcement.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/presentation/providers/announcement_provider.dart';
import 'package:pelgrim/presentation/providers/user_provider.dart';
import 'package:pelgrim/presentation/user/announcements/widgets/add_announcement_dialog.dart';
import 'package:pelgrim/presentation/user/announcements/widgets/add_announcement_trigger.dart';
import 'package:pelgrim/presentation/user/announcements/widgets/announcement_card.dart';
import 'package:pelgrim/presentation/user/announcements/widgets/delete_announcement_dialog.dart';
import 'package:provider/provider.dart';

class AnnouncementsPage extends StatefulWidget {
  const AnnouncementsPage({super.key});

  @override
  State<AnnouncementsPage> createState() => _AnnouncementsPageState();
}

class _AnnouncementsPageState extends State<AnnouncementsPage> {
  late final UserProvider _userProvider;
  late final AnnouncementProvider _announcementProvider;

  bool _important = false;

  @override
  void initState() {
    super.initState();
    _userProvider = context.read<UserProvider>();
    _announcementProvider = context.read<AnnouncementProvider>();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _announcementProvider.startAnnouncementStream(
        _userProvider.userGroupId,
      );
    });
  }

  Future<void> _deleteAnnouncement(
    Announcement announcement,
    String groupId,
  ) {
    return showDialog(
      context: context,
      builder: (_) => DeleteAnnouncementDialog(
        announcement: announcement,
        onConfirm: () async {
          await _announcementProvider.deleteAnnouncement(
            groupId,
            announcement.id!,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final User user = _userProvider.user!;

    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height - MediaQuery.of(context).padding.top;

    final List<Announcement> announcements = _announcementProvider.announcementList;

    final filtered = _important ? announcements.where((a) => a.important).toList() : announcements;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: SizedBox(
          width: screenWidth,
          height: screenHeight,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: screenHeight * 0.02, bottom: screenHeight * 0.01),
                child: const Text(
                  'Dodaj Ogłoszenie',
                  style: TextStyle(
                    fontFamily: 'Lexend',
                    fontWeight: FontWeight.bold,
                    color: FONT_BLACK_COLOR,
                    fontSize: 18,
                    shadows: [APP_TEXT_SHADOW],
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  width: screenWidth * 0.85,
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (_) => AddAnnouncementDialog(
                              onConfirm: (
                                  {required content,
                                  required isImportant,
                                  required isAnonymous}) async {
                                final announcement = Announcement(
                                  authorId: user.id,
                                  authorName: user.fullName,
                                  content: content,
                                  createdAt: DateTime.now(),
                                  important: isImportant,
                                  anonymous: isAnonymous,
                                );

                                await _announcementProvider.addAnnouncement(
                                  _userProvider.userGroupId,
                                  announcement,
                                );
                              },
                            ),
                          );
                        },
                        child: const AddAnnouncementRow(),
                      ),
                      SizedBox(height: screenHeight * 0.01),
                      Container(
                        height: screenHeight * 0.73,
                        padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
                        decoration: BoxDecoration(
                            color: BACKGROUND_CONTAINERS_COLOR,
                            border: Border.all(color: Colors.black),
                            borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Tablica ogłoszeń',
                                  style: TextStyle(
                                    fontFamily: 'Lexend',
                                    fontWeight: FontWeight.bold,
                                    color: FONT_BLACK_COLOR,
                                    fontSize: FONT_SIZE_BIG,
                                  ),
                                ),
                                Row(
                                  children: [
                                    SizedBox(
                                      width: 36,
                                      height: 24,
                                      child: Checkbox(
                                        value: _important,
                                        onChanged: (bool? value) {
                                          setState(() {
                                            _important = value!;
                                          });
                                        },
                                        activeColor: Colors.grey,
                                      ),
                                    ),
                                    const Text(
                                      'Ważne',
                                      style: TextStyle(
                                        fontFamily: 'Lexend',
                                        fontWeight: FontWeight.bold,
                                        fontSize: FONT_SIZE_SMALL,
                                        color: FONT_BLACK_COLOR,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Expanded(
                              child: _announcementProvider.isInitialLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(),
                                    )
                                  : filtered.isEmpty
                                      ? const Center(
                                          child: Text(
                                            'Brak ogłoszeń',
                                            style: TextStyle(
                                                fontFamily: 'Lexend', color: FONT_BLACK_COLOR),
                                          ),
                                        )
                                      : ListView.builder(
                                          itemCount: filtered.length,
                                          itemBuilder: (_, i) => AnnouncementCard(
                                            currentUserId: _userProvider.user!.id,
                                            isAdmin: _userProvider.user!.isAdmin,
                                            announcement: filtered[i],
                                            onDelete: () => _deleteAnnouncement(
                                              filtered[i],
                                              _userProvider.userGroupId,
                                            ),
                                          ),
                                        ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
