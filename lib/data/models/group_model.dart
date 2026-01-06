import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:pelgrim/domain/entities/group.dart';

part 'group_model.g.dart';

@HiveType(typeId: 1)
class GroupModel extends HiveObject {
  @HiveField(0)
  final String groupColor;

  @HiveField(1)
  final String groupCity;

  @HiveField(2)
  final Color color;

  @HiveField(3)
  final Color secondColor;

  GroupModel({
    required this.groupColor,
    required this.groupCity,
    required this.color,
    required this.secondColor,
  });

  String get id => '$groupColor - $groupCity';

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

  factory GroupModel.fromEntity(Group entity) {
    return GroupModel(
      groupCity: entity.groupCity,
      groupColor: entity.groupColor,
      secondColor: entity.secondColor,
      color: entity.color,
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
