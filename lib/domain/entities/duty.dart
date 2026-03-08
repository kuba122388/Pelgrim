import 'package:pelgrim/domain/entities/duty_volunteer.dart';

class Duty {
  final String? id;
  final String title;
  final int maxVolunteers;
  final List<DutyVolunteer> volunteers;
  final DateTime createdAt;

  Duty({
    this.id,
    required this.title,
    required this.maxVolunteers,
    this.volunteers = const [],
    required this.createdAt,
  });

  bool get isFull => volunteers.length >= maxVolunteers;

  int get remainingSlots => maxVolunteers - volunteers.length;
}
