import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';

abstract class GroupRepository {
  Future<Group> createGroup(Group group);

  Future<Group> getGroupById(String groupId);

  Future<List<Group>> getAllGroups();

  Future<void> joinUserToGroup({
    required String groupId,
    required User user,
  });

  Future<void> setAdminStatus({
    required String groupId,
    required User user,
    required bool isAdmin,
  });

  Future<void> deleteGroup(String groupId);
}
