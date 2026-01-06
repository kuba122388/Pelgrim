import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> register({required String email, required String password}) async {
    final userCredential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.uid;
  }

  Future<String> signIn({required String email, required String password}) async {
    final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  Future<void> deleteAccount(String uid) async {
    final user = _auth.currentUser;
    if (user != null && user.uid == uid) {
      await user.delete();
    }
  }

  Future<void> signOut() async => await _auth.signOut();
}
