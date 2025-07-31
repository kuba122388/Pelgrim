import 'package:firebase_auth/firebase_auth.dart';

class Auth{
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  User? get currentUser => _firebaseAuth.currentUser;

  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();

  Future<void> signInWithEmailAndPassword({
    required String email,
    required String password,
}) async{
    await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
    );
  }

  Future<void> createUserWithEmailAndPassword({
    required String email,
    required String password,
}) async{
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email,
          password: password
      );
    }
    on FirebaseAuthException {
      rethrow;
    } catch (e) {
      throw Exception('Nieznany błąd: $e');
    }
  }

  Future<void> signOut() async{
    await _firebaseAuth.signOut();
  }

}