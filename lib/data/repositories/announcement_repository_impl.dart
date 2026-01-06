import 'package:pelgrim/data/datasources/remote/announcement_datasource.dart';
import 'package:pelgrim/domain/entities/announcement.dart';
import 'package:pelgrim/domain/repositories/announcement_repository.dart';

import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementDataSource _announcementService;

  AnnouncementRepositoryImpl(this._announcementService);

  @override
  Future<void> addAnnouncement(String groupName, Announcement announcement) async {
    try {
      await _announcementService.addAnnouncement(
          groupName, AnnouncementModel.fromEntity(announcement));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAnnouncement(String group, String announcementId) async {
    try {
      await _announcementService.deleteAnnouncement(group, announcementId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Announcement>> getAnnouncementsStream(String groupName) {
    try {
      return _announcementService
          .getAnnouncementsStream(groupName)
          .map((models) => models.map((e) => e.toEntity()).toList());
    } catch (e) {
      rethrow;
    }
  }
}
