import 'dart:ui';

class GroupInfo {
  final String groupName;
  final String groupColor;
  final String groupCity;
  final Color color;
  final Color secondColor;

  const GroupInfo({
    required this.groupColor,
    required this.groupCity,
    required this.color,
    required this.secondColor,
  }) : groupName = '$groupColor - $groupCity';

  Map<String, dynamic> toMap() {
    return {
      'groupColor': groupColor,
      'groupCity': groupCity,
      'color': color.toARGB32().toRadixString(16),
      'secondColor': secondColor.toARGB32().toRadixString(16),
    };
  }

  factory GroupInfo.fromJson(Map<String, dynamic> json) {
    return GroupInfo(
      groupColor: json["groupColor"],
      groupCity: json["groupCity"],
      color: Color(int.parse(json["color"], radix: 16)),
      secondColor: Color(int.parse(json["secondColor"], radix: 16)),
    );
  }
}
