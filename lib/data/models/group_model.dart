import 'dart:ui';

import 'package:pelgrim/domain/entities/group.dart';

class GroupModel {
  final String groupColor;
  final String groupCity;
  final Color color;
  final Color secondColor;

  const GroupModel({
    required this.groupColor,
    required this.groupCity,
    required this.color,
    required this.secondColor,
  });

  String get groupName => '$groupColor - $groupCity';

  Map<String, dynamic> toMap() {
    return {
      'groupColor': groupColor,
      'groupCity': groupCity,
      'color': color.toARGB32().toRadixString(16),
      'secondColor': secondColor.toARGB32().toRadixString(16),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> json) {
    return GroupModel(
      groupColor: json["groupColor"],
      groupCity: json["groupCity"],
      color: Color(int.parse(json["color"], radix: 16)),
      secondColor: Color(int.parse(json["secondColor"], radix: 16)),
    );
  }

  Group toEntity() {
    return Group(
      color: color,
      secondColor: secondColor,
      groupColor: groupColor,
      groupCity: groupCity,
    );
  }
}
