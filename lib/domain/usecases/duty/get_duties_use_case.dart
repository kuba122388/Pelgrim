import 'package:pelgrim/domain/repositories/duty_repository.dart';

class GetDutiesUseCase {
  final DutyRepository _dutyRepository;

  GetDutiesUseCase(this._dutyRepository);

  Future<void> execute(String groupName) async {
    await _dutyRepository.getDuties(groupName);
  }
}
