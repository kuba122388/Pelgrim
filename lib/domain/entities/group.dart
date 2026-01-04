import 'dart:ui';

class Group {
  final String groupColor;
  final String groupCity;
  final Color color;
  final Color secondColor;

  String get groupName => '$groupColor - $groupCity';

  const Group({
    required this.groupColor,
    required this.groupCity,
    required this.color,
    required this.secondColor,
  });
}
