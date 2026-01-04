import 'package:pelgrim/data/models/group_model.dart';
import 'package:pelgrim/data/datasources/group_datasource.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/repositories/group_info_repository.dart';

class GroupRepositoryImpl extends GroupRepository {
  final GroupDataSource _groupInfoService;

  GroupRepositoryImpl(this._groupInfoService);

  @override
  Future<Group> getGroup(String groupName) async {
    try {
      GroupModel groupModel = await _groupInfoService.getGroupInfo(groupName);
      return groupModel.toEntity();
    } catch (e) {
      throw Exception("Wystąpił problem z pobieraniem danych grupy: $e");
    }
  }

  @override
  Future<void> createGroup(Group group) {
    // TODO: implement createGroup
    throw UnimplementedError();
  }

  @override
  Future<void> joinUserToGroup(String groupId, String userId) {
    // TODO: implement joinUserToGroup
    throw UnimplementedError();
  }
}
