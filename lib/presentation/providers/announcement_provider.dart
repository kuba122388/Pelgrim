import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/announcement.dart';
import 'package:pelgrim/domain/usecases/announcement/add_announcement_use_case.dart';
import 'package:pelgrim/domain/usecases/announcement/delete_announcement_use_case.dart';
import 'package:pelgrim/domain/usecases/announcement/get_announcements_stream_use_case.dart';

class AnnouncementProvider extends ChangeNotifier {
  final AddAnnouncementUseCase _addAnnouncement;
  final DeleteAnnouncementUseCase _deleteAnnouncementUseCase;
  final GetAnnouncementsStreamUseCase _getAnnouncementsStreamUseCase;

  AnnouncementProvider(
      this._addAnnouncement, this._deleteAnnouncementUseCase, this._getAnnouncementsStreamUseCase);

  Future<void> addAnnouncement(String groupName, Announcement announcement) async {
    await _addAnnouncement.execute(groupName, announcement);
  }

  Future<void> deleteAnnouncement(String groupName, String announcementId) async {
    await _deleteAnnouncementUseCase.execute(groupName, announcementId);
  }

  Stream<List<Announcement>> getAnnouncementStream(String groupName) {
    return _getAnnouncementsStreamUseCase.execute(groupName);
  }
}
