import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/usecases/user/get_user_by_id_use_case.dart';

import '../../domain/usecases/group/set_admin_status_use_case.dart';
import '../../domain/usecases/user/get_all_users_by_group_use_case.dart';

class AllUsersProvider extends ChangeNotifier {
  final GetAllUsersByGroupUseCase _getAllUsersByGroupUseCase;
  final SetAdminStatusUseCase _setAdminStatusUseCase;
  final GetUserByIdUseCase _getUserByIdUseCase;

  AllUsersProvider(
    this._getAllUsersByGroupUseCase,
    this._setAdminStatusUseCase,
    this._getUserByIdUseCase,
  );

  List<User> _users = [];
  bool _isLoading = false;

  List<User> get users => _users;

  bool get isLoading => _isLoading;

  Future<void> loadUsers(String groupId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _users = await _getAllUsersByGroupUseCase.execute(groupId);
    } catch (e) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> changeAdminStatus({
    required String currentUserId,
    required String groupId,
    required User targetUser,
    required bool isAdmin,
  }) async {
    await _setAdminStatusUseCase.execute(
      currentUserId: currentUserId,
      groupId: groupId,
      targetUser: targetUser,
      isAdmin: isAdmin,
    );

    await loadUsers(groupId);
  }

  Future<User> getUser(String userId) async {
    try {
      return await _getUserByIdUseCase.execute(userId);
    } catch (e) {
      rethrow;
    }
  }
}
