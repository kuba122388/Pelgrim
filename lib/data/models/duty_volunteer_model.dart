import 'package:pelgrim/domain/entities/duty_volunteer.dart';

class DutyVolunteerModel {
  final String userId;
  final String fullName;

  DutyVolunteerModel({
    required this.userId,
    required this.fullName,
  });

  Map<String, dynamic> toMap() {
    return {
      'user_id': userId,
      'full_name': fullName,
    };
  }

  factory DutyVolunteerModel.fromMap(Map<String, dynamic> map) {
    return DutyVolunteerModel(
      userId: map['user_id'] ?? "",
      fullName: map['full_name'] ?? "",
    );
  }

  factory DutyVolunteerModel.fromEntity(DutyVolunteer entity) {
    return DutyVolunteerModel(
      userId: entity.userId,
      fullName: entity.fullName,
    );
  }

  DutyVolunteer toEntity() {
    return DutyVolunteer(
      userId: userId,
      fullName: fullName,
    );
  }
}
