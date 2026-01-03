import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pelgrim/domain/entities/duty.dart';

import 'my_user_model.dart';

class DutyModel {
  final String? id;
  final String title;
  final int maxVolunteers;
  final List<MyUserModel> volunteers;
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
      'Title': title,
      'MaxVolunteers': maxVolunteers,
      'Volunteers': volunteers.map((v) => v.toMap()).toList(),
      'CreatedAt': createdAt,
    };
  }

  factory DutyModel.fromMap(Map<String, dynamic> map, String docId) {
    List<MyUserModel> parsedVolunteers = [];

    if (map["Volunteers"] != null) {
      parsedVolunteers = List<Map<String, dynamic>>.from(map["Volunteers"])
          .map((userMap) => MyUserModel.fromMap(userMap))
          .toList();
    }

    return DutyModel(
      id: docId,
      title: map["Title"] ?? "",
      maxVolunteers: map["MaxVolunteers"] ?? 0,
      volunteers: parsedVolunteers,
      createdAt: map["CreatedAt"] ?? Timestamp.now(),
    );
  }

  factory DutyModel.fromEntity(Duty duty) {
    return DutyModel(
      id: duty.id,
      createdAt: Timestamp.fromDate(duty.createdAt),
      maxVolunteers: duty.maxVolunteers,
      title: duty.title,
      volunteers: duty.volunteers.map((entity) => MyUserModel.fromEntity(entity)).toList(),
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
