abstract class AuthRepository {
  Future<String> register({required String email, required String password});

  Future<String> signIn({required String email, required String password});

  Future<void> sendPasswordReset(String email);

  Future<void> deleteAccount(String uid);

  Future<void> signOut();

  String? getCurrentUserId();
}
