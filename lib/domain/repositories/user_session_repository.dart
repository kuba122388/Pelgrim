import 'package:pelgrim/domain/entities/user_session.dart';

abstract class UserSessionRepository {
  Future<void> saveLocalSession(UserSession userSession);

  Future<UserSession?> getLocalSession();

  Future<void> clearLocalSession();
}
