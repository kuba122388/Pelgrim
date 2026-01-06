import 'package:pelgrim/data/datasources/local/local_user_storage.dart';
import 'package:pelgrim/data/models/user_session_model.dart';
import 'package:pelgrim/domain/entities/user_session.dart';
import 'package:pelgrim/domain/repositories/user_session_repository.dart';

class UserSessionRepositoryImpl implements UserSessionRepository {
  final LocalUserStorage _localStorage;

  UserSessionRepositoryImpl(this._localStorage);

  @override
  Future<void> saveLocalSession(UserSession userSession) async {
    await _localStorage.saveSession(
      UserSessionModel.fromEntity(userSession),
    );
  }

  @override
  Future<void> clearSession() async {
    await _localStorage.clear();
  }

  @override
  Future<UserSession?> getLocalSession() async {
    final session = await _localStorage.loadSession();

    if (session == null) {
      return null;
    }

    return session.toEntity();
  }
}
