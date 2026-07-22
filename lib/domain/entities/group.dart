import 'dart:ui';

class Group {
  final String? id;
  final String groupColor;
  final String groupCity;
  final Color color;
  final Color secondColor;

  String get name => "$groupColor - $groupCity";

  const Group({
    required this.id,
    required this.groupColor,
    required this.groupCity,
    required this.color,
    required this.secondColor,
  });
}
