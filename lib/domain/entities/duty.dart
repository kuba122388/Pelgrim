import 'package:pelgrim/domain/entities/my_user.dart';

class Duty {
  final String? id;
  final String title;
  final int maxVolunteers;
  final List<MyUser> volunteers;
  final DateTime createdAt;

  Duty({
    this.id,
    required this.title,
    required this.maxVolunteers,
    this.volunteers = const [],
    required this.createdAt,
  });
}
