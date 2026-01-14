import 'package:pelgrim/data/datasources/remote/duty_data_source.dart';
import 'package:pelgrim/data/models/duty_model.dart';
import 'package:pelgrim/data/models/duty_volunteer_model.dart';
import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/entities/duty_volunteer.dart';
import 'package:pelgrim/domain/repositories/duty_repository.dart';

class DutyRepositoryImpl implements DutyRepository {
  final DutyDataSource _dutyDataSource;

  DutyRepositoryImpl(this._dutyDataSource);

  @override
  Future<void> addDuty(String groupName, Duty duty) {
    try {
      return _dutyDataSource.addDuty(groupName, DutyModel.fromEntity(duty));
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }

  @override
  Future<void> deleteDuty(String groupName, String dutyId) {
    try {
      return _dutyDataSource.deleteDuty(groupName, dutyId);
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }

  @override
  Stream<List<Duty>> getDutiesStream(String groupName) {
    try {
      return _dutyDataSource
          .getDutiesStream(groupName)
          .map((models) => models.map((e) => e.toEntity()).toList());
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }

  @override
  Future<void> addVolunteer(String groupId, String dutyId, DutyVolunteer volunteer) {
    try {
      return _dutyDataSource.addVolunteer(
          groupId, dutyId, DutyVolunteerModel.fromEntity(volunteer));
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }

  @override
  Future<void> removeVolunteer(String groupId, String dutyId, DutyVolunteer volunteer) {
    try {
      return _dutyDataSource.removeVolunteer(
          groupId, dutyId, DutyVolunteerModel.fromEntity(volunteer));
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }
}
