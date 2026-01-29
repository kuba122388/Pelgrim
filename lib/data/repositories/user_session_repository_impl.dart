import 'package:pelgrim/core/errors/repository_exception.dart';
import 'package:pelgrim/data/datasources/local/local_user_storage.dart';
import 'package:pelgrim/data/models/user_session_model.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/user_session_repository.dart';

class UserSessionRepositoryImpl implements UserSessionRepository {
  final LocalUserStorage _localStorage;

  UserSessionRepositoryImpl(
    this._localStorage,
  );

  @override
  Future<void> saveLocalSession(UserSession userSession) async {
    try {
      await _localStorage.saveSession(
        UserSessionModel.fromEntity(userSession),
      );
    } catch (e) {
      throw RepositoryException("Wystąpił problem z zapisaniem aktualnej sesji użytkownika.");
    }
  }

  @override
  Future<void> clearLocalSession() async {
    try {
      await _localStorage.clear();
    } catch (e) {
      throw RepositoryException("Wystąpił problem z wyczyszczniem sesji.");
    }
  }

  @override
  Future<UserSession?> getLocalSession() async {
    try {
      final session = await _localStorage.loadSession();

      if (session == null) {
        return null;
      }

      return session.toEntity();
    } catch (e) {
      throw RepositoryException("Wystąpił problem z pobraniem zapisanej sesji.");
    }
  }
}
