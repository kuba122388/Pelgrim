import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/usecases/auth/is_user_authenticated_use_case.dart';
import 'package:pelgrim/domain/usecases/auth/sign_in_use_case.dart';
import 'package:pelgrim/domain/usecases/auth/sign_out_use_case.dart';
import 'package:pelgrim/domain/usecases/group/get_all_group_names_use_case.dart';
import 'package:pelgrim/domain/usecases/session/clear_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/load_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/save_local_session_use_case.dart';
import 'package:pelgrim/domain/usecases/session/sync_user_session_use_case.dart';
import 'package:pelgrim/domain/usecases/user/register_admin_create_group_use_case.dart';
import 'package:pelgrim/domain/usecases/user/register_user_join_group_use_case.dart';

class UserProvider extends ChangeNotifier {
  // Note: Usecases

  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final SaveLocalSessionUseCase _saveLocalSessionUseCase;
  final ClearLocalSessionUseCase _clearLocalSessionUseCase;
  final LoadLocalSessionUseCase _loadLocalSessionUseCase;
  final SyncUserSessionUseCase _syncUserSessionUseCase;
  final IsUserAuthenticatedUseCase _isUserAuthenticatedUseCase;
  final RegisterAdminCreateGroupUseCase _registerAdminCreateGroupUseCase;
  final RegisterUserJoinGroupUseCase _registerUserJoinGroupUseCase;
  final GetAllGroupNamesUseCase _getAllGroupNamesUseCase;

  UserProvider(
    this._signInUseCase,
    this._signOutUseCase,
    this._saveLocalSessionUseCase,
    this._clearLocalSessionUseCase,
    this._loadLocalSessionUseCase,
    this._syncUserSessionUseCase,
    this._isUserAuthenticatedUseCase,
    this._registerAdminCreateGroupUseCase,
    this._registerUserJoinGroupUseCase,
    this._getAllGroupNamesUseCase,
  );

  // Note: Variables

  UserSession? _userSession;

  bool _isLoading = true;

  User? get user => _userSession?.user;

  Group? get groupInfo => _userSession?.group;

  bool isLoggedIn() => _userSession != null;

  bool get isLoading => _isLoading;

  // Note: User Methods

  String get userGroupId => user!.groupId;

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
    try {
      _userSession = await _syncUserSessionUseCase.execute(currentUser.id);
      notifyListeners();
    } catch (e) {
      debugPrint("Synchronizacja nie udana");
    }
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

  // Note: Register methods

  Future<void> registerAdminCreateGroup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String groupColor,
    required String groupCity,
    required Color color,
    required Color secondColor,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserSession userSession = await _registerAdminCreateGroupUseCase.execute(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        groupColor: groupColor,
        groupCity: groupCity,
        color: color,
        secondColor: secondColor,
      );

      await _saveLocalSessionUseCase.execute(userSession);
      _userSession = userSession;
    } catch (_) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> registerUserJoinGroup({
    required String email,
    required String password,
    required String firstName,
    required String lastName,
    required String phone,
    required String groupId,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      final UserSession userSession = await _registerUserJoinGroupUseCase.execute(
        email: email,
        password: password,
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        groupId: groupId,
      );

      await _saveLocalSessionUseCase.execute(userSession);
      _userSession = userSession;
    } catch (_) {
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<String>> fetchAllGroups() async {
    try {
      return await _getAllGroupNamesUseCase.execute();
    } catch (e) {
      rethrow;
    }
  }
}
