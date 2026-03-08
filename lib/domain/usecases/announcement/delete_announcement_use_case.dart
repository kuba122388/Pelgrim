import 'package:pelgrim/domain/repositories/announcement_repository.dart';

class DeleteAnnouncementUseCase {
  final AnnouncementRepository _announcementRepository;

  DeleteAnnouncementUseCase(this._announcementRepository);

  Future<void> execute(String groupName, String announcementId) async {
    _announcementRepository.deleteAnnouncement(groupName, announcementId);
  }
}
