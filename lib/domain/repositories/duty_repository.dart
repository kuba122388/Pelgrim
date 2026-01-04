import 'package:pelgrim/domain/entities/duty.dart';

abstract class DutyRepository {
  Future<void> addDuty(String groupName, Duty duty);

  Future<void> deleteDuty(String groupName, String dutyId);

  Future<List<Duty>> getDuties(String groupName);
}
