import 'package:pelgrim/core/errors/repository_exception.dart';
import 'package:pelgrim/data/datasources/remote/group_datasource.dart';
import 'package:pelgrim/data/models/group_model.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';

class GroupRepositoryImpl extends GroupRepository {
  final GroupDataSource _groupDataSource;

  GroupRepositoryImpl(this._groupDataSource);

  @override
  Future<Group> getGroup(String groupId) async {
    try {
      GroupModel groupModel = await _groupDataSource.getGroup(groupId);
      return groupModel.toEntity();
    } catch (e) {
      throw Exception("Wystąpił problem z pobraniem danych grupy: $e");
    }
  }

  @override
  Future<void> createGroup(Group group) async {
    try {
      GroupModel groupModel = GroupModel.fromEntity(group);
      await _groupDataSource.createGroup(groupModel);
    } catch (e) {
      throw Exception("Wystąpił problem z utworzeniem grupy: $e");
    }
  }

  @override
  Future<List<String>> getAllGroupNames() async {
    try {
      return await _groupDataSource.getAllGroupNames();
    } catch (e) {
      throw Exception("Wystąpił problem z pobraniem grup: $e");
    }
  }

  @override
  Future<void> joinUserToGroup(
      {required String groupId, required String userId, required bool isAdmin}) async {
    try {
      await _groupDataSource.joinUserToGroup(groupId, userId, isAdmin);
    } catch (e) {
      throw Exception("Dołączenie użytkownika do grupy nie powiodło się: $e");
    }
  }

  @override
  Future<void> setAdminStatus({
    required String groupId,
    required String userId,
    required bool isAdmin,
  }) async {
    try {
      await _groupDataSource.setAdminStatus(groupId, userId, isAdmin);
    } catch (e) {
      throw Exception("Nadawanie uprawnień nie powiodło się: $e");
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      await _groupDataSource.deleteGroup(groupId);
    } catch (e) {
      throw RepositoryException("Usuwanie grupy nie powiodło się: $e");
    }
  }
}
