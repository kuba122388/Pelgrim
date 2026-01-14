import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final FirebaseAuth auth;

  const AuthDataSource(this.auth);

  Future<String> register({required String email, required String password}) async {
    final userCredential = await auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return userCredential.user!.uid;
  }

  Future<String> signIn({required String email, required String password}) async {
    final userCredential = await auth.signInWithEmailAndPassword(email: email, password: password);
    return userCredential.user!.uid;
  }

  Future<void> deleteAccount(String uid) async {
    final user = auth.currentUser;
    if (user != null && user.uid == uid) {
      await user.delete();
    }
  }

  String? getCurrentUserId() {
    return auth.currentUser?.uid;
  }

  Future<void> signOut() async => await auth.signOut();
}
