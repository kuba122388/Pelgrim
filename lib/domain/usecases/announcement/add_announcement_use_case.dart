import 'package:pelgrim/domain/entities/announcement.dart';
import 'package:pelgrim/domain/repositories/announcement_repository.dart';

class AddAnnouncementUseCase {
  final AnnouncementRepository _announcementRepository;

  AddAnnouncementUseCase(this._announcementRepository);

  Future<void> execute(String groupName, Announcement announcement) async {
    _announcementRepository.addAnnouncement(groupName, announcement);
  }
}
