import 'dart:ui';

import 'package:hive/hive.dart';
import 'package:pelgrim/domain/entities/group.dart';

part 'group_model.g.dart';

@HiveType(typeId: 1)
class GroupModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String groupColor;

  @HiveField(2)
  final String groupCity;

  @HiveField(3)
  final Color color;

  @HiveField(4)
  final Color secondColor;

  GroupModel({
    required this.id,
    required this.groupColor,
    required this.groupCity,
    required this.color,
    required this.secondColor,
  });

  Map<String, dynamic> toMap() {
    return {
      'group_color': groupColor,
      'group_city': groupCity,
      'color': color.toARGB32().toRadixString(16),
      'second_color': secondColor.toARGB32().toRadixString(16),
    };
  }

  factory GroupModel.fromMap(Map<String, dynamic> json) {
    return GroupModel(
      id: json["id"] ?? "",
      groupColor: json["group_color"] ?? "",
      groupCity: json["group_city"] ?? "",
      color: Color(int.parse(json["color"] ?? const Color(0xFF000000), radix: 16)),
      secondColor: Color(int.parse(json["second_color"] ?? const Color(0xFFFFFFFF), radix: 16)),
    );
  }

  factory GroupModel.fromEntity(Group entity) {
    if (entity.id == null) {
      throw Exception('Group entity has no id.');
    }

    return GroupModel(
      id: entity.id!,
      groupCity: entity.groupCity,
      groupColor: entity.groupColor,
      secondColor: entity.secondColor,
      color: entity.color,
    );
  }

  factory GroupModel.create({
    required String groupColor,
    required String groupCity,
    required Color color,
    required Color secondColor,
  }) {
    return GroupModel(
      id: _convertGroupId(groupColor, groupCity),
      groupColor: groupColor,
      groupCity: groupCity,
      color: color,
      secondColor: secondColor,
    );
  }

  GroupModel copyWith({
    String? id,
    String? groupColor,
    String? groupCity,
    Color? color,
    Color? secondColor,
  }) {
    return GroupModel(
      id: id ?? this.id,
      groupColor: groupColor ?? this.groupColor,
      groupCity: groupCity ?? this.groupCity,
      color: color ?? this.color,
      secondColor: secondColor ?? this.secondColor,
    );
  }

  Group toEntity() {
    return Group(
      id: id,
      color: color,
      secondColor: secondColor,
      groupColor: groupColor,
      groupCity: groupCity,
    );
  }
}

String _convertGroupId(String groupColor, String groupCity) {
  String groupId = "${groupColor}_$groupCity";
  String result = groupId.toLowerCase();

  const polishChars = 'ąćęłńóśźż';
  const latinChars = 'acelnoszz';

  for (int i = 0; i < polishChars.length; i++) {
    result = result.replaceAll(polishChars[i], latinChars[i]);
  }

  result = result.replaceAll(" ", "_").replaceAll("-", "_");
  result = result.replaceAll(RegExp(r'_+'), '_');

  return result;
}
