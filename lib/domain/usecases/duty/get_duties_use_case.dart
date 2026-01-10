import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/repositories/duty_repository.dart';

class GetDutiesUseCase {
  final DutyRepository _dutyRepository;

  GetDutiesUseCase(this._dutyRepository);

  Stream<List<Duty>> execute(String groupId) {
    return _dutyRepository.getDutiesStream(groupId);
  }
}
