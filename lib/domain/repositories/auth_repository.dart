abstract class AuthRepository {
  Future<String> register(String email, String password);

  Future<String> signIn(String email, String password);

  Future<void> deleteAccount(String uid);

  Future<void> signOut();
}
