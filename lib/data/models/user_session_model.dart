import 'package:hive/hive.dart';
import 'package:pelgrim/data/models/group_model.dart';
import 'package:pelgrim/data/models/user_model.dart';
import 'package:pelgrim/domain/entities/user_session.dart';

part 'user_session_model.g.dart';

@HiveType(typeId: 3)
class UserSessionModel {
  @HiveField(0)
  final UserModel user;

  @HiveField(1)
  final GroupModel group;

  UserSessionModel({
    required this.user,
    required this.group,
  });

  UserSession toEntity() => UserSession(
        user: user.toEntity(),
        group: group.toEntity(),
      );

  factory UserSessionModel.fromEntity(UserSession entity) => UserSessionModel(
        user: UserModel.fromEntity(entity.user),
        group: GroupModel.fromEntity(entity.group),
      );
}
