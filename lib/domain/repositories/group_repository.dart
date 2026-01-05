import 'package:pelgrim/domain/entities/group.dart';

abstract class GroupRepository {
  Future<void> createGroup(Group group);

  Future<Group> getGroup(String groupId);

  Future<List<String>> getAllGroupNames();

  Future<void> joinUserToGroup({
    required String groupId,
    required String userId,
    required bool isAdmin,
  });

  Future<void> setAdminStatus({
    required String groupId,
    required String userId,
    required bool isAdmin,
  });
}
