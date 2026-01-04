import 'package:pelgrim/domain/entities/user.dart';

class Duty {
  final String? id;
  final String title;
  final int maxVolunteers;
  final List<User> volunteers;
  final DateTime createdAt;

  Duty({
    this.id,
    required this.title,
    required this.maxVolunteers,
    this.volunteers = const [],
    required this.createdAt,
  });
}
