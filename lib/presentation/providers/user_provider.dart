import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/usecases/auth/is_user_authenticated_use_case.dart';
import 'package:pelgrim/domain/usecases/auth/sign_in_use_case.dart';
import 'package:pelgrim/domain/usecases/auth/sign_out_use_case.dart';
import 'package:pelgrim/domain/usecases/group/get_group_use_case.dart';
import 'package:pelgrim/domain/usecases/session/clear_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/load_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/save_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/sync_user_session_use_case.dart';

class UserProvider extends ChangeNotifier {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final GetGroupUseCase _getGroupUseCase;
  final SaveLocalSessionUseCase _saveLocalSessionUseCase;
  final ClearLocalSessionUseCase _clearLocalSessionUseCase;
  final LoadLocalSessionUseCase _loadLocalSessionUseCase;
  final SyncUserSessionUseCase _syncUserSessionUseCase;
  final IsUserAuthenticatedUseCase _isUserAuthenticatedUseCase;

  UserProvider(
    this._signInUseCase,
    this._signOutUseCase,
    this._getGroupUseCase,
    this._saveLocalSessionUseCase,
    this._clearLocalSessionUseCase,
    this._loadLocalSessionUseCase,
    this._syncUserSessionUseCase,
    this._isUserAuthenticatedUseCase,
  );

  UserSession? _userSession;

  bool _isLoading = false;

  User? get user => _userSession?.user;

  Group? get groupInfo => _userSession?.group;

  bool isLoggedIn() => _userSession != null;

  bool get isLoading => _isLoading;

  String? get authenticatedUserId => _isUserAuthenticatedUseCase.execute();

  Future<void> signIn({required String email, required String password}) async {
    _isLoading = true;
    notifyListeners();

    try {
      final userSession = await _signInUseCase.execute(
        email: email,
        password: password,
      );

      await _saveLocalSessionUseCase.execute(userSession);

      _userSession = userSession;
    } catch (e) {
      _userSession = null;
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final session = await _loadLocalSessionUseCase.execute();
      if (session != null) {
        _userSession = session;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> syncUserSessionWithRemote() async {
    final currentUser = user;

    if (currentUser == null) return;

    _userSession = await _syncUserSessionUseCase.execute(currentUser.id);
    notifyListeners();
  }

  Future<void> signOut() async {
    await _signOutUseCase.execute();
    await _clearLocalSessionUseCase.execute();
    _userSession = null;
    notifyListeners();
  }

  void clear() {
    _userSession = null;
    notifyListeners();
  }
}
