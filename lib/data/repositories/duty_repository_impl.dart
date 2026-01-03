import 'package:pelgrim/data/models/duty_model.dart';
import 'package:pelgrim/data/sources/duty_service.dart';
import 'package:pelgrim/domain/entities/duty.dart';
import 'package:pelgrim/domain/repositories/duty_repository.dart';

class DutyRepositoryImpl implements DutyRepository {
  final DutyService _dutyService;

  DutyRepositoryImpl(this._dutyService);

  @override
  Future<void> addDuty(String groupName, Duty duty) async {
    try {
      await _dutyService.addDuty(groupName, DutyModel.fromEntity(duty));
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }

  @override
  Future<void> deleteDuty(String groupName, String dutyId) async {
    try {
      await _dutyService.deleteDuty(groupName, dutyId);
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }

  @override
  Future<List<Duty>> loadDuties(String groupName) async {
    try {
      List<DutyModel> list = await _dutyService.loadDuties(groupName);
      return list.map((e) => e.toEntity()).toList();
    } catch (e) {
      throw Exception("Nie udało się dodać dyżuru: $e");
    }
  }
}
