import 'package:pelgrim/core/errors/repository_exception.dart';
import 'package:pelgrim/data/datasources/remote/group_data_source.dart';
import 'package:pelgrim/data/models/group_model.dart';
import 'package:pelgrim/data/models/user_model.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/repositories/group_repository.dart';

class GroupRepositoryImpl extends GroupRepository {
  final GroupDataSource _groupDataSource;

  GroupRepositoryImpl(this._groupDataSource);

  @override
  Future<Group> getGroupById(String groupId) async {
    try {
      GroupModel groupModel = await _groupDataSource.getGroupById(groupId);
      return groupModel.toEntity();
    } catch (e) {
      throw Exception("Wystąpił problem z pobraniem danych grupy.");
    }
  }

  @override
  Future<Group> createGroup(Group group) async {
    try {
      final groupModel = GroupModel.create(
        groupColor: group.groupColor,
        groupCity: group.groupCity,
        color: group.color,
        secondColor: group.secondColor,
      );
      await _groupDataSource.createGroup(groupModel);

      return groupModel.toEntity();
    } catch (e) {
      throw Exception("Wystąpił problem z utworzeniem grupy.");
    }
  }

  @override
  Future<List<Group>> getAllGroups() async {
    try {
      final list = await _groupDataSource.getAllGroups();
      return list.map((m) => m.toEntity()).toList();
    } catch (e) {
      throw Exception("Wystąpił problem z pobraniem grup.");
    }
  }

  @override
  Future<void> joinUserToGroup({required String groupId, required User user}) async {
    try {
      await _groupDataSource.joinUserToGroup(groupId, UserModel.fromEntity(user));
    } catch (e) {
      throw Exception("Dołączenie użytkownika do grupy nie powiodło się.");
    }
  }

  @override
  Future<void> setAdminStatus({
    required String groupId,
    required User user,
    required bool isAdmin,
  }) async {
    try {
      await _groupDataSource.setAdminStatus(groupId, UserModel.fromEntity(user), isAdmin);
    } catch (e) {
      throw Exception("Nadawanie uprawnień nie powiodło się.");
    }
  }

  @override
  Future<void> deleteGroup(String groupId) async {
    try {
      await _groupDataSource.deleteGroup(groupId);
    } catch (e) {
      throw RepositoryException("Usuwanie grupy nie powiodło się.");
    }
  }
}
