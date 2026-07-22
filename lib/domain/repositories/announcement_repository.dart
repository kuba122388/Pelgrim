import 'package:pelgrim/domain/entities/announcement.dart';

abstract class AnnouncementRepository {
  Future<void> addAnnouncement(String groupName, Announcement announcement);

  Future<void> deleteAnnouncement(String groupName, String announcementId);

  Stream<List<Announcement>> getAnnouncementsStream(String groupName);
}
