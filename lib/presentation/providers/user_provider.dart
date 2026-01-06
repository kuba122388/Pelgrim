import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/usecases/group/get_group_use_case.dart';
import 'package:pelgrim/domain/usecases/session/save_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/user/sign_in_use_case.dart';
import 'package:pelgrim/domain/usecases/user/sign_out_use_case.dart';

class UserProvider extends ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetGroupUseCase _getGroupUseCase;
  final SaveLocalSessionUseCase _saveLocalSessionUseCase;

  UserProvider(
    this._signInUseCase,
    this._signOutUseCase,
    this._getGroupUseCase,
    this._saveLocalSessionUseCase,
  );

  User? _user;
  Group? _groupInfo;
  bool _isLoading = false;

  User? get user => _user;

  Group? get groupInfo => _groupInfo;

  bool get isLoaded => _user != null && _groupInfo != null;

  bool get isLoading => _isLoading;

  void updateData({required User user, required Group groupInfo}) {
    _user = user;
    _groupInfo = groupInfo;
    notifyListeners();
  }

  void clear() {
    _user = null;
    _groupInfo = null;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final user = await _signInUseCase.execute(
        email: email,
        password: password,
      );
      final group = await _getGroupUseCase.execute(user.groupId);

      final session = UserSession(user: user, group: group);
      await _saveLocalSessionUseCase.execute(session);

      _user = user;
      _groupInfo = group;
    } catch (e) {
      _user = null;
      _groupInfo = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _signOutUseCase.execute();
    clear();
  }
}
