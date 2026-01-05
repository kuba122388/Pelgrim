import 'package:pelgrim/domain/repositories/duty_repository.dart';

class DeleteDutyUseCase {
  final DutyRepository _dutyRepository;

  DeleteDutyUseCase(this._dutyRepository);

  Future<void> execute(String groupName, String dutyId) async {
    await _dutyRepository.deleteDuty(groupName, dutyId);
  }
}
