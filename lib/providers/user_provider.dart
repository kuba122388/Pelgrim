import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/core/di/service_locator.dart';
import 'package:pelgrim/domain/entities/group_info.dart';
import 'package:pelgrim/domain/entities/my_user.dart';
import 'package:pelgrim/data/sources/user_service.dart';

class UserProvider extends ChangeNotifier {
  final UserService _userService = sl<UserService>();
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  MyUser? _user;
  GroupInfo? _groupInfo;
  bool _isLoading = false;

  MyUser? get user => _user;

  GroupInfo? get groupInfo => _groupInfo;

  bool get isLoaded => _user != null && _groupInfo != null;

  bool get isLoading => _isLoading;

  void updateData({required MyUser user, required GroupInfo groupInfo}) {
    _user = user;
    _groupInfo = groupInfo;
    notifyListeners();
  }

  void clear() {
    _user = null;
    _groupInfo = null;
    notifyListeners();
  }

  Future<void> fetchAndSetUser(String email) async {
    _isLoading = true;
    notifyListeners();

    try {
      final group = await _userService.getUserGroup(email);
      _user = await _userService.getUserData(email, group);
    } catch (e) {
      _user = null;
      _groupInfo = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

}
