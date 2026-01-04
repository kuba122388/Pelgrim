import 'package:pelgrim/domain/entities/group.dart';

abstract class GroupRepository {
  Future<void> createGroup(Group group);

  Future<void> joinUserToGroup(String groupId, String userId);

  Future<Group> getGroup(String groupName);
}
