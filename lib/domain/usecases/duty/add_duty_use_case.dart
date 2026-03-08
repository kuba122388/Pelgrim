import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/repositories/duty_repository.dart';

class AddDutyUseCase {
  final DutyRepository _dutyRepository;

  AddDutyUseCase(this._dutyRepository);

  Future<void> execute(String groupId, Duty duty) async {
    _dutyRepository.addDuty(groupId, duty);
  }
}
