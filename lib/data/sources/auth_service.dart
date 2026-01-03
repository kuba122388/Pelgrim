import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelgrim/data/models/my_user_model.dart';
import 'package:pelgrim/data/sources/user_service.dart';
import 'package:pelgrim/core/di/service_locator.dart';
import 'package:pelgrim/domain/entities/group_info.dart';
import 'package:pelgrim/domain/entities/my_user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final UserService _userService = sl<UserService>();

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<UserCredential> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> registerAdminWithGroup({
    required MyUserModel user,
    required String password,
    required GroupInfo group,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      await _userService.registerAdminWithGroup(user, group);
    } catch (e) {
      if (userCredential?.user != null) {
        await userCredential!.user!.delete();
      }
      rethrow;
    }
  }

  Future<void> registerAndJoinGroup({
    required MyUserModel user,
    required String password,
    required String groupName,
  }) async {
    UserCredential? userCredential;
    try {
      userCredential = await _auth.createUserWithEmailAndPassword(
        email: user.email,
        password: password,
      );

      await _userService.registerAndJoinGroup(user, groupName);
    } catch (e) {
      if (userCredential?.user != null) {
        await userCredential!.user!.delete();
      }
      rethrow;
    }
  }
}
