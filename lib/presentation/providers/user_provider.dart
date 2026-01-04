import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pelgrim/domain/entities/group.dart';
import 'package:pelgrim/domain/entities/user.dart';
import 'package:pelgrim/data/datasources/user_datasource.dart';

class UserProvider extends ChangeNotifier {
  final UserDataSource _userService;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  UserProvider(this._userService);

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

  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
