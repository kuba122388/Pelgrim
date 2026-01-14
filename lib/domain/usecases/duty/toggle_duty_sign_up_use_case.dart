import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/entities/duty_volunteer.dart';
import 'package:pelgrim/domain/repositories/duty_repository.dart';

class ToggleDutySignUpUseCase {
  final DutyRepository _dutyRepository;

  ToggleDutySignUpUseCase(this._dutyRepository);

  Future<void> execute(String groupId, Duty duty, DutyVolunteer dutyVolunteer) async {
    final bool isSignedUp = duty.volunteers.any((v) => v.userId == dutyVolunteer.userId);

    if (!isSignedUp && duty.volunteers.length >= duty.maxVolunteers) {
      throw Exception("Brak wolnych miejsc");
    }

    if (duty.id == null) {
      throw Exception("Ta służba nie została odnaleziona lub została usunięt.");
    }

    if (isSignedUp) {
      await _dutyRepository.removeVolunteer(groupId, duty.id!, dutyVolunteer);
    } else {
      await _dutyRepository.addVolunteer(groupId, duty.id!, dutyVolunteer);
    }
  }
}
