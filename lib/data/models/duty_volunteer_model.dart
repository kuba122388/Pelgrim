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
      'userId': userId,
      'fullName': fullName,
    };
  }

  factory DutyVolunteerModel.fromMap(Map<String, dynamic> map) {
    return DutyVolunteerModel(
      userId: map['userId'],
      fullName: map['fullName'],
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
