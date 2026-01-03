import 'package:pelgrim/domain/entities/announcement.dart';
import 'package:pelgrim/domain/repositories/announcement_repository.dart';

class GetAnnouncementsStreamUseCase {
  final AnnouncementRepository _announcementRepository;

  GetAnnouncementsStreamUseCase(this._announcementRepository);

  Stream<List<Announcement>> execute(String groupName) {
    return _announcementRepository.getAnnouncementsStream(groupName);
  }
}
