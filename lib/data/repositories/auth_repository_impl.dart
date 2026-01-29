import 'package:firebase_auth/firebase_auth.dart';
import 'package:pelgrim/core/errors/repository_exception.dart';
import 'package:pelgrim/data/datasources/remote/auth_data_source.dart';
import 'package:pelgrim/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl extends AuthRepository {
  final AuthDataSource _authDataSource;

  AuthRepositoryImpl(this._authDataSource);

  @override
  Future<String> register({required String email, required String password}) async {
    try {
      return await _authDataSource.register(email: email, password: password);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z rejestracją konta.");
    }
  }

  @override
  Future<String> signIn({required String email, required String password}) async {
    try {
      return await _authDataSource.signIn(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseAuthError(e);
      throw RepositoryException(message);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z logowaniem. $e");
    }
  }

  @override
  Future<void> deleteAccount(String uid) async {
    try {
      return await _authDataSource.deleteAccount(uid);
    } catch (e) {
      throw RepositoryException("Wystąpił problem z usunięciem konta.");
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _authDataSource.signOut();
    } catch (e) {
      throw RepositoryException("Nie udało się wylogować użytkownika.");
    }
  }

  @override
  String? getCurrentUserId() {
    return _authDataSource.getCurrentUserId();
  }

  @override
  Future<void> sendPasswordReset(String email) async {
    try {
      await _authDataSource.sendPasswordReset(email);
    } on FirebaseAuthException catch (e) {
      final message = _mapFirebaseAuthError(e);
      throw RepositoryException(message);
    } catch (e) {
      throw RepositoryException("Wystąpił nieoczekiwany błąd.");
    }
  }

  String _mapFirebaseAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Nie znaleziono użytkownika o tym adresie e-mail.';
      case 'invalid-email':
        return 'Adres e-mail jest nieprawidłowy.';
      case 'network-request-failed':
        return 'Brak połączenia z internetem.';
      case 'invalid-credential':
        throw "Email lub hasło nie są poprawne.";
      default:
        return 'Wystąpił błąd podczas resetowania hasła. Spróbuj ponownie później.';
    }
  }
}
