import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/data/models/duty_volunteer_model.dart';
import 'package:pelgrim/domain/entities/duty.dart';

class DutyModel {
  final String? id;
  final String title;
  final int maxVolunteers;
  final List<DutyVolunteerModel> volunteers;
  final Timestamp createdAt;

  DutyModel({
    this.id,
    required this.title,
    required this.maxVolunteers,
    this.volunteers = const [],
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'max_volunteers': maxVolunteers,
      'volunteers': volunteers.map((v) => v.toMap()).toList(),
      'created_at': createdAt,
    };
  }

  factory DutyModel.fromMap(Map<String, dynamic> map, String docId) {
    List<DutyVolunteerModel> parsedVolunteers = [];

    if (map["volunteers"] != null) {
      parsedVolunteers = List<Map<String, dynamic>>.from(map["volunteers"])
          .map((userMap) => DutyVolunteerModel.fromMap(userMap))
          .toList();
    }

    return DutyModel(
      id: docId,
      title: map["title"] ?? "",
      maxVolunteers: map["max_volunteers"] ?? 0,
      volunteers: parsedVolunteers,
      createdAt: map["created_at"] ?? Timestamp.now(),
    );
  }

  factory DutyModel.fromEntity(Duty duty) {
    return DutyModel(
      id: duty.id,
      createdAt: Timestamp.fromDate(duty.createdAt),
      maxVolunteers: duty.maxVolunteers,
      title: duty.title,
      volunteers: duty.volunteers.map((entity) => DutyVolunteerModel.fromEntity(entity)).toList(),
    );
  }

  Duty toEntity() {
    return Duty(
        title: title,
        maxVolunteers: maxVolunteers,
        createdAt: createdAt.toDate(),
        id: id,
        volunteers: volunteers.map((v) => v.toEntity()).toList());
  }
}
