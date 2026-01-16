import 'package:firebase_auth/firebase_auth.dart';

class AuthDataSource {
  final FirebaseAuth _auth;

  const AuthDataSource(this._auth);

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

  String? getCurrentUserId() {
    return _auth.currentUser?.uid;
  }

  Future<void> signOut() async => await _auth.signOut();

  Future<void> sendPasswordReset(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthException(e);
    } catch (e) {
      throw Exception('Wystąpił nieoczekiwany błąd');
    }
  }

  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Nie znaleziono użytkownika o tym adresie e-mail.';
      case 'invalid-email':
        return 'Adres e-mail jest nieprawidłowy.';
      default:
        return 'Błąd podczas resetowania hasła. Spróbuj ponownie.';
    }
  }
}
