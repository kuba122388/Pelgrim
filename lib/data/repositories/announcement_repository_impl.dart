import 'package:pelgrim/data/datasources/remote/announcement_data_source.dart';
import 'package:pelgrim/domain/entities/announcement.dart';
import 'package:pelgrim/domain/repositories/announcement_repository.dart';

import '../models/announcement_model.dart';

class AnnouncementRepositoryImpl implements AnnouncementRepository {
  final AnnouncementDataSource _announcementDataSource;

  AnnouncementRepositoryImpl(this._announcementDataSource);

  @override
  Future<void> addAnnouncement(String groupName, Announcement announcement) async {
    try {
      await _announcementDataSource.addAnnouncement(
          groupName, AnnouncementModel.fromEntity(announcement));
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAnnouncement(String group, String announcementId) async {
    try {
      await _announcementDataSource.deleteAnnouncement(group, announcementId);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Stream<List<Announcement>> getAnnouncementsStream(String groupName) {
    try {
      return _announcementDataSource
          .getAnnouncementsStream(groupName)
          .map((models) => models.map((e) => e.toEntity()).toList());
    } catch (e) {
      rethrow;
    }
  }
}
