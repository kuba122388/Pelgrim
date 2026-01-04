import 'package:pelgrim/core/errors/RepositoryException.dart';
import 'package:pelgrim/data/datasources/auth_datasource.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<String> register(String email, String password) async {
    try {
      return await _authDataSource.register(email: email, password: password);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z rejestracją konta: $e");
    }
  }

  @override
  Future<String> signIn(String email, String password) async {
    try {
      return await _authDataSource.signIn(email: email, password: password);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z logowaniem: $e");
    }
  }

  @override
  Future<void> deleteAccount(String uid) async {
    try {
      return await _authDataSource.deleteAccount(uid);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z usunięciem konta: $e");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authDataSource.signOut();
    } catch (e) {
      throw RepositoryException("Nie udało się wylogować użytkownika: $e");
    }
  }
}
