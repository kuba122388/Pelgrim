import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/entities/duty_volunteer.dart';

abstract class DutyRepository {
  Future<void> addDuty(String groupName, Duty duty);

  Future<void> deleteDuty(String groupName, String dutyId);

  Stream<List<Duty>> getDutiesStream(String groupName);

  Future<void> addVolunteer(String groupId, String dutyId, DutyVolunteer volunteer);

  Future<void> removeVolunteer(String groupId, String dutyId, String userId);
}
